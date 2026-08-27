-- Signups for The Great Sauna Race.
create table if not exists public.signups (
  id            bigint generated always as identity primary key,
  created_at    timestamptz not null default now(),
  name          text not null,
  email         text not null,
  phone         text not null,
  ready         boolean not null default false
);

alter table public.signups enable row level security;

-- The page posts with the publishable (anon) key, so anon may INSERT.
-- No select/update/delete policy exists, so nobody can read the list back
-- with that key: signups go in, they don't come out.
drop policy if exists "anyone can sign up" on public.signups;
create policy "anyone can sign up"
  on public.signups
  for insert
  to anon
  with check (
    length(trim(name))  between 1 and 100
    and email ~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'
    and length(email)   <= 200
    and length(phone)   between 5 and 40
  );
