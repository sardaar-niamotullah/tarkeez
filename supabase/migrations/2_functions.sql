-- =================================================================
-- auto-populate user row on new user signup
-- =================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  oauth_name TEXT;
BEGIN
  oauth_name := NULLIF(TRIM(NEW.raw_user_meta_data->>'full_name'), '');

  INSERT INTO public.users (
    id,
    full_name,
    email,
    avatar_url
  )
  VALUES (
    NEW.id,
    CASE
      WHEN oauth_name IS NULL THEN 'xxx'
      WHEN LENGTH(oauth_name) < 3 THEN
        oauth_name || REPEAT('x', 3 - LENGTH(oauth_name))
      ELSE LEFT(oauth_name, 30)
    END,
    NEW.email,
    NEW.raw_user_meta_data->>'avatar_url'
  );

  RETURN NEW;
END;
$$;

-- =================================================================
-- Stamp the row with the database time
-- =================================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- =================================================================
-- Reject any update that changes the row id
-- =================================================================
CREATE OR REPLACE FUNCTION public.prevent_id_update()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  IF NEW.id <> OLD.id THEN
    RAISE EXCEPTION 'Updating id is not allowed.';
  END IF;
  RETURN NEW;
END;
$$;

-- =================================================================
-- split_session: one function, two calls (README: "How a session is split")
--   daily_rollups, project_rollups: split_session(started_at, ended_at, utc_offset_minutes)
--   utc_daily_rollups:              split_session(started_at, ended_at, 0)
-- Returns one row per day touched (at most two).
-- =================================================================
DROP FUNCTION IF EXISTS public.split_session(TIMESTAMPTZ, TIMESTAMPTZ, INT);

CREATE FUNCTION public.split_session(
  p_start          TIMESTAMPTZ,
  p_end            TIMESTAMPTZ,
  p_offset_minutes INT
)
RETURNS TABLE (day DATE, seconds INT)
LANGUAGE sql
IMMUTABLE
AS $$
  WITH shifted AS (
    SELECT (p_start AT TIME ZONE 'UTC') + make_interval(mins => p_offset_minutes) AS s,
           (p_end   AT TIME ZONE 'UTC') + make_interval(mins => p_offset_minutes) AS e
  )
  SELECT d::DATE AS day,
         EXTRACT(EPOCH FROM LEAST(sh.e, d + INTERVAL '1 day') - GREATEST(sh.s, d))::INT AS seconds
  FROM shifted sh,
       generate_series(date_trunc('day', sh.s), date_trunc('day', sh.e), INTERVAL '1 day') AS d
  WHERE sh.e > d AND sh.s < d + INTERVAL '1 day';   -- no empty slice when a session ends at midnight
$$;

