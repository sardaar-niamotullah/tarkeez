-- =================================================================
-- Page size: at most 200 rows per request, in both directions.
-- It matches _pageSize in the app's sync engine. A longer queue is
-- pushed in several requests, and a longer pull is read page by page.
-- =================================================================

-- =================================================================
-- push_changes: upsert projects first, then sessions. One savepoint per row.
-- Bad data (fails a constraint or has a wrong type) is rejected.
-- Any other error leaves the row pending on the device to retry.
--
-- Limit: at most 200 rows in p_projects and 200 in p_sessions.
--
-- Response:
--   applied  = saved (live or already deleted)
--   rejected = never acceptable: bad data, or older than the last history reset
--              (a project created before it, a session that ended before it)
--   dropped  = session lost an overlap, stored as deleted
-- =================================================================
DROP FUNCTION IF EXISTS public.push_changes(JSONB, JSONB);

CREATE FUNCTION public.push_changes(
  p_projects JSONB DEFAULT '[]'::JSONB,
  p_sessions JSONB DEFAULT '[]'::JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid      UUID := auth.uid();
  v_reset_at TIMESTAMPTZ;
  v_item     JSONB;
  v_id       UUID;
  v_created  TIMESTAMPTZ;
  v_project  UUID;
  v_started  TIMESTAMPTZ;
  v_ended    TIMESTAMPTZ;
  v_offset   INT;
  v_deleted  TIMESTAMPTZ;
  v_existing public.sessions%ROWTYPE;
  v_applied  UUID[] := '{}';
  v_rejected UUID[] := '{}';
  v_dropped  UUID[] := '{}';
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  IF jsonb_array_length(p_projects) > 200 OR jsonb_array_length(p_sessions) > 200 THEN
    RAISE EXCEPTION 'push_changes: at most 200 rows per list, send the rest in another request';
  END IF;

  SELECT u.history_reset_at INTO v_reset_at FROM public.users u WHERE u.id = v_uid;

  -- ---------------------------------------------------------------
  -- PROJECTS
  -- ---------------------------------------------------------------
  FOR v_item IN SELECT value FROM jsonb_array_elements(p_projects) LOOP
    v_id := NULL;  -- so a failed id cast never reuses the previous row's id
    BEGIN
      v_id      := (v_item ->> 'id')::UUID;
      v_created := (v_item ->> 'created_at')::TIMESTAMPTZ;

      -- created before the last "delete history": the device is stale
      IF v_reset_at IS NOT NULL AND v_created < v_reset_at THEN
        v_rejected := v_rejected || v_id;
        CONTINUE;
      END IF;

      INSERT INTO public.projects AS p (id, user_id, name, color_id, created_at, deleted_at)
      VALUES (
        v_id, v_uid, v_item ->> 'name', (v_item ->> 'color_id')::INT,
        v_created, (v_item ->> 'deleted_at')::TIMESTAMPTZ
      )
      ON CONFLICT (id) DO UPDATE
        SET name       = EXCLUDED.name,
            color_id   = EXCLUDED.color_id,
            deleted_at = COALESCE(p.deleted_at, EXCLUDED.deleted_at)  -- a tombstone is one-way
        WHERE p.user_id = v_uid;  -- created_at is set on first insert and never changed

      IF FOUND THEN
        v_applied := v_applied || v_id;
      ELSE
        v_rejected := v_rejected || v_id;
      END IF;
    EXCEPTION
      WHEN check_violation
        OR not_null_violation
        OR invalid_text_representation
        OR numeric_value_out_of_range
        OR datetime_field_overflow THEN
        -- bad data: retrying will never work, so reject it
        -- (if the id itself is unreadable, there is nothing to report)
        IF v_id IS NOT NULL THEN
          v_rejected := v_rejected || v_id;
        END IF;
      WHEN OTHERS THEN
        NULL;  -- transient error; the row stays pending on the device
    END;
  END LOOP;

  -- ---------------------------------------------------------------
  -- SESSIONS (immutable: only deleted_at can change)
  -- ---------------------------------------------------------------
  IF jsonb_array_length(p_sessions) > 0 THEN
    -- one push per user at a time, so two devices cannot race on overlaps
    PERFORM pg_advisory_xact_lock(hashtextextended(v_uid::TEXT, 0));
  END IF;

  FOR v_item IN SELECT value FROM jsonb_array_elements(p_sessions) LOOP
    v_id := NULL;
    BEGIN
      v_id      := (v_item ->> 'id')::UUID;
      v_project := (v_item ->> 'project_id')::UUID;
      v_started := date_trunc('second', (v_item ->> 'started_at')::TIMESTAMPTZ);
      v_ended   := date_trunc('second', (v_item ->> 'ended_at')::TIMESTAMPTZ);
      v_offset  := (v_item ->> 'utc_offset_minutes')::INT;
      v_deleted := (v_item ->> 'deleted_at')::TIMESTAMPTZ;

      -- the device is stale: this session ended before the last "delete history"
      IF v_reset_at IS NOT NULL AND v_ended < v_reset_at THEN
        v_rejected := v_rejected || v_id;
        CONTINUE;
      END IF;

      -- 1. The cloud already has this id (retry, or a delete coming from the device)
      SELECT * INTO v_existing FROM public.sessions WHERE id = v_id;
      IF FOUND THEN
        IF v_existing.user_id <> v_uid THEN
          v_rejected := v_rejected || v_id;
          CONTINUE;
        END IF;
        IF v_existing.deleted_at IS NULL AND v_deleted IS NOT NULL THEN
          UPDATE public.sessions SET deleted_at = v_deleted WHERE id = v_id;
        END IF;
        v_applied := v_applied || v_id;
        CONTINUE;
      END IF;

      -- 2. A tombstone for a session the cloud never saw: store it as deleted
      IF v_deleted IS NOT NULL THEN
        INSERT INTO public.sessions
          (id, user_id, project_id, started_at, ended_at, utc_offset_minutes, deleted_at)
        VALUES (v_id, v_uid, v_project, v_started, v_ended, v_offset, v_deleted);
        v_applied := v_applied || v_id;
        CONTINUE;
      END IF;

      -- 3. Overlap rule. The new session loses if any overlapping live session
      --    is longer, or equally long and earlier (then lower id).
      IF EXISTS (
        SELECT 1 FROM public.sessions o
        WHERE o.user_id = v_uid
          AND o.deleted_at IS NULL
          AND tstzrange(o.started_at, o.ended_at) && tstzrange(v_started, v_ended)
          AND NOT (
            (v_ended - v_started) > (o.ended_at - o.started_at)
            OR ((v_ended - v_started) = (o.ended_at - o.started_at)
                AND (v_started, v_id) < (o.started_at, o.id))
          )
      ) THEN
        INSERT INTO public.sessions
          (id, user_id, project_id, started_at, ended_at, utc_offset_minutes, deleted_at)
        VALUES (v_id, v_uid, v_project, v_started, v_ended, v_offset, NOW());
        v_dropped := v_dropped || v_id;
        CONTINUE;
      END IF;

      -- 4. The new session wins: drop everything it overlaps, then insert it
      UPDATE public.sessions s
      SET deleted_at = NOW()
      WHERE s.user_id = v_uid
        AND s.deleted_at IS NULL
        AND tstzrange(s.started_at, s.ended_at) && tstzrange(v_started, v_ended);

      INSERT INTO public.sessions
        (id, user_id, project_id, started_at, ended_at, utc_offset_minutes, deleted_at)
      VALUES (v_id, v_uid, v_project, v_started, v_ended, v_offset, NULL);
      v_applied := v_applied || v_id;

    EXCEPTION
      WHEN check_violation
        OR not_null_violation
        OR invalid_text_representation
        OR invalid_datetime_format
        OR numeric_value_out_of_range
        OR datetime_field_overflow THEN
        IF v_id IS NOT NULL THEN
          v_rejected := v_rejected || v_id;
        END IF;
      WHEN OTHERS THEN
        NULL;  -- transient (for example the project is not pushed yet): stays pending
    END;
  END LOOP;

  RETURN jsonb_build_object(
    'applied',  to_jsonb(v_applied),
    'rejected', to_jsonb(v_rejected),
    'dropped',  to_jsonb(v_dropped)
  );
END;
$$;

-- =================================================================
-- pull_projects: one page of at most 200 rows, read by (updated_at, id).
-- The cursor is the last row of the previous page (p_after, p_after_id), so
-- rows that share a timestamp are never split or skipped.
-- p_overlap makes the first page of a pull start 2 minutes before the
-- checkpoint (README, safety rule 5).
-- =================================================================
DROP FUNCTION IF EXISTS public.pull_projects(TIMESTAMPTZ, UUID, BOOLEAN, INT);

CREATE FUNCTION public.pull_projects(
  p_after     TIMESTAMPTZ DEFAULT NULL,
  p_after_id  UUID        DEFAULT NULL,
  p_overlap   BOOLEAN     DEFAULT FALSE,
  p_page_size INT         DEFAULT 200
)
RETURNS TABLE (
  id UUID, name TEXT, color_id INT,
  created_at TIMESTAMPTZ, deleted_at TIMESTAMPTZ, updated_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  WITH bounds AS (
    SELECT CASE WHEN p_after IS NULL THEN NULL::TIMESTAMPTZ
                WHEN p_overlap THEN p_after - INTERVAL '2 minutes'
                ELSE p_after END AS after_ts,
           COALESCE(p_after_id, '00000000-0000-0000-0000-000000000000'::UUID) AS after_id
  )
  SELECT pr.id, pr.name, pr.color_id, pr.created_at, pr.deleted_at, pr.updated_at
  FROM public.projects pr, bounds b
  WHERE pr.user_id = auth.uid()
    AND (
      b.after_ts IS NULL
      OR (pr.updated_at >= b.after_ts          -- lets the index narrow the range
          AND (pr.updated_at, pr.id) > (b.after_ts, b.after_id))
    )
  ORDER BY pr.updated_at, pr.id
  LIMIT LEAST(GREATEST(p_page_size, 1), 200);
$$;

-- =================================================================
-- pull_sessions: same paging as pull_projects
-- =================================================================
DROP FUNCTION IF EXISTS public.pull_sessions(TIMESTAMPTZ, UUID, BOOLEAN, INT);

CREATE FUNCTION public.pull_sessions(
  p_after     TIMESTAMPTZ DEFAULT NULL,
  p_after_id  UUID        DEFAULT NULL,
  p_overlap   BOOLEAN     DEFAULT FALSE,
  p_page_size INT         DEFAULT 200
)
RETURNS TABLE (
  id UUID, project_id UUID, started_at TIMESTAMPTZ, ended_at TIMESTAMPTZ,
  utc_offset_minutes SMALLINT, deleted_at TIMESTAMPTZ, updated_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  WITH bounds AS (
    SELECT CASE WHEN p_after IS NULL THEN NULL::TIMESTAMPTZ
                WHEN p_overlap THEN p_after - INTERVAL '2 minutes'
                ELSE p_after END AS after_ts,
           COALESCE(p_after_id, '00000000-0000-0000-0000-000000000000'::UUID) AS after_id
  )
  SELECT se.id, se.project_id, se.started_at, se.ended_at,
         se.utc_offset_minutes, se.deleted_at, se.updated_at
  FROM public.sessions se, bounds b
  WHERE se.user_id = auth.uid()
    AND (
      b.after_ts IS NULL
      OR (se.updated_at >= b.after_ts
          AND (se.updated_at, se.id) > (b.after_ts, b.after_id))
    )
  ORDER BY se.updated_at, se.id
  LIMIT LEAST(GREATEST(p_page_size, 1), 200);
$$;

-- =================================================================
-- reset_history: hard-deletes everything the user has
-- (rollups, sessions, projects) and stamps users.history_reset_at.
-- Sessions are deleted before projects because they point at projects.
-- =================================================================
CREATE OR REPLACE FUNCTION public.reset_history()
RETURNS TIMESTAMPTZ
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid UUID := auth.uid();
  v_now TIMESTAMPTZ := NOW();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended(v_uid::TEXT, 0));

  DELETE FROM public.utc_daily_rollups WHERE user_id = v_uid;
  DELETE FROM public.daily_rollups     WHERE user_id = v_uid;
  DELETE FROM public.sessions          WHERE user_id = v_uid;
  DELETE FROM public.projects          WHERE user_id = v_uid;
  UPDATE public.users SET history_reset_at = v_now WHERE id = v_uid;

  RETURN v_now;
END;
$$;

-- =================================================================
-- Permissions: only signed-in users can call these functions
-- anon is revoked by name because Supabase grants it directly
-- =================================================================
REVOKE ALL ON FUNCTION public.push_changes(JSONB, JSONB) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.pull_projects(TIMESTAMPTZ, UUID, BOOLEAN, INT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.pull_sessions(TIMESTAMPTZ, UUID, BOOLEAN, INT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.reset_history() FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.push_changes(JSONB, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.pull_projects(TIMESTAMPTZ, UUID, BOOLEAN, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.pull_sessions(TIMESTAMPTZ, UUID, BOOLEAN, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reset_history() TO authenticated;