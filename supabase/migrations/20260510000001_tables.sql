-- =================================================================
-- USERS
-- =================================================================
-- TABLE
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    history_reset_at TIMESTAMPTZ
);

-- CONSTRAINTS
ALTER TABLE public.users
ADD CONSTRAINT full_name_length
CHECK (
  char_length(trim(full_name)) BETWEEN 3 AND 30
);

-- RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_select_own_data"
ON public.users
FOR SELECT
TO authenticated
USING (id = auth.uid());

CREATE POLICY "allow_update_own_data"
ON public.users
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- =================================================================
-- PROJECT TABLE and CONSTRAINTS
-- =================================================================
-- TABLE
CREATE TABLE public.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id),
    name TEXT NOT NULL,
    color_id SMALLINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- INDEX
CREATE INDEX IF NOT EXISTS idx_projects_pull
  ON public.projects (user_id, updated_at);

-- CONSTRAINTS
ALTER TABLE public.projects
ADD CONSTRAINT projects_name_length_check
CHECK (char_length(trim(name)) BETWEEN 3 AND 30);

ALTER TABLE public.projects
ADD CONSTRAINT projects_color_id_check
CHECK (color_id BETWEEN 0 AND 20);

-- RLS
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_select_own_projects"
ON public.projects
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "allow_insert_own_projects"
ON public.projects
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "allow_update_own_projects"
ON public.projects
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "allow_delete_own_projects"
ON public.projects
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- =================================================================
-- SESSIONS
-- =================================================================
-- TABLE
CREATE TABLE public.sessions (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.users(id),
    project_id UUID REFERENCES public.projects(id),
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NOT NULL,
    utc_offset_minutes SMALLINT NOT NULL,
    deleted_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- INDEX
CREATE INDEX IF NOT EXISTS idx_sessions_pull
  ON public.sessions (user_id, updated_at);

-- CONSTRAINTS
ALTER TABLE public.sessions
ADD CONSTRAINT sessions_length_check
CHECK (ended_at > started_at AND ended_at - started_at <= INTERVAL '24 hours');

ALTER TABLE public.sessions
ADD CONSTRAINT sessions_offset_check
CHECK (utc_offset_minutes BETWEEN -840 AND 840);

-- Backstop only. push_changes resolves overlaps first (the longest session wins).
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA extensions;

ALTER TABLE public.sessions
ADD CONSTRAINT no_overlap
EXCLUDE USING gist (
  user_id WITH =,
  tstzrange(started_at, ended_at) WITH &&
) WHERE (deleted_at IS NULL);

-- RLS
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_select_own_sessions"
ON public.sessions
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "allow_insert_own_sessions"
ON public.sessions
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY "allow_update_own_sessions"
ON public.sessions
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "allow_delete_own_sessions"
ON public.sessions
FOR DELETE
TO authenticated
USING (user_id = auth.uid());


-- =================================================================
-- ROLLUPS
-- =================================================================
-- TABLE
CREATE TABLE public.daily_rollups (
    user_id UUID NOT NULL REFERENCES public.users(id),
    date DATE NOT NULL,
    duration_seconds INTEGER NOT NULL,
    PRIMARY KEY (user_id, date)
);

-- RLS
ALTER TABLE public.daily_rollups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_select_own_daily_rollups"
ON public.daily_rollups FOR SELECT TO authenticated
USING (user_id = auth.uid());

-- TABLE
CREATE TABLE public.utc_daily_rollups (
    user_id UUID NOT NULL REFERENCES public.users(id),
    utc_date DATE NOT NULL,
    duration_seconds INTEGER NOT NULL,
    PRIMARY KEY (user_id, utc_date)
);

-- RLS
ALTER TABLE public.utc_daily_rollups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_select_own_utc_daily_rollups"
ON public.utc_daily_rollups FOR SELECT TO authenticated
USING (user_id = auth.uid());