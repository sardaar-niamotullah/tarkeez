-- =================================================================
-- Fires the function after every new user insert 
-- =================================================================
CREATE TRIGGER create_user_after_user_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =================================================================
-- Fires the function before every update on each table  
-- =================================================================
CREATE TRIGGER lock_user_id
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

CREATE TRIGGER lock_project_id
  BEFORE UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

CREATE TRIGGER lock_sessions_id
  BEFORE UPDATE ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

-- =================================================================
-- Fires the function before every project insert or update 
-- =================================================================
CREATE TRIGGER set_projects_updated_at
  BEFORE INSERT OR UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- =================================================================
-- Fires the function before every sessions insert or update  
-- =================================================================
CREATE TRIGGER set_sessions_updated_at
  BEFORE INSERT OR UPDATE ON public.sessions
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();