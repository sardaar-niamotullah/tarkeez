-- =================================================================
-- Fires the function after every new user insert
-- =================================================================
DROP TRIGGER IF EXISTS create_user_after_user_signup ON auth.users;
CREATE TRIGGER create_user_after_user_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =================================================================
-- Fires the function before every update on each table
-- =================================================================
DROP TRIGGER IF EXISTS lock_user_id ON public.users;
CREATE TRIGGER lock_user_id
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

DROP TRIGGER IF EXISTS lock_project_id ON public.projects;
CREATE TRIGGER lock_project_id
  BEFORE UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

DROP TRIGGER IF EXISTS lock_sessions_id ON public.sessions;
CREATE TRIGGER lock_sessions_id
  BEFORE UPDATE ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

-- =================================================================
-- Fires the function before every project insert or update
-- =================================================================
DROP TRIGGER IF EXISTS set_projects_updated_at ON public.projects;
CREATE TRIGGER set_projects_updated_at
  BEFORE INSERT OR UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- =================================================================
-- Fires the function before every sessions insert or update
-- =================================================================
DROP TRIGGER IF EXISTS set_sessions_updated_at ON public.sessions;
CREATE TRIGGER set_sessions_updated_at
  BEFORE INSERT OR UPDATE ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- =================================================================
-- Fires the function after a live session is inserted or deleted_at is set.
-- It adds to or subtracts from daily_rollups and utc_daily_rollups.
-- =================================================================
DROP TRIGGER IF EXISTS sessions_feed_rollups ON public.sessions;
CREATE TRIGGER sessions_feed_rollups
  AFTER INSERT OR UPDATE OF deleted_at ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.sessions_to_rollups();