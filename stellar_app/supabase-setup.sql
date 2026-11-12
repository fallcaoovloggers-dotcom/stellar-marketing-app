-- Execute uma única vez no SQL Editor do projeto Supabase.
-- Compartilhamento entre os dois usuários cadastrados: ambos têm acesso aos mesmos registros.
-- Os membros são fixados no momento da execução; novos usuários NÃO entram automaticamente.
create table if not exists public.app_members (user_id uuid primary key references auth.users(id) on delete cascade);
revoke all on public.app_members from anon;
grant select on public.app_members to authenticated;
alter table public.app_members enable row level security;
drop policy if exists "members_read_self" on public.app_members;
create policy "members_read_self" on public.app_members for select to authenticated using (user_id = (select auth.uid()));
-- Confira antes de executar: inclui todos os usuários que existem NESTE MOMENTO no projeto.
insert into public.app_members(user_id) select id from auth.users on conflict do nothing;

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.clients enable row level security;
revoke all on public.clients from anon;
grant select,insert,update,delete on public.clients to authenticated;
drop policy if exists "stellar_members_access" on public.clients;
create policy "stellar_members_access" on public.clients for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.expenses enable row level security;
revoke all on public.expenses from anon;
grant select,insert,update,delete on public.expenses to authenticated;
drop policy if exists "stellar_members_access" on public.expenses;
create policy "stellar_members_access" on public.expenses for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.cash (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.cash enable row level security;
revoke all on public.cash from anon;
grant select,insert,update,delete on public.cash to authenticated;
drop policy if exists "stellar_members_access" on public.cash;
create policy "stellar_members_access" on public.cash for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.leads enable row level security;
revoke all on public.leads from anon;
grant select,insert,update,delete on public.leads to authenticated;
drop policy if exists "stellar_members_access" on public.leads;
create policy "stellar_members_access" on public.leads for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.acts (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.acts enable row level security;
revoke all on public.acts from anon;
grant select,insert,update,delete on public.acts to authenticated;
drop policy if exists "stellar_members_access" on public.acts;
create policy "stellar_members_access" on public.acts for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.goals enable row level security;
revoke all on public.goals from anon;
grant select,insert,update,delete on public.goals to authenticated;
drop policy if exists "stellar_members_access" on public.goals;
create policy "stellar_members_access" on public.goals for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.tasks enable row level security;
revoke all on public.tasks from anon;
grant select,insert,update,delete on public.tasks to authenticated;
drop policy if exists "stellar_members_access" on public.tasks;
create policy "stellar_members_access" on public.tasks for all to authenticated
  using (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())))
  with check (exists(select 1 from public.app_members m where m.user_id=(select auth.uid())));

-- OPCIONAL: habilite Realtime para atualizações imediatas (já há sincronização periódica no HTML).
-- alter publication supabase_realtime add table public.clients, public.expenses, public.cash, public.leads, public.acts, public.goals, public.tasks;
