# Database Design – MVP 1

Built from docs/specs, docs/architecture.md (Tier 3), and ADR-0002 (manual entry
with fake data), ADR-0004 (Supabase, Row Level Security on every table),
ADR-0005 (in-app reminders), and ADR-0006 (no email confirmation). All data is
fake (CLAUDE.md rule 6).

## What does the app need to save?

- The app needs to remember each person's sign-in details (email and password),
  which Supabase Auth keeps for us.
- The app needs to remember how much money a person says is in their account
  today, the date they said it, their next payday and how often it comes, and
  how much they set aside for savings each pay period.
- The app needs to remember every transaction a person types in: when it
  happened, how much, what it was for, its category, and whether money came in
  or went out.
- The app needs to remember the category fixes a person makes, so the same name
  gets the same category next time.
- The app needs to remember each bill: its name, amount, due date, how often it
  repeats, whether the person added it by hand, and whether it's confirmed,
  paid, snoozed, or dismissed.
- The app needs to remember each subscription: its name, amount, how often it
  charges, the next charge date, an optional trial end date, an optional "How to
  cancel" note, whether the person added it by hand, and whether it was
  dismissed.
- The app needs to remember each wishlist item: its name, price, waiting period,
  the date it was added, and whether the person has decided.
- The app needs to remember each person's settings: which reminder types show in
  "Due soon," how often, quiet hours, the date they last opened the app, their
  time zone, whether they see safe-to-spend "per day" or "until payday," and
  when they saw the privacy screen.
- The app needs to remember which rows are sample data, so one button can
  remove those rows and nothing else.

## Tables

**Money is saved in US cents, as whole numbers.** For example, $12.50 is saved
as 1250. US dollars only. Money columns end in `_cents` so this is easy to see.
*(Decided Nov 24, 2026)*

Types of data used below:
- **text:** words
- **whole number:** like 1, 3, 7, or 1250 (for $12.50)
- **date:** a calendar day
- **time:** a time of day, like 22:00
- **date and time:** a moment, like Nov 24, 2026 at 9:15 pm
- **true or false**
- **code:** a long random ID that Supabase makes, called a "UUID"

Every table has the same two safety columns: `id` and `user_id`. `user_id` points
to the person in Supabase's sign-in list. If that person deletes their account,
all their rows are deleted too, right away (Decided Nov 18, 2026).

---

### Table name: `money_setup`
**What it stores:** one row per person with the numbers the safe-to-spend math
needs (spec 1.2, T7).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. Each person has only one. |
| balance_today_cents | whole number | No | "How much is in your account today?" in cents. Empty means "not sure yet." Can be below zero. |
| balance_as_of | date | No | The day the person typed that balance. |
| next_payday | date | No | The person's next payday. Empty means "not sure yet." |
| pay_frequency | text | No | How often payday comes: weekly, every 2 weeks, or monthly. |
| savings_per_period_cents | whole number | Yes | Savings set aside each pay period, in cents. Starts at 0. Can't be below 0. |
| is_sample | true or false | Yes | True if this row is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `settings`
**What it stores:** one row per person with their "Due soon" choices, time zone,
safe-to-spend view, and the dates the app needs for welcome back and the
privacy screen (5.1, 5.2, 6.2, ADR-0005).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. Each person has only one. |
| time_zone | text | Yes | The person's time zone from their browser at sign-up, like "America/Chicago." Used for "today," due dates, and payday. *(Decided Nov 24, 2026)* |
| safe_to_spend_view | text | Yes | "per_day" or "until_payday." Starts as "per_day." *(Decided Nov 24, 2026)* |
| privacy_seen_at | date and time | No | When the person saw the privacy screen. Empty means not seen yet. *(Decided Nov 24, 2026)* |
| show_bills | true or false | Yes | Show bills in "Due soon." Starts true. |
| show_trials_and_renewals | true or false | Yes | Show trials and renewals in "Due soon." Starts true. |
| show_wishlist | true or false | Yes | Show finished wishlist waits in "Due soon." Starts true. |
| due_soon_frequency | text | Yes | "every_open" or "once_a_day." Starts as "every_open." |
| quiet_hours_start | time | No | When quiet hours start. Empty means no quiet hours. |
| quiet_hours_end | time | No | When quiet hours end. Must be set together with the start. |
| last_opened_on | date | No | The last day the person opened the app. Used for welcome back (7 days or more) and "once a day." |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `transactions`
**What it stores:** every money-in or money-out entry the person types by hand
(1.1, ADR-0002).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. |
| happened_on | date | Yes | The day the money came in or went out. |
| amount_cents | whole number | Yes | How much, in cents. Always above 0 (direction says in or out). |
| description | text | Yes | What it was for, like "Pizza Palace." 1–200 characters. |
| category | text | Yes | Its category, like "Eating out." 1–50 characters. |
| direction | text | Yes | "in" for money coming in, "out" for money going out. |
| is_sample | true or false | Yes | True if this row is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `category_rules`
**What it stores:** the person's category fixes, so the app remembers them
(1.1, T12).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. |
| match_text | text | Yes | The name to watch for, like "Pizza Palace." Only one rule per name per person. |
| category | text | Yes | The category to use for that name. |

