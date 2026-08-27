-- Liability acknowledgement, ticked on the signup form.
alter table public.signups
  add column if not exists waiver boolean not null default false;
