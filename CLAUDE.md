# Project rules for Claude

## 1. I am a beginner
- Explain everything in plain words. No jargon without a simple explanation.
- Before you change anything, tell me your plan and wait for me to say yes.

## 2. Read the docs first
- Before making any changes, read every file in `docs/specs` and `docs/adr`.
- `docs/specs` describes what the app should do.
- `docs/adr` records the big technical decisions already made, and why.

## 3. Write an ADR before big decisions
- Before any big technical decision, write a new ADR in `docs/adr` first.
- Examples of "big": choosing a framework, database, login method, or hosting service,
  or changing how the app is structured.
- Name files with a number and a short title, e.g. `docs/adr/0001-use-nextjs.md`.
- Each ADR says: what we decided, why, what other options we considered, and what happens because of it.

## 4. Secret keys stay secret
- Never put secret keys, passwords, or tokens in code, and never put them on GitHub.
- Keys go in `.env.local` only.
- Make sure `.env.local` is listed in `.gitignore` so it is never uploaded.

## 5. Database calls happen on the server only
- Every database call happens in server code, never in browser code.
- The browser asks the server; the server talks to the database.

## 6. Fake data only
- Use only fake, made-up data (names, emails, addresses, etc.).
- Never use real people's personal information.
