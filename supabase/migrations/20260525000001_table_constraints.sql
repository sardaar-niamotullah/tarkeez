-- =================================================================
-- USERS TABLE CONSTRAINTS
-- =================================================================
alter table public.users
add constraint full_name_length
check (
  char_length(trim(full_name)) between 3 and 30
);

alter table public.users
add constraint bio_length
check (
    bio is null
    or char_length(trim(bio)) between 3 and 150
);

alter table public.users
add constraint profession
check (
    profession is null
    or char_length(trim(profession)) between 3 and 100
);

alter table public.users
add constraint education
check (
    education is null
    or char_length(trim(education)) between 3 and 100
);

-- =================================================================
-- PROJECTS TABLE CONSTRAINTS
-- =================================================================
alter table public.projects
alter column name set not null;

alter table public.projects
add constraint projects_name_length_check
check (char_length(trim(name)) between 3 and 30);