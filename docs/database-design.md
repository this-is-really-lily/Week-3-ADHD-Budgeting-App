# Database Design – MVP 1

Built from docs/specs, docs/architecture.md (Tier 3), and ADR-0002 (manual entry
with fake data), ADR-0004 (Supabase, Row Level Security on every table), and
ADR-0005 (in-app reminders). All data is fake (CLAUDE.md rule 6).

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
  repeats, and whether it's confirmed, paid, snoozed, or dismissed.
- The app needs to remember each subscription: its name, amount, how often it
  charges, the next charge date, an optional trial end date, and an optional
  "How to cancel" note.
- The app needs to remember each wishlist item: its name, price, waiting period,
  the date it was added, and whether the person has decided.
- The app needs to remember each person's settings: which reminder types show in
  "Due soon," how often, quiet hours, and the date they last opened the app.
- The app needs to remember which items are sample data, so one button can
  remove all of them.

## Tables

Types of data used below:
- **text:** words
- **number:** amounts with 2 decimal places, like 12.50
- **whole number:** like 1, 3, or 7
- **date:** a calendar day
- **time:** a time of day, like 22:00
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
| balance_today | number | No | "How much is in your account today?" Empty means "not sure yet." Can be below zero. |
| balance_as_of | date | No | The day the person typed that balance. |
| next_payday | date | No | The person's next payday. Empty means "not sure yet." |
| pay_frequency | text | No | How often payday comes: weekly, every 2 weeks, or monthly. |
| savings_per_period | number | Yes | Savings set aside each pay period. Starts at 0. Can't be below 0. |
| is_sample | true or false | Yes | True if this is sample data. Starts false. |

**Who can see it?** Only the person who owns the row, while signed in.
**Who can add, change, or delete it?** Only the person who owns the row.

---

### Table name: `settings`
**What it stores:** one row per person with their "Due soon" choices and the date
they last opened the app (5.1, 5.2, ADR-0005).

| Column name | Type of data | Required? | What it means |
|---|---|---|---|
| id | code | Yes | A unique code for each row. |
| user_id | code | Yes | The person who owns this row. Each person has only one. |
| show_bills | true or false | Yes | Show bills in "Due soon." Starts true. |
| show_trials_and_renewals | true or false | Yes | Show trials and renewals in "Due soon." Starts true. |
| show_wishlist | true or false | Yes | Show finished wishlist waits in "Due soon." Starts true. |
| due_soon_frequency | text | Yes | "every_open" or "once_a_day." Starts as "every_open." |
| quiet_hours_start | time | No | When quiet hours start. Empty means no quiet hours. |
| quiet_hours_end | time | No | When quiet hours end. Must be set together with the start. |
| last_opened_on | date | No | The last day the person opened the app. Used for welcome back (7-day gap) and "once a day." |

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
| amount | number | Yes | How much. Always above 0 (direction says in or out). |
| description | text | Yes | What it was for, like "Pizza Palace." 1–200 characters. |
| category | text | Yes | Its category, like "Eating out." 1–50 characters. |
| direction | text | Yes | "in" for money coming in, "out" for money going out. |
| is_sample | true or false | Yes | True if this is sample data. Starts false. |

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
| amount | number | Yes | How much it costs. Above 0. |
| due_on | date | Yes | The next due date. |
| repeats | text | Yes | How often: weekly, every 2 weeks, monthly, or yearly. |
| is_confirmed | true or false | Yes | True once the person confirms a found bill. Bills added by hand start true. |
| is_paid | true or false | Yes | True when "paid" is tapped for this due date. |
| snoozed_until | date | No | "Remind me later" hides the bill from "Due soon" until this day. |
| is_dismissed | true or false | Yes | True if the person said "this isn't a bill," so the app doesn't find it again. |
| is_sample | true or false | Yes | True if this is sample data. Starts false. |

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
| amount | number | Yes | How much each charge costs. Above 0. |
| charges_every | text | Yes | How often: weekly, every 2 weeks, monthly, or yearly. |
| next_charge_on | date | Yes | The next charge date. For yearly ones, this is the renewal date. |
| trial_ends_on | date | No | When a free trial ends, if the person typed it. |
| cancel_note | text | No | The person's "How to cancel" note. Up to 1,000 characters. |
| is_dismissed | true or false | Yes | True if the person said "this isn't a subscription," so the app doesn't find it again. |
| is_sample | true or false | Yes | True if this is sample data. Starts false. |

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
| price | number | Yes | How much it costs. Above 0. |
| waiting_days | whole number | Yes | 1, 3, or 7 days. Starts at 1. |
| added_on | date | Yes | The day it was added. Starts as today. |
| is_decided | true or false | Yes | True once the person decides (bought it, or chose not to). |
| is_sample | true or false | Yes | True if this is sample data. Starts false. |

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

## Things I had to assume

These aren't spelled out in the docs. Each one is my simplest guess.

1. **No "people" table of our own.** Supabase Auth's built-in sign-in list holds
   each person's email and password. Our tables point to it.
2. **One money setup and one settings row per person.** The server creates them
   the first time they're needed. There's no automatic database trigger.
3. **Amounts are positive numbers with 2 decimal places,** and a separate
   "direction" column says in or out. Only `balance_today` can be below zero,
   because an account can be overdrawn.
4. **Text length limits:** 200 for descriptions, 100 for names, 50 for
   categories, and 1,000 for cancel notes. These block junk input (T5), but the
   numbers are my picks.
5. **"How often" choices** for bills and subscriptions are weekly, every 2 weeks,
   monthly, and yearly. The docs mention yearly bills and monthly totals but give
   no full list. There's no "one-time" bill.
6. **The yearly renewal date is just `next_charge_on`** for a yearly
   subscription, with no separate column.
7. **Wrongly found bills and subscriptions are marked "dismissed," not
   deleted.** Everything is worked out again each time the app opens, so a
   deleted one would just be found again. Items the person added by hand can
   still be fully deleted.
8. **Starting category rules for everyone live in the code** (a settings file
   with tests, T12). This table only saves each person's own fixes.
9. **Found bills and subscriptions aren't linked** to the transactions they were
   found from.
10. **Clearing sample data** deletes every row marked as sample and empties the
    money setup, which sends the person to the "Set up your money" screens.
11. **"Paid" applies to the current due date.** When it passes, the server moves
    `due_on` forward and sets `is_paid` back to false.
12. **Time zone isn't in the docs.** "Today" and quiet hours depend on it. For
    now we assume the server uses the time zone from the person's browser. If
    that's not enough, we'll add a time zone column to `settings` later.
13. **Every table gets a speed-up index on `user_id`,** so finding one person's
    rows stays fast.
