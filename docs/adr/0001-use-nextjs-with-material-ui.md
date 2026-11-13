# ADR-0001: Use Next.js (TypeScript) with Material UI for the app's screens

## Date and status
November 12, 2026. Proposed

## Context
We are starting to build the screens for the MVP 1 budgeting app for adults with ADHD.
We have to pick the tools we will use to build them. My class requires Next.js with
TypeScript and the Material UI (MUI) design system. Our build plan
(docs/specs/06-business-logic-and-build-plan.md, Phase 0) already lists Next.js and
TypeScript.

The choice needs to support these parts of our specs:

- **T9 Accessibility and plain language** (docs/specs/03-epics-features-tasks.md):
  meet WCAG 2.2 AA, show one decision per screen, and offer a reduced-motion option.
  MUI's ready-made parts (buttons, forms, dialogs) are built to work with a keyboard
  and screen readers, so we start from a good place.
- **T11 Compatibility and reach**: work on current Chrome, Safari, Firefox, and Edge,
  and on small phone screens with no sideways scrolling. MUI's grid and screen-size
  tools help layouts fit phones.
- **T1 Hosting on Vercel**: Vercel is the company that makes Next.js, so the two work
  together with very little setup.
- **T2, T4, and project rule 5 (database calls happen on the server only)**: Next.js
  lets us write server code in the same project. The browser asks our server, and
  only the server talks to Supabase and the bank service (Plaid). Secret keys stay
  on the server.
- **Epic 5 Calm, not shame**: MUI has a theme, which is one place where we set the
  colors and fonts for the whole app. We can use it to set calm colors and remove
  red "error" styling across the app.

## Options
- Option 1: Next.js (TypeScript) with Material UI
  - Good:
    - It's what my class requires.
    - We get browser code and server code in one project, so secret keys and
      database calls stay on the server (rule 5, T2, T4).
    - It works with Vercel with almost no setup (T1).
    - Pages can be prepared on the server before they're sent, so the home screen
      shows up fast (T10).
    - MUI gives us ready-made, tested parts that already handle a lot of keyboard
      and screen reader support (T9).
    - MUI has tools for building layouts that fit any screen size (T11).
    - One theme controls colors and fonts everywhere, which makes "no red, no shame"
      easy to keep consistent (Epic 5).
    - TypeScript catches many mistakes before the app runs, like using a number
      where text is expected.
  - Bad:
    - There's more to learn: Next.js rules, TypeScript, and MUI all at once.
    - MUI needs some extra setup to work with the newer Next.js way of building
      pages (the "App Router").
    - MUI's default look is "Google-style." We'll need to change the theme so the
      app feels calm and friendly, not generic.
    - MUI's default "error" color is red. We have to change it on purpose.
    - MUI adds some extra code to download, which can slow the first load a little
      if we're not careful.
    - MUI does not pass accessibility checks on its own. We still have to test our
      own screens, wording, and colors.

- Option 2: Plain React (with no framework)
  - Good:
    - It's simpler to start, with fewer rules and less to learn at first.
    - It's very popular, with lots of guides online.
    - We can choose any design system or none.
  - Bad:
    - It has no server part. We'd need to build and host a separate server for the
      database and bank calls, or we might put them in browser code by accident,
      which would break rule 5 and leak secret keys.
    - We'd have to add and set up our own tools for page links (routing) and for
      building and loading the app.
    - Pages are built in the user's browser, so the first load is often slower on
      phones (T10).
    - Plain React gives us no accessible parts. We'd build every button and dialog
      ourselves or add a library anyway (T9).
    - It doesn't meet my class requirement.

## Decision
We will build the app with **Next.js and TypeScript** and use **Material UI** for
the screens.

We chose this because my class requires it, and because it fits our specs well.
It keeps secrets and database calls on the server (rule 5, T2, T4), it works easily
with Vercel (T1), and MUI gives us an accessible, phone-friendly base (T9, T11).
MUI's theme also lets us keep the whole app calm with no red (Epic 5).
Plain React would mean more setup, a separate server, and more risk of putting
secrets in browser code.

## Consequences
**What gets easier**
- Keeping secret keys and database calls on the server, in one project.
- Putting the app on Vercel, with preview and production versions.
- Building forms, buttons, and dialogs that already work with a keyboard and
  screen readers.
- Making screens that fit phones and every major browser.
- Changing colors and fonts for the whole app in one place.

**What gets harder**
- Learning three tools at once (Next.js, TypeScript, MUI).
- Making the app not look like a generic MUI app. We need our own calm theme.
- Watching how much code we send to the browser, so the home screen stays fast.

**What we need to do next**
1. Set up a new Next.js project with TypeScript (App Router).
2. Add Material UI and its Next.js setup.
3. Make a calm theme: no red for errors or low numbers, readable font sizes, colors
   with enough contrast for WCAG 2.2 AA, and animations turned off when the user
   asks for reduced motion.
4. Agree on one rule: Supabase and Plaid calls only happen in server code.
5. Test every screen ourselves for accessibility and phone widths. We don't assume
   MUI handles it.
6. Change this ADR's status to "Accepted" once you approve it.
