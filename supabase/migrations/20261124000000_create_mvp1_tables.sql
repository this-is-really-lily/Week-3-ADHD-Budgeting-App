-- Migration: create the MVP 1 tables.
-- See docs/database-design.md for what each table and column means.
--
-- Safety rules used in every table:
--   * user_id points to the signed-in person (Supabase's auth.users list).
--     If that person is deleted, all their rows are deleted too.
--   * Row Level Security (RLS) is turned on, with four rules per table so each
--     person can only see, add, change, and delete their own rows.
--   * There are no rules for the "anon" (signed-out) role, so signed-out
--     visitors can't read or change anything.
--   * Every table that can hold sample data has is_sample. "Clear sample
--     data" deletes only rows where is_sample is true.
--   * (select auth.uid()) is Supabase's recommended way to get the signed-in
--     person's id. The extra "select" makes it run once per query, not once
--     per row.
--
-- Money is saved in US cents as whole numbers (bigint): $12.50 is 1250.
-- Columns that hold money end in _cents. US dollars only.

-- ---------------------------------------------------------------------------
-- 1. money_setup: one row per person, used by the safe-to-spend math.
-- ---------------------------------------------------------------------------
create table public.money_setup (
  id                       uuid primary key default gen_random_uuid(),
  user_id                  uuid not null unique references auth.users (id) on delete cascade,
  balance_today_cents      bigint,
  balance_as_of            date,
  next_payday              date,
  pay_frequency            text check (pay_frequency in ('weekly', 'every_2_weeks', 'monthly')),
  savings_per_period_cents bigint not null default 0 check (savings_per_period_cents >= 0),
  is_sample                boolean not null default false
);

alter table public.money_setup enable row level security;

create policy "People can see their own money setup"
  on public.money_setup for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own money setup"
  on public.money_setup for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own money setup"
  on public.money_setup for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own money setup"
  on public.money_setup for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 2. settings: one row per person: "Due soon" choices, time zone,
--    safe-to-spend view, and dates for welcome back and the privacy screen.
-- ---------------------------------------------------------------------------
create table public.settings (
  id                       uuid primary key default gen_random_uuid(),
  user_id                  uuid not null unique references auth.users (id) on delete cascade,
  -- Saved from the browser at sign-up, like 'America/Chicago'.
  time_zone                text not null check (char_length(time_zone) between 1 and 64),
  safe_to_spend_view       text not null default 'per_day'
                             check (safe_to_spend_view in ('per_day', 'until_payday')),
  -- Empty until the person has seen the privacy screen once.
  privacy_seen_at          timestamptz,
  show_bills               boolean not null default true,
  show_trials_and_renewals boolean not null default true,
  show_wishlist            boolean not null default true,
  due_soon_frequency       text not null default 'every_open'
                             check (due_soon_frequency in ('every_open', 'once_a_day')),
  quiet_hours_start        time,
  quiet_hours_end          time,
  last_opened_on           date,
  -- Quiet hours need both a start and an end, or neither.
  check ((quiet_hours_start is null) = (quiet_hours_end is null))
);

alter table public.settings enable row level security;

create policy "People can see their own settings"
  on public.settings for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own settings"
  on public.settings for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own settings"
  on public.settings for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own settings"
  on public.settings for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 3. transactions: money in or out, typed by hand (ADR-0002).
-- ---------------------------------------------------------------------------
create table public.transactions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  happened_on date not null,
  amount_cents bigint not null check (amount_cents > 0),
  description text not null check (char_length(description) between 1 and 200),
  category    text not null check (char_length(category) between 1 and 50),
  direction   text not null check (direction in ('in', 'out')),
  is_sample   boolean not null default false
);

create index transactions_user_id_idx on public.transactions (user_id);

alter table public.transactions enable row level security;

create policy "People can see their own transactions"
  on public.transactions for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own transactions"
  on public.transactions for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own transactions"
  on public.transactions for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own transactions"
  on public.transactions for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 4. category_rules: a person's category fixes, so the app remembers them.
-- ---------------------------------------------------------------------------
create table public.category_rules (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  match_text text not null check (char_length(match_text) between 1 and 200),
  category   text not null check (char_length(category) between 1 and 50),
  unique (user_id, match_text)
);

alter table public.category_rules enable row level security;

create policy "People can see their own category rules"
  on public.category_rules for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own category rules"
  on public.category_rules for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own category rules"
  on public.category_rules for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own category rules"
  on public.category_rules for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 5. bills: found by the app or added by hand.
-- ---------------------------------------------------------------------------
create table public.bills (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users (id) on delete cascade,
  name          text not null check (char_length(name) between 1 and 100),
  amount_cents  bigint not null check (amount_cents > 0),
  due_on        date not null,
  repeats       text not null check (repeats in ('weekly', 'every_2_weeks', 'monthly', 'yearly')),
  is_confirmed  boolean not null default false,
  -- Added by hand = can be deleted. Found by the app = dismissed instead.
  is_added_by_hand boolean not null default false,
  is_paid       boolean not null default false,
  snoozed_until date,
  is_dismissed  boolean not null default false,
  is_sample     boolean not null default false
);

create index bills_user_id_idx on public.bills (user_id);

alter table public.bills enable row level security;

create policy "People can see their own bills"
  on public.bills for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own bills"
  on public.bills for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own bills"
  on public.bills for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own bills"
  on public.bills for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 6. subscriptions: found by the app or added by hand.
-- ---------------------------------------------------------------------------
create table public.subscriptions (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users (id) on delete cascade,
  name           text not null check (char_length(name) between 1 and 100),
  amount_cents   bigint not null check (amount_cents > 0),
  charges_every  text not null check (charges_every in ('weekly', 'every_2_weeks', 'monthly', 'yearly')),
  next_charge_on date not null,
  trial_ends_on  date,
  cancel_note    text check (char_length(cancel_note) <= 1000),
  -- Added by hand = can be deleted. Found by the app = dismissed instead.
  is_added_by_hand boolean not null default false,
  is_dismissed   boolean not null default false,
  is_sample      boolean not null default false
);

create index subscriptions_user_id_idx on public.subscriptions (user_id);

alter table public.subscriptions enable row level security;

create policy "People can see their own subscriptions"
  on public.subscriptions for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own subscriptions"
  on public.subscriptions for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own subscriptions"
  on public.subscriptions for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own subscriptions"
  on public.subscriptions for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- 7. wishlist_items: wants parked with a waiting period.
-- ---------------------------------------------------------------------------
create table public.wishlist_items (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  name         text not null check (char_length(name) between 1 and 100),
  price_cents  bigint not null check (price_cents > 0),
  waiting_days integer not null default 1 check (waiting_days in (1, 3, 7)),
  added_on     date not null, -- set by the server in the person's time zone
  is_decided   boolean not null default false,
  is_sample    boolean not null default false
);

create index wishlist_items_user_id_idx on public.wishlist_items (user_id);

alter table public.wishlist_items enable row level security;

create policy "People can see their own wishlist items"
  on public.wishlist_items for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "People can add their own wishlist items"
  on public.wishlist_items for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "People can change their own wishlist items"
  on public.wishlist_items for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "People can delete their own wishlist items"
  on public.wishlist_items for delete to authenticated
  using ((select auth.uid()) = user_id);
