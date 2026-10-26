-- push_changes: upsert projects, one savepoint per row
create or replace function public.push_changes(p_projects jsonb default '[]'::jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid      uuid := auth.uid();
  v_reset_at timestamptz;
  v_item     jsonb;
  v_id       uuid;
  v_created  timestamptz;
  v_applied  uuid[] := '{}';
  v_rejected uuid[] := '{}';
begin
  if v_uid is null then
    raise exception 'not authenticated';
  end if;

  select u.history_reset_at into v_reset_at from public.users u where u.id = v_uid;

  for v_item in select value from jsonb_array_elements(p_projects) loop
    begin
      v_id      := (v_item ->> 'id')::uuid;
      v_created := (v_item ->> 'created_at')::timestamptz;

      -- created before the last "delete history": the device is stale
      if v_reset_at is not null and v_created < v_reset_at then
        v_rejected := v_rejected || v_id;
        continue;
      end if;

      insert into public.projects as p (id, user_id, name, color_id, created_at, deleted_at)
      values (
        v_id, v_uid, v_item ->> 'name', (v_item ->> 'color_id')::int,
        v_created, (v_item ->> 'deleted_at')::timestamptz
      )
      on conflict (id) do update
        set name       = excluded.name,
            color_id   = excluded.color_id,
            created_at = excluded.created_at,
            deleted_at = coalesce(p.deleted_at, excluded.deleted_at)  -- a tombstone is one-way
        where p.user_id = v_uid;

      if found then
        v_applied := v_applied || v_id;
      else
        v_rejected := v_rejected || v_id;
      end if;
    exception when others then
      null;  -- this row failed; it stays pending on the device
    end;
  end loop;

  return jsonb_build_object(
    'applied',  to_jsonb(v_applied),
    'rejected', to_jsonb(v_rejected)
  );
end;
$$;

-- pull_projects: rows stamped after p_after, in pages.
-- A page always ends on a complete updated_at value, because one push stamps
-- all its rows with the same time and cutting through that group would lose rows.
-- p_overlap re-reads the last 2 minutes (for the first page of a pull only).
create or replace function public.pull_projects(
  p_after     timestamptz default null,
  p_overlap   boolean     default false,
  p_page_size int         default 200
)
returns table (
  id uuid, name text, color_id int,
  created_at timestamptz, deleted_at timestamptz, updated_at timestamptz
)
language sql
stable
set search_path = public
as $$
  with bounds as (
    select case when p_after is null then null::timestamptz
                when p_overlap then p_after - interval '2 minutes'
                else p_after end as after_ts
  ),
  page as (
    select pr.updated_at
    from public.projects pr, bounds b
    where pr.user_id = auth.uid()
      and (b.after_ts is null or pr.updated_at > b.after_ts)
    order by pr.updated_at, pr.id
    limit greatest(p_page_size, 1)
  )
  select pr.id, pr.name, pr.color_id, pr.created_at, pr.deleted_at, pr.updated_at
  from public.projects pr, bounds b
  where pr.user_id = auth.uid()
    and (b.after_ts is null or pr.updated_at > b.after_ts)
    and pr.updated_at <= (select max(page.updated_at) from page)
  order by pr.updated_at, pr.id;
$$;

-- reset_history: for now it wipes projects only.
-- When sessions sync, delete the user's sessions here and keep projects.
create or replace function public.reset_history()
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_now timestamptz := now();
begin
  if v_uid is null then
    raise exception 'not authenticated';
  end if;

  delete from public.projects where user_id = v_uid;
  update public.users set history_reset_at = v_now where id = v_uid;

  return v_now;
end;
$$;

revoke all on function public.push_changes(jsonb) from public;
revoke all on function public.pull_projects(timestamptz, boolean, int) from public;
revoke all on function public.reset_history() from public;
grant execute on function public.push_changes(jsonb) to authenticated;
grant execute on function public.pull_projects(timestamptz, boolean, int) to authenticated;
grant execute on function public.reset_history() to authenticated;