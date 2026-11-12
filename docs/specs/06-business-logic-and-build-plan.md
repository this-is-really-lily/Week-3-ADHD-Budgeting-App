# Business Logic + Build Plan – MVP 1

Architecture: Vercel + Supabase + bank aggregator (e.g., Plaid) + user accounts. This app has accounts and stores bank data, so the build order starts with sign-in and secure data.

## Business logic (the flow)
1. Start
2. User signs up / signs in
3. User sees a plain-words privacy screen, then connects a bank account (via aggregator, e.g. Plaid)
4. App securely pulls accounts, balances, and transactions
5. App categorizes transactions automatically (user can correct; app remembers)
6. App detects recurring bills and subscriptions from the transaction history
7. App calculates SAFE-TO-SPEND = available money − upcoming bills − savings set aside, until next payday
8. Home screen shows ONE number: what's safe to spend today (plain-words explanation available)

Branches from the home screen:
- **A. Bills:** show upcoming bills on a calendar → remind a few days before + on due day → one-tap "paid" / "remind me later"
- **B. Pause before you buy:** user enters/plans a purchase → app shows the effect on today's number → yes / wait (wishlist + waiting period) / near-limit heads-up → kind wording, never red
- **C. Subscriptions:** list all + monthly total → warn before free-trial-to-paid and before yearly renewal → show simple cancel steps
- **D. Calm / comeback:** after a slip or a gap, "welcome back" one-step reset; no shame; user controls notifications + quiet hours

9. Nightly / refresh: app re-syncs transactions, updates categories, bills, subscriptions, and recalculates safe-to-spend
10. User can disconnect bank, export, or delete all data at any time

## Build plan (phases)

### Phase 0 — Foundations
- GitHub repo, Next.js + TypeScript, Vercel project (preview + production); secrets in Vercel env config only.
- Supabase: tables for users, accounts, transactions, bills, subscriptions, settings; Row-Level Security on so each user sees only their own rows; service-role key server-side only.
- Supabase Auth (email/password, optional magic link); password reset; secure sessions.
- Security/privacy baseline: HTTPS, secure headers + CSP, encrypted secrets, dependency pinning/scanning in CI, encryption of sensitive data at rest, data export/delete, "not financial advice" disclaimer.
- Evaluation/test harness early: sample/sandbox bank data + expected results for categorization, bill and subscription detection, and the safe-to-spend calc, with an accuracy threshold. Measure from day one.

### Phase 1 — Prove the engine (highest risk first)
- Bank connection via the aggregator: connect, store tokens encrypted server-side, handle broken connections + reconnect.
- Transaction sync + automatic categorization (with user correction that the app remembers).
- Recurring-bill and subscription detection from transaction history.
- Safe-to-spend calculation, showing uncertainty rather than a confidently wrong number.
- Check all of the above against the test data before building screens around it.

### Phase 2 — Make it usable
- Onboarding: sign up → privacy screen → connect bank → first safe-to-spend number, in minutes.
- Home screen: the one safe-to-spend number + plain-words explanation.
- Bills: calendar, reminders, one-tap paid / remind later.
- Pause-before-purchase check + wishlist with waiting period + near-limit heads-up.
- Subscriptions: list, monthly total, trial/renewal warnings, cancel steps.

### Phase 3 — Trust, calm, launch-readiness
- Calm by default: no red/shame states, welcome-back one-step reset, kind copy everywhere.
- Notification controls + quiet hours; never show financial detail in a preview.
- Accessibility (WCAG 2.2 AA + W3C COGA), one decision per screen, reduced motion, ~7th-grade reading level.
- Security hardening: RLS review, secrets rotation, rate limits, input sanitization; privacy-safe (content-free) metrics.
- Performance pass (home loads in seconds; sync batched/cached) across major browsers and phone widths.

### Phase 4 — Launch
- End-to-end test with a few accounts (sandbox / fake data), run the test harness one more time as a release gate, deploy to production on Vercel, and watch the content-free metrics.