Sample data never creates category rules, so this table has no sample marker.

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `bills`
**What it stores:** bills the app found or the person added by hand
(2.1, 2.2, ADR-0005).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. |
| name | text | Yes | The bill's name, like "Rent." 1–100 characters. |
| amount_cents | whole number | Yes | How much it costs, in cents. Above 0. |
| due_on | date | Yes | The next due date. |
| repeats | text | Yes | How often: weekly, every 2 weeks, monthly, or yearly. |
| is_confirmed | true or false | Yes | True once the person confirms a found bill. Bills added by hand start true. |
| is_added_by_hand | true or false | Yes | True if the person typed this bill in; false if the app found it. Bills added by hand can be deleted; found ones are dismissed. Starts false. *(Decided Nov 24, 2026)* |
| is_paid | true or false | Yes | True when "paid" is tapped for this due date. |
| snoozed_until | date | No | "Remind me later" hides the bill from "Due soon" until this day. |
| is_dismissed | true or false | Yes | True if the person said "this isn't a bill," so the app doesn't find it again. *(Decided Nov 24, 2026)* |
| is_sample | true or false | Yes | True if this row is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `subscriptions`
**What it stores:** subscriptions the app found or the person added
(4.1, 4.2).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. |
| name | text | Yes | The subscription's name. 1–100 characters. |
| amount_cents | whole number | Yes | How much each charge costs, in cents. Above 0. |
| charges_every | text | Yes | How often: weekly, every 2 weeks, monthly, or yearly. |
| next_charge_on | date | Yes | The next charge date. For yearly ones, this is the renewal date. |
| trial_ends_on | date | No | When a free trial ends, if the person typed it. |
| cancel_note | text | No | The person's "How to cancel" note. Up to 1,000 characters. |
| is_added_by_hand | true or false | Yes | True if the person typed this subscription in; false if the app found it. Ones added by hand can be deleted; found ones are dismissed. Starts false. *(Decided Nov 24, 2026)* |
| is_dismissed | true or false | Yes | True if the person said "this isn't a subscription," so the app doesn't find it again. *(Decided Nov 24, 2026)* |
| is_sample | true or false | Yes | True if this row is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `wishlist_items`
**What it stores:** things the person wants but agreed to wait for (3.2).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. |
| name | text | Yes | What they want. 1–100 characters. |
| price_cents | whole number | Yes | How much it costs, in cents. Above 0. |
| waiting_days | whole number | Yes | 1, 3, or 7 days. Starts at 1. |
| added_on | date | Yes | The day it was added. The server sets it using the person's time zone. |
| is_decided | true or false | Yes | True once the person decides (bought it, or chose not to). |
| is_sample | true or false | Yes | True if this row is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

## How the tables connect

