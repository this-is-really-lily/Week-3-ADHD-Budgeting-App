# User Stories + Model Acceptance Criteria – MVP 1

Persona: Alex, an adult with ADHD who overspends or misses bills.

## Feature-level user stories
- **E1.1 Connect bank:** As an adult with ADHD, I want to link my bank in a few taps, so that I never have to enter transactions by hand (the habit I always drop).
- **E1.2 Safe-to-spend number:** As an adult with ADHD, when I open the app, I want to see one number for what's safe to spend today, so that I can decide without wading through charts.
- **E2.1 Find bills automatically:** As an adult with ADHD, I want my recurring bills found for me, so that I don't rely on remembering them.
- **E2.2 Gentle reminders:** As an adult with ADHD, when a bill is due, I want a gentle reminder before and on the day, so that I avoid late fees and overdrafts.
- **E3.1 Pause check:** As an adult with ADHD, when I'm about to buy something, I want to see what it does to today's number, so that I buy on purpose instead of on impulse.
- **E3.2 Wishlist waiting period:** As an adult with ADHD, when I want something now, I want to park it with a waiting period, so that I avoid purchases I'd regret.
- **E4.1 See subscriptions:** As an adult with ADHD, I want all my subscriptions and their monthly total in one place, so that I stop paying for things I don't use.
- **E4.2 Catch charges:** As an adult with ADHD, when a trial or renewal is about to charge, I want a warning and cancel steps, so that I'm not charged by surprise.
- **E5.1 Kind by default:** As an adult with ADHD, when I've slipped or been away, I want a calm welcome-back with no red or blame, so that I keep using the app instead of avoiding it.
- **E5.2 Control the nudges:** As an adult with ADHD, I want to control how often and when I'm notified, so that the app doesn't overwhelm me.
- **E6.1 Sign up / sign in:** As an adult with ADHD, I want to create an account and sign in securely, so that my financial data is protected.
- **E6.2 Privacy & control:** As an adult with ADHD, before I connect my bank, I want a plain-words privacy screen and the power to delete my data, so that I can trust the app.

## Model acceptance criteria — Task 1.1.1 Connect a bank account
**User story:** As an adult with ADHD, I want to link my bank in a few taps, so that I never have to enter transactions by hand.
**Background:** Manual tracking is the first habit ADHD users drop; auto-import from the bank is what makes the whole app work.
**Problem statement:** They forget bills and overspend partly because they never have a current picture of their money; manual entry fails for them.
**Task goals:** User connects an account quickly and sees imported, categorized transactions; user trusts the connection is secure.
**Expected deliverables:** Bank-connect screen with privacy notice; aggregator (e.g. Plaid) link flow; imported transactions list; error/retry state; encrypted token storage server-side.
**Scope / definition of done:** Supports linking at least one account; imports recent transactions; each transaction gets an auto category; a failed/cancelled connection shows a clear retry, not a crash; tokens never reach the client.

Acceptance:
- Connect flow completes in a few taps from the home/onboarding screen.
- On success, recent transactions appear sorted into categories with no manual entry.
- On failure or cancel, show a plain-words retry; never a blank screen or crash.
- Access tokens are stored encrypted server-side and never exposed to the client.
- The privacy notice is shown before the bank connection begins.
- Works on current Chrome, Safari, Firefox, Edge and at phone widths.

## Model acceptance criteria — Task 1.2.1 See the safe-to-spend number
**User story:** As an adult with ADHD, when I open the app, I want one number for what's safe to spend today, so that I can decide without wading through charts.
**Background:** Dashboards with many categories overwhelm ADHD users; one number answers "can I buy this?"
**Problem statement:** Too much info and too many decisions cause avoidance; users need one clear answer.
**Task goals:** User sees a single, trustworthy safe-to-spend figure and understands it; the figure stays current.
**Expected deliverables:** Home screen with the number; plain-words explanation ("how is this worked out?"); recalculation on sync; uncertainty state.
**Scope / definition of done:** Exactly one primary number on the home screen; formula = money available − upcoming bills − savings set aside, to next payday; updates after new transactions; shows uncertainty when data is incomplete rather than a confident wrong number.

Acceptance:
- Exactly one primary number is shown on the home screen.
- Tapping "how is this worked out?" explains it in plain language.
- The number updates after new transactions sync.
- When data is incomplete or pending, the app shows uncertainty, not a confident wrong number.
- No red/shame styling, even when the number is low or zero.
- Readable at a ~7th-grade level and at phone widths.
