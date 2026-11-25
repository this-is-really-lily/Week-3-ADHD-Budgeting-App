# ADR-0006: Turn off email confirmation and skip SMS for the class build

## Date and status
November 24, 2026. Proposed

## Context
When someone signs up, Supabase Auth (ADR-0004) can send a confirmation email
first, and only let them in after they click the link. We have to decide whether
to turn that on.

Things that matter here:
- **Spec 6.1:** sign up, sign in, sign out, and reset a forgotten password.
- **Rule 6 in CLAUDE.md:** fake data only. Test accounts use made-up email
  addresses, which can't receive mail.
- **Supabase's built-in email sender** only delivers to email addresses on our
  Supabase team until we connect our own email service. It also has a low
  sending limit (ADR-0004).
- **ADR-0005:** there are no email reminders in this build, so we don't have our
  own email service yet.

## Options
- Option 1: Email confirmation on, using Supabase's built-in sender
  - Good:
    - Proves each person owns the email address they typed.
    - It's the safer setting for a real launch.
  - Bad:
    - Confirmation emails only reach addresses on our Supabase team, so
      classmates and teachers couldn't finish signing up.
    - Made-up test addresses never get the email, so test accounts could never
      sign in.
- Option 2: Email confirmation off
  - Good:
    - People are signed in right after sign-up, which is one less step.
    - Works with made-up test addresses (rule 6).
    - No email service to set up for sign-up.
  - Bad:
    - Nobody checks that a person owns the email they typed.
    - Must be turned back on, with a real email sender, before any real launch.
- Option 3: Confirm with a text message (SMS)
  - Good:
    - Proves the person has the phone.
  - Bad:
    - Needs a paid text-message service.
    - Needs people's real phone numbers, which goes against rule 6 (fake data
      only) and collects more personal data than we need (T6).

## Decision
For this class build, we will **turn email confirmation off** and **not use SMS
confirmation**. People are signed in right after they sign up.

"Forgot password" still uses Supabase's emailed reset link. Until we add our own
email sender, **reset emails only reach addresses on our Supabase team.**

We chose this because it's the only option that works with fake test accounts,
needs no paid service, and collects no phone numbers.

## Consequences
**What gets easier**
- Sign-up is one step shorter.
- Testing with made-up accounts works.
- No email or text service to set up, pay for, or protect.

**What gets harder**
- We can't be sure a person owns the email address they used.
- "Forgot password" only works for addresses on our Supabase team. Anyone else
  who forgets their password can't reset it in this build.

**Later work (not part of MVP 1)**
- **Custom email sender:** connect our own email service to Supabase, so reset
  emails (and later, confirmation and reminder emails) reach anyone. This needs
  its own ADR.
- **SMS confirmation:** only if we ever need it, and only with a paid service and
  a clear reason to collect phone numbers.
- Turn email confirmation back on before any real launch.

**What we need to do next**
1. In the Supabase dashboard (Supabase's settings website), turn off "Confirm
   email" for email sign-ups.
2. Check that the password-reset link works for an address on our team.
3. Change this ADR's status to "Accepted" once it's approved.
