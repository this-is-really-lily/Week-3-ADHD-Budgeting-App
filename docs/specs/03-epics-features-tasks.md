# Epics, Features and Tasks – MVP 1

Audience: Adults with ADHD who overspend or miss bills.
Architecture: Vercel hosting, Supabase database, user accounts, bank data via an aggregator (e.g., Plaid).

## FUNCTIONAL BACKLOG

### EPIC 1: Know what's safe to spend
**1.1 FEATURE: Connect the bank and see transactions**
- Allow users to link a bank account in a few taps.
- Allow users to see their transactions sorted into categories automatically, with no manual entry.
- Allow users to fix a category if it's wrong, and have the app remember.

**1.2 FEATURE: One safe-to-spend number**
- Allow users to open the app and see one number: what's safe to spend today after bills and savings.
- Allow users to understand how the number is worked out in plain words.
- Allow users to see the number update as money comes in and goes out.

### EPIC 2: Never miss a bill
**2.1 FEATURE: Find bills automatically**
- Allow users to have recurring bills found automatically from bank data.
- Allow users to confirm or edit a found bill.
- Allow users to add a bill by hand if it isn't found.

**2.2 FEATURE: Gentle reminders**
- Allow users to get a reminder a few days before a bill is due and on the due day.
- Allow users to mark a bill paid, or "remind me later," in one tap.
- Allow users to see upcoming bills on a simple calendar.

### EPIC 3: Pause before you buy
**3.1 FEATURE: Pause-before-purchase check**
- Allow users to check what a purchase does to today's safe-to-spend number before they buy.
- Allow users to get a heads-up when they're close to their limit.
- Allow users to see kind, non-judging wording, never a red failure screen.

**3.2 FEATURE: Wishlist with a waiting period**
- Allow users to park a want on a wishlist instead of buying it now.
- Allow users to be reminded after the waiting period to decide on purpose.

### EPIC 4: Stop paying for unused subscriptions
**4.1 FEATURE: See every subscription**
- Allow users to have subscriptions found automatically from bank data.
- Allow users to see all subscriptions and their total monthly cost in one place.

**4.2 FEATURE: Catch charges before they hit**
- Allow users to get a warning before a free trial turns into a paid plan.
- Allow users to get a warning before a yearly renewal charges.
- Allow users to see simple steps to cancel a subscription.

### EPIC 5: Calm, not shame
**5.1 FEATURE: Kind by default**
- Allow users to open the app without feeling judged, with no red numbers or "you overspent" alerts.
- Allow users to come back after a slip and reset in one step through a "welcome back" flow.

**5.2 FEATURE: Control the nudges**
- Allow users to choose how often they get notifications and which types.
- Allow users to set quiet hours.

### EPIC 6: Account & data foundations
**6.1 FEATURE: Sign up and sign in**
- Allow users to create an account and sign in securely.
- Allow users to reset a forgotten password.

**6.2 FEATURE: Privacy and control**
- Allow users to see a plain-words privacy screen before connecting a bank.
- Allow users to disconnect a bank at any time.
- Allow users to export or delete all their data in one place.

## NON-FUNCTIONAL / TECHNICAL BACKLOG

- **T1. Hosting & delivery (Vercel):** app deployed on Vercel; separate preview and production; secrets only in Vercel env config, never in repo or client.
- **T2. Database & backend (Supabase):** user data, bills, subscriptions, settings in Supabase Postgres; Row-Level Security so each user reads/writes only their own rows; service-role key server-side only.
- **T3. Accounts & auth:** Supabase Auth; email/password (and optional magic link); sessions expire and refresh securely.
- **T4. Bank data integration:** connect via an aggregator (e.g., Plaid); tokens stored encrypted server-side, never in the client; handle broken connections with a clear reconnect flow.
- **T5. Security & secure coding:** HTTPS only; secure headers + CSP; input sanitized; dependencies pinned and scanned in CI; least-privilege secrets with rotation.
- **T6. Data protection & privacy:** encrypt sensitive data at rest and in transit; collect the minimum needed; clear privacy policy and terms; user can export/delete all data; log no raw bank credentials.
- **T7. Accuracy:** safe-to-spend, bill, and subscription detection validated against test data; show uncertainty instead of a wrong-confident number; record how each number is derived.
- **T8. Notifications:** reliable push/email delivery; respect quiet hours and user settings; never leak financial detail in a notification preview.
- **T9. Accessibility & plain language:** meet WCAG 2.2 AA plus W3C COGA; one decision per screen; reduced-motion option; text at roughly a 7th-grade level.
- **T10. Performance & cost:** home screen loads in a few seconds; Supabase/Vercel free tiers at MVP; aggregator calls cached/batched to control cost.
- **T11. Compatibility & reach:** works on current Chrome, Safari, Firefox, Edge; usable from small phone widths up, no horizontal scrolling.
- **T12. Maintainability:** categorization and detection rules configurable and covered by automated tests, not hard-coded.
- **T13. Compliance:** handle financial data per applicable rules; clear terms; not financial advice (disclaimer).
- **T14. Observability (privacy-safe):** anonymous, aggregate, content-free metrics; never log transaction text or amounts tied to a person.
