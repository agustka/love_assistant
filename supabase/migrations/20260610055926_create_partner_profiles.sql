-- Partner profile authenticated remote sync.
-- One row per authenticated customer; profile_data holds a flexible JSON payload
-- of current and future partner profile values. Matches the supabase-adapter
-- contract in agents/specs/api.yaml (partner_profiles backing store).

create table if not exists public.partner_profiles (
    customer_id uuid primary key references auth.users (id) on delete cascade,
    profile_data jsonb not null default '{}'::jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Keep updated_at current on every write (the client upsert does not send it).
create or replace function public.set_current_timestamp_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

create trigger partner_profiles_set_updated_at
    before update on public.partner_profiles
    for each row
    execute function public.set_current_timestamp_updated_at();

-- Row Level Security: a customer may read and write only their own row.
alter table public.partner_profiles enable row level security;

create policy "Customers can view their own partner profile"
    on public.partner_profiles
    for select
    using (auth.uid() = customer_id);

create policy "Customers can insert their own partner profile"
    on public.partner_profiles
    for insert
    with check (auth.uid() = customer_id);

create policy "Customers can update their own partner profile"
    on public.partner_profiles
    for update
    using (auth.uid() = customer_id)
    with check (auth.uid() = customer_id);
