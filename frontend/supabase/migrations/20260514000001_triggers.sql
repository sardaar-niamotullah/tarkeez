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
  oauth_name text;
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
      WHEN length(oauth_name) < 3 THEN
        oauth_name || repeat('x', 3 - length(oauth_name))
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
-- Prevent ID updates on tables
-- =================================================================
create or replace function public.prevent_id_update()
returns trigger as $$
begin
  if new.id <> old.id then
    raise exception 'Updating id is not allowed.';
  end if;
  return new;
end;
$$ language plpgsql security definer;

create trigger lock_user_id
before update on public.users
for each row execute function public.prevent_id_update();

create trigger lock_project_color_id
before update on public.project_colors
for each row execute function public.prevent_id_update();

create trigger lock_project_id
before update on public.projects
for each row execute function public.prevent_id_update();

create trigger lock_daily_activiy_log_id
before update on public.daily_activity_log
for each row execute function public.prevent_id_update();