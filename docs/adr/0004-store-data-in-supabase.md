# ADR-0004: Store data and handle sign-in with Supabase

## Date and status
November 18, 2026. Accepted

## Context
The app needs a safe place to save each person's money setup, transactions,
bills, subscriptions, wishlist, and settings, and a way for people to sign in.
Our specs say:
- **T2 Database & backend:** save data in Supabase Postgres (a kind of database),
  use Row-Level Security so each person reads and writes only their own items,
  and keep the powerful "service-role" key on the server only.
- **T3 Accounts & auth:** use Supabase Auth, with sessions that expire and
  refresh securely.
- **6.1 and 6.2:** sign up, sign in, reset a password, and export or delete all
  data.
- **Rule 5 in CLAUDE.md:** every database call happens in server code, never in
  the browser.

On Nov 18, 2026 we decided: email and password only (no magic link), rely on
Supabase's built-in encryption, and delete data right away when asked (see
docs/architecture.md).

## Options
- Option 1: Supabase (Postgres database + Supabase Auth)
  - Good:
    - It's what our specs already plan for (T2, T3).
    - Sign-in is handled for us, including safe password storage, sessions, and
      password-reset emails. We never write our own password code.
    - Row-Level Security lets the database itself refuse to show one person's
      items to someone else, as a second safety lock after the server.
    - It encrypts stored data on its disks (T6).
    - It has a free plan, which meets T10.
  - Bad:
    - Row-Level Security must be turned on for every table by hand. If we forget
      one, that table could be read by others.
    - On the free plan, a project pauses after about a week without use, and has
      to be woken up.
    - Its built-in email for password resets has a low sending limit. That's fine
      for class testing, but not for many users.
    - Another outside service and more secret keys to protect.
- Option 2: Save data only in the person's browser (no database)
  - Good:
    - Very simple, with no outside service and no secret keys.
  - Bad:
    - There are no accounts or sign-in, so 6.1 can't be met.
    - Data lives on one device and is lost if the browser is cleared.
    - Doesn't meet T2 or T3.

## Decision
We will use **Supabase**: a Supabase Postgres database for our data, and
**Supabase Auth with email and password** for sign-in.

- **Row-Level Security is on for every table**, so each person can only read and
  change their own items.
- **Every database call happens in server code** on Vercel, never in the
  browser (rule 5).

We chose this because our specs already call for it (T2, T3), it handles
sign-in safely so we don't write our own password code, and it's free for MVP 1.

## Consequences
**What gets easier**
- Sign-up, sign-in, sign-out, and password reset come ready-made.
- Two safety locks on every request: the server checks who's asking, and the
  database checks again with Row-Level Security.
- Encrypted storage without extra work.

**What gets harder**
- We must remember to turn on Row-Level Security and write its rules for every
  new table, and test that one person can't see another's items.
- Deleting a person's sign-in account needs the service-role key, so that one
  action has to be extra careful on the server.
- The free project may pause if nobody uses it for a while.

**Rules we follow because of this**
- Supabase keys go in `.env.local` and Vercel's settings only, never in code or
  on GitHub (rule 4).
- The service-role key is used only on the server, only for actions that truly
  need it, like deleting an account.
- Browser code never calls Supabase directly (rule 5).
- All data is fake (rule 6).

**What we need to do next**
1. Create a free Supabase project, and add its keys to `.env.local` and Vercel.
2. Turn on email-and-password sign-in.
3. Create the tables from docs/architecture.md (Tier 3), with Row-Level Security
   on each one.
4. Write a test that checks one person can't read another person's items.
5. Change this ADR's status to "Accepted" once it's approved.
