# BDD Scenarios + Acceptance Criteria – MVP 1

One block per feature. Each block has a Given / When / Then scenario and an acceptance-criteria checklist.

## EPIC 1 — Know what's safe to spend

### 1.1 Connect the bank and see transactions
**BDD:** Given I'm a signed-in user with no bank linked, When I connect my bank through the secure flow and it succeeds, Then my recent transactions appear sorted into categories with no manual entry.
- Bank connects in a few taps via the aggregator; a failed connection shows a clear retry, not a crash.
- Transactions import and each gets an automatic category.
- I can change a category, and the same merchant is categorized that way next time.
- Access tokens are stored encrypted server-side and never exposed to the client.

### 1.2 One safe-to-spend number
**BDD:** Given my bank is linked and bills are known, When I open the app, Then the home screen shows one number — what's safe to spend today — with a plain-words explanation available.
- Exactly one primary number is shown on the home screen.
- Tapping "how is this worked out?" explains it in plain language (available − upcoming bills − savings, to next payday).
- The number updates after new transactions sync.
- If data is incomplete, the app shows uncertainty instead of a confident wrong number.

## EPIC 2 — Never miss a bill

### 2.1 Find bills automatically
**BDD:** Given I have recurring payments in my history, When the app analyzes my transactions, Then it lists recurring bills and lets me confirm, edit, or add one by hand.
- Recurring bills are detected with name, amount, and due date.
- I can confirm, edit, or delete a detected bill, and add one manually.
- Confirmed bills feed the safe-to-spend calculation.

### 2.2 Gentle reminders
**BDD:** Given I have a confirmed bill due soon, When the reminder time arrives, Then I get a gentle reminder before and on the due day, and can mark it paid or snooze in one tap.
- A reminder fires a set number of days before and on the due day.
- One tap marks "paid"; one tap does "remind me later."
- Upcoming bills show on a calendar.
- Reminder wording is kind; the notification preview shows no sensitive amounts.

## EPIC 3 — Pause before you buy

### 3.1 Pause-before-purchase check
**BDD:** Given I'm about to make a purchase, When I enter the amount in the pause check, Then I see what it does to today's safe-to-spend number, in kind wording, with a near-limit heads-up if relevant.
- The check shows the new safe-to-spend number after the purchase.
- A heads-up appears when the purchase would take me near or past my limit.
- No red "failure" styling or shaming language is used.

### 3.2 Wishlist with a waiting period
**BDD:** Given I want something but am not sure, When I add it to the wishlist with a waiting period, Then the app holds it and reminds me after the period to decide on purpose.
- I can add an item with a chosen waiting period.
- After the period, I get a reminder to decide.
- I can remove or buy from the wishlist at any time.

## EPIC 4 — Stop paying for unused subscriptions

### 4.1 See every subscription
**BDD:** Given I have subscriptions in my transactions, When the app analyzes them, Then I see all of them and their total monthly cost in one place.
- Subscriptions are detected and listed with amount and cadence.
- A clear monthly total is shown.
- I can remove something wrongly flagged as a subscription.

### 4.2 Catch charges before they hit
**BDD:** Given a free trial or yearly renewal is coming up, When the charge date approaches, Then I get a warning beforehand and see simple steps to cancel.
- A warning fires before a known trial-to-paid or yearly renewal date.
- Each subscription shows simple cancel steps.

## EPIC 5 — Calm, not shame

### 5.1 Kind by default
**BDD:** Given I overspent or haven't opened the app in a while, When I return, Then I'm met with a calm "welcome back" that resets my view in one step, with no red numbers or blame.
- No red/shame states anywhere, even when over budget.
- A one-step "welcome back" reset is available after a gap or a slip.
- Copy stays encouraging throughout.

### 5.2 Control the nudges
**BDD:** Given notifications feel like too much or too little, When I open notification settings, Then I can choose how often and which types I get, and set quiet hours.
- I can turn each notification type on/off and set frequency.
- Quiet hours suppress notifications in the chosen window.
- Settings take effect immediately.

## EPIC 6 — Account & data foundations

### 6.1 Sign up and sign in
**BDD:** Given I'm a new user, When I create an account and sign in, Then my session is secure and I can reset a forgotten password.
- Sign up, sign in, sign out, and password reset all work.
- Sessions expire and refresh securely; passwords are never stored in plain text.

### 6.2 Privacy and control
**BDD:** Given I care about my data, When I reach the bank-connect step, Then I first see a plain-words privacy screen, and I can disconnect, export, or delete all my data at any time.
- A plain-words privacy screen appears before any bank connection.
- I can disconnect a bank, export my data, and delete all data — each in one place.
- Deletion removes my data from the database (subject to legal retention).
