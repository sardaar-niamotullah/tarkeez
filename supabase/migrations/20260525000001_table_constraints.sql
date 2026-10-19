-- =================================================================
-- USERS TABLE CONSTRAINTS
-- =================================================================
alter table public.users
add constraint full_name_length
check (
  char_length(trim(full_name)) between 3 and 30
);

-- =================================================================
-- PROJECTS TABLE CONSTRAINTS
-- =================================================================
alter table public.projects
alter column name set not null;

alter table public.projects
add constraint projects_name_length_check
check (char_length(trim(name)) between 3 and 30);

alter table public.projects
add constraint projects_color_id_check
check (color_id between 0 and 20);