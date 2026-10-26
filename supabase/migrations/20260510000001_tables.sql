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
alter table public.users
add constraint full_name_length
check (
  char_length(trim(full_name)) between 3 and 30
);

-- RLS
alter table public.users enable row level security;

create policy "allow_select_own_data"
on public.users
for select
to authenticated
using (id = auth.uid());

create policy "allow_update_own_data"
on public.users
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

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

-- Index
create index if not exists idx_projects_pull
  on public.projects (user_id, updated_at);

-- CONSTRAINTS 
alter table public.projects
alter column name set not null;

alter table public.projects
add constraint projects_name_length_check
check (char_length(trim(name)) between 3 and 30);

alter table public.projects
add constraint projects_color_id_check
check (color_id between 0 and 20);

-- RLS
alter table public.projects enable row level security;

create policy "allow_select_own_projects"
on public.projects
for select
to authenticated
using (user_id = auth.uid());

create policy "allow_insert_own_projects"
on public.projects
for insert
to authenticated
with check (user_id = auth.uid());

create policy "allow_update_own_projects"
on public.projects
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "allow_delete_own_projects"
on public.projects
for delete
to authenticated
using (user_id = auth.uid());