- One person has at most one money setup. Each money setup belongs to one person.
- One person has at most one settings row. Each settings row belongs to one
  person.
- One person can have many transactions. Each transaction belongs to one person.
- One person can have many category rules. Each category rule belongs to one
  person.
- One person can have many bills. Each bill belongs to one person.
- One person can have many subscriptions. Each subscription belongs to one person.
- One person can have many wishlist items. Each wishlist item belongs to one
  person.

The tables don't point to each other. Bills and subscriptions are worked out from
transactions each time the app opens (docs/architecture.md), but they aren't
linked to specific transactions.

## Access rules (Row Level Security)

- [x] RLS is turned on for every table. (In the migration file.)
- [x] Each table has a rule that lets people see only their own rows. (Each table
      has four rules: see, add, change, and delete, all limited to the signed-in
      person's own rows.)
- [ ] I tested this with two accounts. One person could not see the other
      person's information. **Not done yet.** This needs a real Supabase project.
      It's the next step after the migration is run.

## Database diagram
Saved in docs/database-diagram.md (Mermaid).

## Migration files
Every change to the database is saved as a SQL migration file in
`supabase/migrations/`. The first one is
`supabase/migrations/20261124000000_create_mvp1_tables.sql`.

## Decided on Nov 24, 2026

These used to be assumptions, or are new, and are now decided:
- Money is saved in US cents as whole numbers, US dollars only.
- Each person's time zone is saved from their browser at sign-up and used for
  "today," due dates, and payday.
- Each person's safe-to-spend view ("per day," the default, or "until payday")
  is saved in their settings.
- The app saves when the privacy screen was seen, so it only shows once.
- Every sample-data row has an "is sample" marker, and "Clear sample data"
  deletes only those rows.
- A wrongly found bill or subscription is marked "dismissed" instead of deleted,
  so it isn't found again.
- **Found bills and subscriptions are dismissed; ones you added by hand can be
  deleted.** The `is_added_by_hand` column tells the app which is which.
- Passwords are at least 8 characters, and we keep Supabase's built-in attempt
  limits and default session settings. These are set in the Supabase dashboard,
  not in our tables (see the Step 8 setup list in docs/architecture.md).

## Things I had to assume

These still aren't spelled out in the docs. Each one is my simplest guess.

1. **No "people" table of our own.** Supabase Auth's built-in sign-in list holds
   each person's email and password. Our tables point to it.
2. **When rows are created:** the server creates each person's settings row at
   sign-up (that's when the time zone is saved), along with the sample data,
   including a sample money setup. There's no automatic database trigger.
3. **Amounts are positive,** and a separate "direction" column says in or out.
   Only `balance_today_cents` can be below zero, because an account can be
   overdrawn.
4. **Text length limits:** 200 for descriptions, 100 for names, 50 for
   categories, 64 for time zone names, and 1,000 for cancel notes. These block
   junk input (T5), but the numbers are my picks.
5. **"How often" choices** for bills and subscriptions are weekly, every 2 weeks,
   monthly, and yearly. The docs mention yearly bills and monthly totals but give
   no full list. There's no "one-time" bill.
6. **The yearly renewal date is just `next_charge_on`** for a yearly
   subscription, with no separate column.
7. **Starting category rules for everyone live in the code** (a settings file
   with tests, T12). This table only saves each person's own fixes, and sample
   data never creates any.
8. **Found bills and subscriptions aren't linked** to the transactions they were
   found from.
9. **Clearing sample data** deletes the sample money setup too, because it's
   marked as sample. With no money setup left, the person goes to the "Set up
   your money" screens.
10. **"Paid" applies to the current due date.** When it passes, the server moves
    `due_on` forward and sets `is_paid` back to false.
11. **The time zone is checked by the server** before it's saved. The database
    only checks its length.
12. **Whole numbers use a large number type** ("bigint"), so even very large
    amounts in cents fit.
13. **Tables that can have many rows per person get a speed-up index on
    `user_id`,** so finding one person's rows stays fast. The one-row-per-person
    tables already get one from their "only one per person" rule.
