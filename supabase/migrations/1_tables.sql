-- =================================================================
-- APP VERSIONS
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.app_versions (
    platform TEXT PRIMARY KEY,
    latest_version TEXT NOT NULL,
    latest_build INTEGER NOT NULL,
    minimum_supported_build INTEGER NOT NULL,
    store_url TEXT NOT NULL,
    release_notes TEXT,
    update_notification_enabled BOOLEAN NOT NULL DEFAULT TRUE
);

-- CONSTRAINTS
ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_platform_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_platform_check
CHECK (platform IN ('android', 'ios', 'macos', 'windows', 'linux', 'web'));

-- Format: 1.2.3
ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_latest_version_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_latest_version_check
CHECK (latest_version ~ '^[0-9]+\.[0-9]+\.[0-9]+$');

ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_latest_build_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_latest_build_check
CHECK (latest_build >= 1);

-- The oldest build that may still run can never be newer than the latest build.
ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_minimum_supported_build_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_minimum_supported_build_check
CHECK (minimum_supported_build BETWEEN 1 AND latest_build);

ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_store_url_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_store_url_check
CHECK (store_url ~ '^https://');

ALTER TABLE public.app_versions DROP CONSTRAINT IF EXISTS app_versions_release_notes_length_check;
ALTER TABLE public.app_versions
ADD CONSTRAINT app_versions_release_notes_length_check
CHECK (release_notes IS NULL OR char_length(trim(release_notes)) BETWEEN 1 AND 1000);

-- RLS
ALTER TABLE public.app_versions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_app_versions" ON public.app_versions;
CREATE POLICY "allow_select_app_versions"
ON public.app_versions
FOR SELECT
TO authenticated
USING (true);

-- The app may only read. Rows are changed from the Supabase dashboard or the SQL editor.
REVOKE ALL ON public.app_versions FROM anon, authenticated;
GRANT SELECT ON public.app_versions TO authenticated;

-- SEED
-- Replace the URLs with the real store links.
INSERT INTO public.app_versions
    (platform, latest_version, latest_build, minimum_supported_build, store_url)
VALUES
    ('android', '1.0.0', 1, 1, 'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_ID'),
    ('ios',     '1.0.0', 1, 1, 'https://apps.apple.com/app/idYOUR_APP_ID'),
    ('macos',   '1.0.0', 1, 1, 'https://apps.apple.com/app/idYOUR_APP_ID'),
    ('windows', '1.0.0', 1, 1, 'https://example.com'),
    ('linux',   '1.0.0', 1, 1, 'https://example.com'),
    ('web',     '1.0.0', 1, 1, 'https://example.com')
ON CONFLICT (platform) DO NOTHING;

-- RELEASING A NEW VERSION (example)
-- UPDATE public.app_versions
-- SET latest_version = '1.1.0',
--     latest_build = 2,
--     release_notes = 'Pomodoro mode and a faster sync.'
-- WHERE platform = 'android';


-- =================================================================
-- USERS
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    history_reset_at TIMESTAMPTZ,
    premium_until TIMESTAMPTZ
);

-- FOREIGN KEYS
-- Deleting the auth user deletes the account and everything it owns.
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_id_fkey;
ALTER TABLE public.users
ADD CONSTRAINT users_id_fkey
FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- CONSTRAINTS
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS full_name_length;
ALTER TABLE public.users
ADD CONSTRAINT full_name_length
CHECK (char_length(trim(full_name)) BETWEEN 3 AND 30);

-- RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_data" ON public.users;
CREATE POLICY "allow_select_own_data"
ON public.users
FOR SELECT
TO authenticated
USING (id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "allow_update_own_data" ON public.users;
CREATE POLICY "allow_update_own_data"
ON public.users
FOR UPDATE
TO authenticated
USING (id = (SELECT auth.uid()))
WITH CHECK (id = (SELECT auth.uid()));

-- The app may only change full_name and avatar_url.
-- Backend functions write premium_until and history_reset_at.
REVOKE UPDATE ON public.users FROM authenticated;
GRANT UPDATE (full_name, avatar_url) ON public.users TO authenticated;

-- =================================================================
-- PROJECTS
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    name TEXT NOT NULL,
    color_id SMALLINT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- FOREIGN KEYS
ALTER TABLE public.projects DROP CONSTRAINT IF EXISTS projects_user_id_fkey;
ALTER TABLE public.projects
ADD CONSTRAINT projects_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- INDEX
CREATE INDEX IF NOT EXISTS idx_projects_pull
  ON public.projects (user_id, updated_at);

-- CONSTRAINTS
ALTER TABLE public.projects DROP CONSTRAINT IF EXISTS projects_name_length_check;
ALTER TABLE public.projects
ADD CONSTRAINT projects_name_length_check
CHECK (char_length(trim(name)) BETWEEN 3 AND 30);

ALTER TABLE public.projects DROP CONSTRAINT IF EXISTS projects_color_id_check;
ALTER TABLE public.projects
ADD CONSTRAINT projects_color_id_check
CHECK (color_id BETWEEN 0 AND 20);

-- Lets sessions point at (project, owner) so a session can only use its owner's project.
-- The sessions FK depends on this constraint, so it is dropped first (the sessions section adds it back).
ALTER TABLE IF EXISTS public.sessions DROP CONSTRAINT IF EXISTS sessions_project_owner_fkey;
ALTER TABLE public.projects DROP CONSTRAINT IF EXISTS projects_id_user_key;
ALTER TABLE public.projects
ADD CONSTRAINT projects_id_user_key
UNIQUE (id, user_id);

-- RLS
-- The app only reads projects. Every write goes through push_changes.
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_projects" ON public.projects;
CREATE POLICY "allow_select_own_projects"
ON public.projects
FOR SELECT
TO authenticated
USING (user_id = (SELECT auth.uid()));

-- =================================================================
-- SESSIONS
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.sessions (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    project_id UUID,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NOT NULL,
    utc_offset_minutes SMALLINT NOT NULL,
    deleted_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- FOREIGN KEYS
ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE public.sessions
ADD CONSTRAINT sessions_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- A session can only use a project of the same user. project_id is nullable (No Project).
-- No cascade here: a project is hard-deleted only by a history reset (which deletes sessions first)
-- or by an account deletion (the user_id cascades above).
ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_project_id_fkey;
ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_project_owner_fkey;
ALTER TABLE public.sessions
ADD CONSTRAINT sessions_project_owner_fkey
FOREIGN KEY (project_id, user_id) REFERENCES public.projects (id, user_id);

-- INDEX
CREATE INDEX IF NOT EXISTS idx_sessions_pull
  ON public.sessions (user_id, updated_at);

-- CONSTRAINTS
ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_length_check;
ALTER TABLE public.sessions
ADD CONSTRAINT sessions_length_check
CHECK (ended_at > started_at AND ended_at - started_at <= INTERVAL '24 hours');

ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS sessions_offset_check;
ALTER TABLE public.sessions
ADD CONSTRAINT sessions_offset_check
CHECK (utc_offset_minutes BETWEEN -840 AND 840);

-- Backstop only. push_changes resolves overlaps first (the longest session wins).
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA extensions;

ALTER TABLE public.sessions DROP CONSTRAINT IF EXISTS no_overlap;
ALTER TABLE public.sessions
ADD CONSTRAINT no_overlap
EXCLUDE USING gist (
  user_id WITH =,
  tstzrange(started_at, ended_at) WITH &&
) WHERE (deleted_at IS NULL);

-- RLS
-- The app only reads sessions. Every write goes through push_changes.
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_sessions" ON public.sessions;
CREATE POLICY "allow_select_own_sessions"
ON public.sessions
FOR SELECT
TO authenticated
USING (user_id = (SELECT auth.uid()));

-- =================================================================
-- ROLLUPS (filled by the trigger on sessions)
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.project_rollups (
    user_id UUID NOT NULL,
    date DATE NOT NULL,
    project_id TEXT NOT NULL,  -- '' = No Project, no FK to projects
    duration_seconds INTEGER NOT NULL,
    PRIMARY KEY (user_id, date, project_id)
);

-- FOREIGN KEYS
ALTER TABLE public.project_rollups DROP CONSTRAINT IF EXISTS project_rollups_user_id_fkey;
ALTER TABLE public.project_rollups
ADD CONSTRAINT project_rollups_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- RLS
ALTER TABLE public.project_rollups ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_project_rollups" ON public.project_rollups;
CREATE POLICY "allow_select_own_project_rollups"
ON public.project_rollups FOR SELECT TO authenticated
USING (user_id = (SELECT auth.uid()));

-- VIEW: a missing or deleted project counts as No Project ('')
CREATE OR REPLACE VIEW public.project_rollups_effective
WITH (security_invoker = true) AS
SELECT r.user_id, r.date,
       COALESCE(p.id::TEXT, '') AS project_id,
       SUM(r.duration_seconds)::INTEGER AS duration_seconds
FROM public.project_rollups r
LEFT JOIN public.projects p
  ON p.id::TEXT = r.project_id AND p.deleted_at IS NULL
GROUP BY r.user_id, r.date, COALESCE(p.id::TEXT, '');

-- TABLE
CREATE TABLE IF NOT EXISTS public.daily_rollups (
    user_id UUID NOT NULL,
    date DATE NOT NULL,
    duration_seconds INTEGER NOT NULL,
    PRIMARY KEY (user_id, date)
);

-- FOREIGN KEYS
ALTER TABLE public.daily_rollups DROP CONSTRAINT IF EXISTS daily_rollups_user_id_fkey;
ALTER TABLE public.daily_rollups
ADD CONSTRAINT daily_rollups_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- RLS
ALTER TABLE public.daily_rollups ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_daily_rollups" ON public.daily_rollups;
CREATE POLICY "allow_select_own_daily_rollups"
ON public.daily_rollups FOR SELECT TO authenticated
USING (user_id = (SELECT auth.uid()));

-- TABLE
CREATE TABLE IF NOT EXISTS public.utc_daily_rollups (
    user_id UUID NOT NULL,
    utc_date DATE NOT NULL,
    duration_seconds INTEGER NOT NULL,
    PRIMARY KEY (user_id, utc_date)
);

-- FOREIGN KEYS
ALTER TABLE public.utc_daily_rollups DROP CONSTRAINT IF EXISTS utc_daily_rollups_user_id_fkey;
ALTER TABLE public.utc_daily_rollups
ADD CONSTRAINT utc_daily_rollups_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- RLS
ALTER TABLE public.utc_daily_rollups ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_utc_daily_rollups" ON public.utc_daily_rollups;
CREATE POLICY "allow_select_own_utc_daily_rollups"
ON public.utc_daily_rollups FOR SELECT TO authenticated
USING (user_id = (SELECT auth.uid()));

-- =================================================================
-- PURCHASES (written only by backend functions)
-- =================================================================

-- TABLE
CREATE TABLE IF NOT EXISTS public.purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    source TEXT NOT NULL,
    store_ref TEXT NOT NULL,
    amount NUMERIC NOT NULL,
    currency TEXT NOT NULL,
    months INT NOT NULL,
    paid_at TIMESTAMPTZ NOT NULL,
    refunded_at TIMESTAMPTZ
);

-- FOREIGN KEYS
ALTER TABLE public.purchases DROP CONSTRAINT IF EXISTS purchases_user_id_fkey;
ALTER TABLE public.purchases
ADD CONSTRAINT purchases_user_id_fkey
FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- INDEX
CREATE INDEX IF NOT EXISTS idx_purchases_user_paid
  ON public.purchases (user_id, paid_at);

-- CONSTRAINTS
ALTER TABLE public.purchases DROP CONSTRAINT IF EXISTS purchases_source_check;
ALTER TABLE public.purchases
ADD CONSTRAINT purchases_source_check
CHECK (source IN ('google', 'apple', 'web'));

ALTER TABLE public.purchases DROP CONSTRAINT IF EXISTS purchases_months_check;
ALTER TABLE public.purchases
ADD CONSTRAINT purchases_months_check
CHECK (months IN (1, 3, 6, 12));

ALTER TABLE public.purchases DROP CONSTRAINT IF EXISTS purchases_store_ref_unique;
ALTER TABLE public.purchases
ADD CONSTRAINT purchases_store_ref_unique
UNIQUE (source, store_ref);

-- RLS: read only. There is no insert, update or delete policy, so the app cannot write.
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_select_own_purchases" ON public.purchases;
CREATE POLICY "allow_select_own_purchases"
ON public.purchases
FOR SELECT
TO authenticated
USING (user_id = (SELECT auth.uid()));

-- =================================================================
-- PRIVILEGES
-- The app only reads. projects and sessions are written by push_changes, the rollups by
-- triggers, purchases and premium_until by backend functions. Revoking the write privileges
-- as well as having no policies means a policy added by mistake later still cannot open a write.
-- =================================================================
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.projects, public.sessions
  FROM anon, authenticated;

REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON
  public.daily_rollups, public.project_rollups, public.utc_daily_rollups, public.purchases
  FROM anon, authenticated;

-- users: the app may only update full_name and avatar_url (granted above)
REVOKE INSERT, DELETE, TRUNCATE ON public.users FROM anon, authenticated;

-- Signed-out requests get nothing.
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;