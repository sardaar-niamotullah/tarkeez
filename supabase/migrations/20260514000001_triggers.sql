-- =================================================================
-- Create user row in user table after user signup
-- =================================================================
-- Function: auto-populate user row on new user signup
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

-- Trigger: fires the function after every new user insert
CREATE TRIGGER create_user_after_user_signup
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =================================================================
-- Set updated_at on every write
-- Uses the database clock, not the device's, so every change lands after all device checkpoints.
-- =================================================================
-- Function: stamp the row with the database time
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Trigger: fires the function before every project insert or update
CREATE TRIGGER set_projects_updated_at
  BEFORE INSERT OR UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- =================================================================
-- Prevent ID updates on tables
-- =================================================================
-- Function: reject any update that changes the row id
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

-- Triggers: fire the function before every update on each table
CREATE TRIGGER lock_user_id
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();

CREATE TRIGGER lock_project_id
  BEFORE UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_id_update();