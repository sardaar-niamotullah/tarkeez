-- =================================================================
-- USERS TABLE
-- =================================================================
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
-- PROJECTS TABLE
-- =================================================================
alter table public.projects enable row level security;

-- SELECT
create policy "allow_select_own_projects"
on public.projects
for select
to authenticated
using (user_id = auth.uid());

-- INSERT
create policy "allow_insert_own_projects"
on public.projects
for insert
to authenticated
with check (user_id = auth.uid());

-- UPDATE
create policy "allow_update_own_projects"
on public.projects
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

-- DELETE
create policy "allow_delete_own_projects"
on public.projects
for delete
to authenticated
using (user_id = auth.uid());
