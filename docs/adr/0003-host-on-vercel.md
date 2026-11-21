# ADR-0003: Host the app on Vercel's free Hobby plan

## Date and status
November 18, 2026. Proposed

## Context
The app needs a home on the internet so people (and my teachers) can open it.
My class requires Vercel. Our specs already plan for it:
- **T1 Hosting & delivery:** deploy on Vercel, keep separate preview and
  production versions, and keep secrets only in Vercel's settings, never in the
  code, on GitHub, or in browser code.
- **T10 Performance & cost:** use free plans for MVP 1.

Vercel is already connected to our GitHub project. It built a preview version
for pull request #4.

The question is which Vercel plan to use and how to set it up.

## Options
- Option 1: Vercel's free Hobby plan
  - Good:
    - It's free, which meets T10.
    - Every pull request gets its own preview link, and merging into `main`
      updates the production version (T1).
    - Secret keys can be saved in Vercel's settings, separately for preview and
      production (T1).
    - It's made by the same company as Next.js (ADR-0001), so it needs almost no
      setup.
    - It includes Vercel Web Analytics for privacy-safe counting (T14).
  - Bad:
    - It's for personal, non-commercial projects only. A real launch would need a
      paid plan.
    - It has usage limits. That's fine for a class project, but not for many
      real users.
    - Only one person can manage the project.
- Option 2: Vercel's paid Pro plan
  - Good:
    - Allowed for commercial use, with higher limits.
    - Teammates can help manage the project.
  - Bad:
    - It costs money every month, which goes against T10's free plans for MVP 1.
    - We don't need its extra features for a class project with fake data.

## Decision
We will host the app on **Vercel's free Hobby plan**.

My class requires Vercel, and the free plan gives us everything T1 asks for:
preview and production versions, and a safe place for secret keys. It also keeps
MVP 1 free (T10).

## Consequences
**What gets easier**
- Every pull request gets a preview link to check before merging.
- Merging into `main` updates the live app automatically.
- Turning on privacy-safe counting is one setting (T14).

**What gets harder**
- If the app ever becomes a real product, we'll need a paid plan.
- We have to watch the free plan's limits.

**Rules we follow because of this**
- Secret keys go only in Vercel's settings (for preview and production) and in
  `.env.local` on your computer (rule 4).
- We never put a secret key in a setting whose name starts with `NEXT_PUBLIC_`.
  Next.js sends those settings to the browser, where anyone can read them.
- There's no daily scheduled job, so we don't use Vercel's scheduled jobs (see
  docs/architecture.md, "Worked out when the app opens").

**What we need to do next**
1. Check that the Vercel project has separate preview and production settings.
2. Add the Supabase keys to Vercel's settings when we set up the database
   (ADR-0004).
3. Turn on Vercel Web Analytics.
4. Change this ADR's status to "Accepted" once it's approved.
