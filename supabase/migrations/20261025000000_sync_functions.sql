-- =================================================================
-- push_changes: upsert projects, one savepoint per row
-- Bad data (fails a constraint or has a wrong type) is rejected.
-- Any other error leaves the row pending on the device to retry.
-- =================================================================
CREATE OR REPLACE FUNCTION public.push_changes(p_projects JSONB DEFAULT '[]'::JSONB)
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
  v_applied  UUID[] := '{}';
  v_rejected UUID[] := '{}';
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  SELECT u.history_reset_at INTO v_reset_at FROM public.users u WHERE u.id = v_uid;

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

  RETURN jsonb_build_object(
    'applied',  to_jsonb(v_applied),
    'rejected', to_jsonb(v_rejected)
  );
END;
$$;

-- =================================================================
-- pull_projects: rows stamped after p_after, in pages
-- A page always ends on a complete updated_at value, because one push stamps
-- all its rows with the same time and cutting through that group would lose rows.
-- p_overlap re-reads the last 2 minutes (for the first page of a pull only).
-- =================================================================
CREATE OR REPLACE FUNCTION public.pull_projects(
  p_after     TIMESTAMPTZ DEFAULT NULL,
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
                ELSE p_after END AS after_ts
  ),
  page AS (
    SELECT pr.updated_at
    FROM public.projects pr, bounds b
    WHERE pr.user_id = auth.uid()
      AND (b.after_ts IS NULL OR pr.updated_at > b.after_ts)
    ORDER BY pr.updated_at, pr.id
    LIMIT GREATEST(p_page_size, 1)
  )
  SELECT pr.id, pr.name, pr.color_id, pr.created_at, pr.deleted_at, pr.updated_at
  FROM public.projects pr, bounds b
  WHERE pr.user_id = auth.uid()
    AND (b.after_ts IS NULL OR pr.updated_at > b.after_ts)
    AND pr.updated_at <= (SELECT MAX(page.updated_at) FROM page)
  ORDER BY pr.updated_at, pr.id;
$$;

-- =================================================================
-- reset_history: for now it wipes projects only
-- When sessions sync, delete the user's sessions here and keep projects.
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

  DELETE FROM public.projects WHERE user_id = v_uid;
  UPDATE public.users SET history_reset_at = v_now WHERE id = v_uid;

  RETURN v_now;
END;
$$;

-- =================================================================
-- Permissions: only signed-in users can call these functions
-- anon is revoked by name because Supabase grants it directly
-- =================================================================
REVOKE ALL ON FUNCTION public.push_changes(JSONB) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.pull_projects(TIMESTAMPTZ, BOOLEAN, INT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.reset_history() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.push_changes(JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.pull_projects(TIMESTAMPTZ, BOOLEAN, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reset_history() TO authenticated;