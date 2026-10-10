-- Run once in Supabase: Dashboard → SQL Editor → New query → paste → Run
create table if not exists public.records (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null,
  kind       text not null check (kind in ('bill','expense','settings')),
  data       jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.records enable row level security;

-- Each signed-in user can only see and change their own rows
create policy "own rows - select" on public.records for select using (auth.uid() = user_id);
create policy "own rows - insert" on public.records for insert with check (auth.uid() = user_id);
create policy "own rows - update" on public.records for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows - delete" on public.records for delete using (auth.uid() = user_id);
