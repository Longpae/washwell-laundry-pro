create extension if not exists pgcrypto;

create table if not exists public.washwell_stops (
  id text primary key,
  workspace_id text not null default 'washwell',
  work_date text not null,
  zone text,
  line_label text,
  line_idx int,
  unit text,
  name text,
  phone text,
  address text,
  is_delivery boolean default false,
  is_pickup boolean default false,
  delivery_done boolean default false,
  pickup_done boolean default false,
  delivery_done_at timestamptz,
  pickup_done_at timestamptz,
  on_hold boolean default false,
  hold_at timestamptz,
  updated_at timestamptz default now(),
  updated_by text
);

create table if not exists public.washwell_line_sessions (
  id text primary key,
  workspace_id text not null default 'washwell',
  work_date text not null,
  zone text,
  line_label text,
  started_at timestamptz,
  ended_at timestamptz,
  duration_ms bigint,
  first_action_key text,
  last_action_key text,
  worker_name text,
  completed_stop_count int default 0,
  total_stop_count int default 0,
  delivery_count int default 0,
  pickup_count int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists washwell_stops_work_idx
  on public.washwell_stops (workspace_id, work_date, zone, line_idx);

create index if not exists washwell_line_sessions_work_idx
  on public.washwell_line_sessions (workspace_id, work_date, zone, line_label);

alter table public.washwell_stops enable row level security;
alter table public.washwell_line_sessions enable row level security;

drop policy if exists "anon can read washwell stops" on public.washwell_stops;
drop policy if exists "anon can upsert washwell stops" on public.washwell_stops;
drop policy if exists "anon can update washwell stops" on public.washwell_stops;
drop policy if exists "anon can read washwell line sessions" on public.washwell_line_sessions;
drop policy if exists "anon can upsert washwell line sessions" on public.washwell_line_sessions;
drop policy if exists "anon can update washwell line sessions" on public.washwell_line_sessions;

create policy "anon can read washwell stops"
  on public.washwell_stops for select
  to anon using (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

create policy "anon can upsert washwell stops"
  on public.washwell_stops for insert
  to anon with check (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

create policy "anon can update washwell stops"
  on public.washwell_stops for update
  to anon using (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  ) with check (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

create policy "anon can read washwell line sessions"
  on public.washwell_line_sessions for select
  to anon using (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

create policy "anon can upsert washwell line sessions"
  on public.washwell_line_sessions for insert
  to anon with check (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

create policy "anon can update washwell line sessions"
  on public.washwell_line_sessions for update
  to anon using (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  ) with check (
    workspace_id = coalesce(nullif(nullif(current_setting('request.headers', true), '')::jsonb ->> 'x-workspace-id', ''), 'washwell')
  );

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'washwell_stops'
  ) then
    alter publication supabase_realtime add table public.washwell_stops;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'washwell_line_sessions'
  ) then
    alter publication supabase_realtime add table public.washwell_line_sessions;
  end if;
end $$;
