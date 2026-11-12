-- =================================================================
-- Bucket: users-media
-- =================================================================
create policy "allow_insert_own_files"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'users-media'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

create policy "allow_select_own_files"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'users-media'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

create policy "allow_delete_own_files"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'users-media'
  AND (storage.foldername(name))[1] = auth.uid()::text
);