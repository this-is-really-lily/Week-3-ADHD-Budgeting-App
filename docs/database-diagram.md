# Database Diagram – MVP 1

How the tables connect. Details for every column are in docs/database-design.md.

Money is saved in US cents as whole numbers (`bigint`): $12.50 is 1250.
Money columns end in `_cents`.

```mermaid
erDiagram
    PEOPLE ||--o| MONEY_SETUP : "has at most one"
    PEOPLE ||--o| SETTINGS : "has at most one"
    PEOPLE ||--o{ TRANSACTIONS : "has many"
    PEOPLE ||--o{ CATEGORY_RULES : "has many"
    PEOPLE ||--o{ BILLS : "has many"
    PEOPLE ||--o{ SUBSCRIPTIONS : "has many"
    PEOPLE ||--o{ WISHLIST_ITEMS : "has many"

    PEOPLE {
        uuid id PK "Supabase Auth's built-in sign-in list"
        text email
    }
    MONEY_SETUP {
        uuid id PK
        uuid user_id FK
        bigint balance_today_cents
        date balance_as_of
        date next_payday
        text pay_frequency
        bigint savings_per_period_cents
        boolean is_sample
    }
    SETTINGS {
        uuid id PK
        uuid user_id FK
        text time_zone
        text safe_to_spend_view
        timestamptz privacy_seen_at
        boolean show_bills
        boolean show_trials_and_renewals
        boolean show_wishlist
        text due_soon_frequency
        time quiet_hours_start
        time quiet_hours_end
        date last_opened_on
    }
    TRANSACTIONS {
        uuid id PK
        uuid user_id FK
        date happened_on
        bigint amount_cents
        text description
        text category
        text direction
        boolean is_sample
    }
    CATEGORY_RULES {
        uuid id PK
        uuid user_id FK
        text match_text
        text category
    }
    BILLS {
        uuid id PK
        uuid user_id FK
        text name
        bigint amount_cents
        date due_on
        text repeats
        boolean is_confirmed
        boolean is_added_by_hand
        boolean is_paid
        date snoozed_until
        boolean is_dismissed
        boolean is_sample
    }
    SUBSCRIPTIONS {
        uuid id PK
        uuid user_id FK
        text name
        bigint amount_cents
        text charges_every
        date next_charge_on
        date trial_ends_on
        text cancel_note
        boolean is_added_by_hand
        boolean is_dismissed
        boolean is_sample
    }
    WISHLIST_ITEMS {
        uuid id PK
        uuid user_id FK
        text name
        bigint price_cents
        integer waiting_days
        date added_on
        boolean is_decided
        boolean is_sample
    }
```

## The same thing in words

- **PEOPLE** is Supabase's built-in sign-in list. We don't create it.
- Each person has **at most one** money setup and **at most one** settings row.
- Each person can have **many** transactions, category rules, bills,
  subscriptions, and wishlist items.
- Every one of those rows belongs to **exactly one** person, through `user_id`.
- The other tables don't point to each other. They only point to the person.

**Symbols used:**
- **PK** ("primary key") is the row's own unique ID.
- **FK** ("foreign key") is a pointer to the row it belongs to.
- In the lines, `||` means "exactly one," `o|` means "zero or one," and `o{`
  means "zero or many."
