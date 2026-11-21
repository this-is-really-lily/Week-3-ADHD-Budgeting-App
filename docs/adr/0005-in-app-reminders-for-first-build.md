# ADR-0005: Use in-app reminders for the first build, not email or push

## Date and status
November 18, 2026. Proposed

## Context
Several parts of our specs need the app to remind or warn people:
- **2.2:** a reminder a few days before a bill is due and on the due day.
- **3.2:** a reminder after a wishlist waiting period ends.
- **4.2:** a warning before a free trial turns paid or a yearly renewal charges.
- **5.2:** people choose how often, which types, and quiet hours.
- **T8 Notifications:** reliable push or email delivery, respecting quiet hours,
  and never showing money details in a notification preview.

On Nov 18, 2026 we also decided there will be no daily scheduled job. Everything
is worked out when the person opens the app (docs/architecture.md).

We have to decide how reminders reach people in this first build.

## Options
- Option 1: Email reminders
  - Good:
    - They reach people even when the app is closed. That matters for people
      with ADHD, who can forget about things they can't see.
    - Fully meets T8.
  - Bad:
    - Needs an email-sending service, another secret key, and its own ADR.
    - Needs a scheduled job to check what's due and send emails. That goes
      against our "no daily job" decision.
    - We'd have to make sure no email preview shows money details (T8).
    - Our test accounts use made-up email addresses (rule 6), so test emails
      would never arrive anywhere.
- Option 2: In-app reminders: a "Due soon" list on Home
  - Good:
    - No email service, no new secret keys, and no scheduled job.
    - Nothing can leak in a notification preview, because there are no
      notifications.
    - Works fully with fake data.
    - Fits the "worked out when the app opens" design.
  - Bad:
    - People only see reminders when they open the app. Someone who forgets to
      open it can still miss a bill. This is the biggest weakness for our
      audience.
    - Only partly meets T8 and 2.2 for now.
    - "How often" and "quiet hours" mean something different for a list than for
      notifications. That still needs deciding.

## Decision
We will use **in-app reminders only** for the first build. Home shows a **"Due
soon" list** with:
- bills due today or in the next 3 days
- free trials ending, or yearly renewals charging, in the next 3 days
- wishlist items whose waiting period is over

Notification settings (types, how often, and quiet hours) control what shows in
that list and when.

**Email reminders are planned for a later version.**

We chose this because it keeps the first build simple, needs no new outside
service or keys, matches our "no daily job" decision, and works with fake data.

## Consequences
**What gets easier**
- There's no email service or scheduled job to set up, protect, or test.
- No money details can leak in a notification preview.

**What gets harder**
- **This only partly meets T8 for now.** People see reminders only when they
  open the app. Reminders that reach people when the app is closed wait for
  the later email version.
- 2.2's reminder "before and on the due day" becomes "shows in Due soon from 3
  days before through the due day."
- The meaning of "how often" and "quiet hours" for the list is still an open
  question.

**What we need to do next**
1. Decide what "how often" and "quiet hours" change in the "Due soon" list.
2. When we're ready for email, write a new ADR for the email-sending service and
   how emails are timed.
3. Change this ADR's status to "Accepted" once it's approved.