-- =================================================================
-- apply_session_to_rollups: add (p_sign = 1) or subtract (p_sign = -1) one session
-- Feeds daily_rollups, project_rollups (local days) and utc_daily_rollups (UTC days).
-- p_project is NULL for a session with no project; it is stored as '' (No Project).
-- =================================================================
DROP FUNCTION IF EXISTS public.apply_session_to_rollups(UUID, TIMESTAMPTZ, TIMESTAMPTZ, INT, INT);  -- one-time cleanup, the signature now includes p_project
CREATE OR REPLACE FUNCTION public.apply_session_to_rollups(
  p_user    UUID,
  p_project UUID,
  p_start   TIMESTAMPTZ,
  p_end     TIMESTAMPTZ,
  p_offset  INT,
  p_sign    INT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.daily_rollups AS r (user_id, date, duration_seconds)
  SELECT p_user, s.day, p_sign * s.seconds
  FROM public.split_session(p_start, p_end, p_offset) AS s
  ON CONFLICT (user_id, date) DO UPDATE
    SET duration_seconds = r.duration_seconds + EXCLUDED.duration_seconds;

  INSERT INTO public.project_rollups AS r (user_id, date, project_id, duration_seconds)
  SELECT p_user, s.day, COALESCE(p_project::TEXT, ''), p_sign * s.seconds
  FROM public.split_session(p_start, p_end, p_offset) AS s
  ON CONFLICT (user_id, date, project_id) DO UPDATE
    SET duration_seconds = r.duration_seconds + EXCLUDED.duration_seconds;

  INSERT INTO public.utc_daily_rollups AS r (user_id, utc_date, duration_seconds)
  SELECT p_user, s.day, p_sign * s.seconds
  FROM public.split_session(p_start, p_end, 0) AS s
  ON CONFLICT (user_id, utc_date) DO UPDATE
    SET duration_seconds = r.duration_seconds + EXCLUDED.duration_seconds;

  DELETE FROM public.daily_rollups     WHERE user_id = p_user AND duration_seconds <= 0;
  DELETE FROM public.project_rollups   WHERE user_id = p_user AND duration_seconds <= 0;
  DELETE FROM public.utc_daily_rollups WHERE user_id = p_user AND duration_seconds <= 0;
END;
$$;

-- =================================================================
-- Trigger function for sessions:
--   live row inserted           -> add
--   deleted_at set (first time) -> subtract
-- A tombstone that arrives already deleted adds nothing.
-- =================================================================
CREATE OR REPLACE FUNCTION public.sessions_to_rollups()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.deleted_at IS NULL THEN
      PERFORM public.apply_session_to_rollups(
        NEW.user_id, NEW.project_id, NEW.started_at, NEW.ended_at, NEW.utc_offset_minutes, 1);
    END IF;
  ELSIF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
    PERFORM public.apply_session_to_rollups(
      OLD.user_id, OLD.project_id, OLD.started_at, OLD.ended_at, OLD.utc_offset_minutes, -1);
  END IF;
  RETURN NULL;
END;
$$;

-- =================================================================
-- rebuild_rollups: repair tool. Run it from the SQL editor, not from the app.
-- =================================================================
CREATE OR REPLACE FUNCTION public.rebuild_rollups(p_user UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.daily_rollups     WHERE user_id = p_user;
  DELETE FROM public.project_rollups   WHERE user_id = p_user;
  DELETE FROM public.utc_daily_rollups WHERE user_id = p_user;

  INSERT INTO public.daily_rollups (user_id, date, duration_seconds)
  SELECT s.user_id, x.day, SUM(x.seconds)
  FROM public.sessions s
  CROSS JOIN LATERAL public.split_session(s.started_at, s.ended_at, s.utc_offset_minutes) x
  WHERE s.user_id = p_user AND s.deleted_at IS NULL
  GROUP BY s.user_id, x.day;

  INSERT INTO public.project_rollups (user_id, date, project_id, duration_seconds)
  SELECT s.user_id, x.day, COALESCE(s.project_id::TEXT, ''), SUM(x.seconds)
  FROM public.sessions s
  CROSS JOIN LATERAL public.split_session(s.started_at, s.ended_at, s.utc_offset_minutes) x
  WHERE s.user_id = p_user AND s.deleted_at IS NULL
  GROUP BY s.user_id, x.day, COALESCE(s.project_id::TEXT, '');

  INSERT INTO public.utc_daily_rollups (user_id, utc_date, duration_seconds)
  SELECT s.user_id, x.day, SUM(x.seconds)
  FROM public.sessions s
  CROSS JOIN LATERAL public.split_session(s.started_at, s.ended_at, 0) x
  WHERE s.user_id = p_user AND s.deleted_at IS NULL
  GROUP BY s.user_id, x.day;
END;
$$;

-- =================================================================
-- rebuild_premium: recompute users.premium_until from all purchases
--   premium_until = max(paid_at, premium_until) + months * 1 month + months * 1 hour
-- Calendar months are added first (Jan 31 + 1 month = Feb 28), then the bonus hours. All in UTC.
-- =================================================================
CREATE OR REPLACE FUNCTION public.rebuild_premium(p_user UUID)
RETURNS TIMESTAMPTZ
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_until TIMESTAMPTZ;
  r       RECORD;
BEGIN
  -- one rebuild per user at a time
  PERFORM 1 FROM public.users WHERE id = p_user FOR NO KEY UPDATE;

  FOR r IN
    SELECT paid_at, months FROM public.purchases
    WHERE user_id = p_user AND refunded_at IS NULL
    ORDER BY paid_at, id
  LOOP
    v_until := (GREATEST(v_until, r.paid_at) AT TIME ZONE 'UTC'
                + make_interval(months => r.months, hours => r.months)) AT TIME ZONE 'UTC';
  END LOOP;

  UPDATE public.users SET premium_until = v_until WHERE id = p_user;
  RETURN v_until;
END;
$$;

-- =================================================================
-- grant_purchase: save one payment, then rebuild premium_until
-- A duplicate (same source + store_ref) is ignored. A store_ref that belongs
-- to another account is rejected.
-- =================================================================
CREATE OR REPLACE FUNCTION public.grant_purchase(
  p_user      UUID,
  p_source    TEXT,
  p_store_ref TEXT,
  p_amount    NUMERIC,
  p_currency  TEXT,
  p_months    INT,
  p_paid_at   TIMESTAMPTZ
)
RETURNS TIMESTAMPTZ
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.purchases (user_id, source, store_ref, amount, currency, months, paid_at)
  VALUES (p_user, p_source, p_store_ref, p_amount, p_currency, p_months, p_paid_at)
  ON CONFLICT (source, store_ref) DO NOTHING;

  IF NOT EXISTS (
    SELECT 1 FROM public.purchases
    WHERE source = p_source AND store_ref = p_store_ref AND user_id = p_user
  ) THEN
    RAISE EXCEPTION 'purchase belongs to another account';
  END IF;

  RETURN public.rebuild_premium(p_user);
END;
$$;

-- =================================================================
-- refund_purchase: mark one payment refunded (once), then rebuild premium_until
-- =================================================================
CREATE OR REPLACE FUNCTION public.refund_purchase(p_source TEXT, p_store_ref TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID;
BEGIN
  UPDATE public.purchases
  SET refunded_at = NOW()
  WHERE source = p_source AND store_ref = p_store_ref AND refunded_at IS NULL
  RETURNING user_id INTO v_user;

  IF v_user IS NOT NULL THEN
    PERFORM public.rebuild_premium(v_user);
  END IF;
END;
$$;

-- These must not be callable from the app (Supabase grants new functions to these roles).
REVOKE ALL ON FUNCTION public.apply_session_to_rollups(UUID, UUID, TIMESTAMPTZ, TIMESTAMPTZ, INT, INT)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.sessions_to_rollups() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.rebuild_rollups(UUID) FROM PUBLIC, anon, authenticated;

REVOKE ALL ON FUNCTION public.rebuild_premium(UUID) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.grant_purchase(UUID, TEXT, TEXT, NUMERIC, TEXT, INT, TIMESTAMPTZ)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.refund_purchase(TEXT, TEXT) FROM PUBLIC, anon, authenticated;