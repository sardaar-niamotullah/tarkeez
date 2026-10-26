-- =================================================================
-- auto-populate user row on new user signup
-- =================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
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
SECURITY DEFINER
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
--   local rollups: split_session(started_at, ended_at, utc_offset_minutes)
--   UTC rollups:   split_session(started_at, ended_at, 0)
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
-- =================================================================
CREATE OR REPLACE FUNCTION public.apply_session_to_rollups(
  p_user   UUID,
  p_start  TIMESTAMPTZ,
  p_end    TIMESTAMPTZ,
  p_offset INT,
  p_sign   INT
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

  INSERT INTO public.utc_daily_rollups AS r (user_id, utc_date, duration_seconds)
  SELECT p_user, s.day, p_sign * s.seconds
  FROM public.split_session(p_start, p_end, 0) AS s
  ON CONFLICT (user_id, utc_date) DO UPDATE
    SET duration_seconds = r.duration_seconds + EXCLUDED.duration_seconds;

  DELETE FROM public.daily_rollups     WHERE user_id = p_user AND duration_seconds <= 0;
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
        NEW.user_id, NEW.started_at, NEW.ended_at, NEW.utc_offset_minutes, 1);
    END IF;
  ELSIF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
    PERFORM public.apply_session_to_rollups(
      OLD.user_id, OLD.started_at, OLD.ended_at, OLD.utc_offset_minutes, -1);
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
  DELETE FROM public.utc_daily_rollups WHERE user_id = p_user;

  INSERT INTO public.daily_rollups (user_id, date, duration_seconds)
  SELECT s.user_id, x.day, SUM(x.seconds)
  FROM public.sessions s
  CROSS JOIN LATERAL public.split_session(s.started_at, s.ended_at, s.utc_offset_minutes) x
  WHERE s.user_id = p_user AND s.deleted_at IS NULL
  GROUP BY s.user_id, x.day;

  INSERT INTO public.utc_daily_rollups (user_id, utc_date, duration_seconds)
  SELECT s.user_id, x.day, SUM(x.seconds)
  FROM public.sessions s
  CROSS JOIN LATERAL public.split_session(s.started_at, s.ended_at, 0) x
  WHERE s.user_id = p_user AND s.deleted_at IS NULL
  GROUP BY s.user_id, x.day;
END;
$$;

-- These must not be callable from the app (Supabase grants new functions to these roles).
REVOKE ALL ON FUNCTION public.apply_session_to_rollups(UUID, TIMESTAMPTZ, TIMESTAMPTZ, INT, INT)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.sessions_to_rollups() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.rebuild_rollups(UUID) FROM PUBLIC, anon, authenticated;