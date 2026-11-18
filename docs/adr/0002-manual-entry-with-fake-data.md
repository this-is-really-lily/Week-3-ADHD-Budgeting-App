# ADR-0002: Enter money by hand and use fake sample data, with no bank connection

## Date and status
November 12, 2026. Accepted

## Context
Our specs were written for an app that connects to a person's real bank through a
service like Plaid (docs/specs/03-epics-features-tasks.md: the "Architecture" line
and task T4). For this class build, we have to decide where the app's money
information comes from.

Two things push this choice:
- My class allows fake data only (rule 6 in CLAUDE.md). Real bank accounts hold
  real people's personal information.
- This is our first build. A bank connection adds a lot of work before anyone sees
  a screen: an outside account, secret keys, storing bank tokens safely (T4), and
  handling broken connections.

Bills, subscriptions, the safe-to-spend number, reminders, and the pause check all
work from a list of transactions. So the main question is how transactions get
into the app.

## Options
- Option 1: Plaid Sandbox (Plaid's practice mode, with a pretend bank)
  - Good:
    - It keeps the "link your bank in a few taps" flow from our specs (E1.1).
    - Transactions arrive by themselves, with no typing. Our specs call manual
      tracking "the first habit ADHD users drop" (docs/specs/04-user-stories.md).
    - Its practice bank data is made up, so it also fits the fake-data rule.
    - Switching to real banks later would be a smaller change.
  - Bad:
    - We'd need a Plaid account and secret keys, kept only on the server.
    - We'd have to store bank tokens encrypted on the server and build a
      "reconnect" flow for broken connections (T4).
    - It adds an outside service that could be down, or could change while we're
      learning.
    - One wrong setting (real keys instead of practice keys) could pull in real
      bank data, which would break the class rule.
    - There's much more to build before the first screen works.
- Option 2: Enter money by hand, and start with fake sample data
  - Good:
    - Real bank data can never enter the app, so it fits the class rule by design.
    - There's no outside bank service, no bank secret keys, and no bank tokens to
      protect.
    - The first build is much simpler. We can focus on what makes this app
      special: the safe-to-spend number, finding repeat bills, the pause check,
      and calm wording.
    - Sample data lets people (and teachers) try every screen right away, before
      typing anything.
    - The same sample data can be our test data for checking the math (T7).
  - Bad:
    - People have to type in every transaction. Our own specs say this is the
      habit people with ADHD drop first. A real launch would need a bank
      connection or another way to save typing.
    - Typing brings mistakes (wrong amount, wrong date), which can make the
      safe-to-spend number wrong.
    - The number is only as fresh as the last thing someone typed. It can't update
      "as money comes in and goes out" on its own.
    - Several tasks in our specs must change (listed below).

## Decision
We will use **Option 2**. People enter their transactions, bills, and
subscriptions by hand, and the app comes with fake sample data. We will **not**
connect to real banks or to Plaid, not even Plaid Sandbox.

We chose this because my class allows fake data only, and because it keeps the
first build simple. With manual entry, real bank data can't get in by accident.
It also lets us spend our time on the features that help people with ADHD most.

## Consequences
**What gets easier**
- There's no bank service, bank key, or bank token to set up or protect.
- There's less to build before the first real screen works.
- Testing is easier, because we control the fake sample data and know the right
  answers.

**What gets harder**
- People must type their money in, and typing is a habit people with ADHD often
  drop. Adding an entry has to be very quick and calm.
- The safe-to-spend number depends on people keeping their entries up to date.

**Tasks in docs/specs/03-epics-features-tasks.md that change**
- **1.1** "Allow users to link a bank account in a few taps." **Removed.**
  Replaced by: add, edit, or delete a transaction by hand, and start with fake
  sample data.
- **1.1** "Allow users to see their transactions sorted into categories
  automatically, with no manual entry." **Changes.** Transactions are now entered
  by hand. Whether the app still suggests a category on its own is an open
  question in docs/architecture.md.
- **1.2** "Allow users to see the number update as money comes in and goes out."
  **Changes.** The number updates when someone adds, edits, or deletes an entry,
  not when a bank syncs.
- **6.2** "Allow users to see a plain-words privacy screen before connecting a
  bank." **Changes.** There's no bank to connect, so the privacy screen needs a
  new place in the flow.
- **6.2** "Allow users to disconnect a bank at any time." **Removed.**
- **T4** "Bank data integration." **Removed.**
- **T6** "log no raw bank credentials." **No longer needed,** because we never
  handle bank credentials. The rest of T6 stays.
- **T10** "aggregator calls cached/batched to control cost." **Removed.** The
  rest of T10 stays.

**Tasks that stay the same**
- **1.1** Fix a category if it's wrong, and have the app remember.
- **1.2** See one safe-to-spend number, and understand how it's worked out.
- **2.1** Bills are still **found automatically**, now from the transactions
  people enter instead of from bank data. People can still confirm or edit a
  found bill, or add one by hand.
- **2.2** Reminders before and on the due day, one-tap "paid" / "remind me
  later," and the bills calendar.
- **3.1 and 3.2** The pause-before-purchase check, the near-limit heads-up, kind
  wording, and the wishlist with a waiting period.
- **4.1** Subscriptions are still **found automatically**, now from entered
  transactions, with the monthly total.
- **4.2** Trial and renewal warnings, and simple cancel steps.
- **5.1 and 5.2** Calm by default, welcome back, notification controls, and
  quiet hours.
- **6.1** Sign up, sign in, and password reset.
- **6.2** Export or delete all data in one place.
- **T1, T2, T3, T5, T7, T8, T9, T11, T12, T13, T14,** plus the rest of T6
  and T10.

**What we need to do next**
1. Answer the open questions in docs/architecture.md.
2. After approval, update the other spec files that still mention banks or Plaid:
   - 01: the "Link bank" use case and the "trust with bank data" problem
   - 03: the "Architecture" line
   - 04: stories E1.1 and E6.2, and the model acceptance criteria for Task 1.1.1
   - 05: features 1.1 and 6.2
   - 06: business-logic steps 3, 4, and 9, and Phase 1
3. Write the fake sample data, using made-up names and amounts only.
4. Change this ADR's status to "Accepted" once it's approved.
