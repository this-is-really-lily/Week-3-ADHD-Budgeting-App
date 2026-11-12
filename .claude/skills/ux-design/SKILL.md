---
name: ux-design
description: Use whenever designing, building, or reviewing a user-facing feature, screen, flow, or component (pages, forms, dashboards, onboarding, navigation, error messages, empty states, UI copy) so it is clear, consistent, and easy to use. Also use when the user mentions UX, usability, user flow, or user experience. Pair with the accessibility skill for any UI work.
---

# UX Design Standards

Build interfaces that help real people finish their goals quickly and confidently. Before building, understand who the user is and what they are trying to do. If that is unclear, ask.

## Before building
- State the user, their goal, and the main task in one or two sentences.
- Map the happy path, then the edge cases (no data, slow network, errors, first-time user, power user).
- Reuse existing components, patterns, and design tokens in the codebase before creating new ones.

## Core rules (based on Nielsen's 10 usability heuristics)
1. **Show system status.** Give feedback for every action: loading indicators, success confirmations, progress for multi-step tasks.
2. **Speak the user's language.** Use plain words, not internal jargon, database field names, or error codes.
3. **Give users control.** Provide Cancel, Back, and Undo. Confirm destructive actions ("Delete 3 files?") and name what will happen.
4. **Be consistent.** Same action = same label, icon, position, and style everywhere. Follow platform conventions.
5. **Prevent errors.** Use good defaults, constraints, and inline validation instead of failing after submit.
6. **Recognition over recall.** Keep options visible; don't make users remember information from a previous screen.
7. **Support novices and experts.** Keep the main path simple; offer shortcuts and bulk actions where useful.
8. **Keep it minimal.** Every element must earn its place. One primary action per screen, visually clear.
9. **Help users recover from errors.** Say what went wrong, why, and how to fix it, in plain language, next to the problem.
10. **Provide help in context.** Hints, tooltips, and helpful empty states before external docs.

## Every screen must handle these states
- [ ] Loading (skeleton or spinner, no layout jumps)
- [ ] Empty (explain what goes here + a clear next action)
- [ ] Error (friendly message + a way to recover)
- [ ] Partial / slow data
- [ ] Success / confirmation
- [ ] Long content and very short content (long names, many items, zero items)

## Layout & content
- Clear visual hierarchy: the most important thing is the most prominent.
- Use the existing spacing, type scale, and color tokens; don't hard-code one-off values.
- Mobile-first and responsive: test at small (~375px), medium, and large widths.
- Button labels are verbs that say what happens ("Save changes", not "OK").
- Write concise, friendly, specific microcopy. Sentence case.

## Never
- Use dark patterns (hidden costs, confirm-shaming, pre-checked opt-ins, hard-to-find cancel)
- Leave a screen without loading, empty, and error states
- Invent a new pattern when an existing one in the product works
- Show raw technical errors or stack traces to users

## Before you say you're done
- [ ] Walked through the main flow as a first-time user
- [ ] All states above exist and look intentional
- [ ] Checked at mobile and desktop widths
- [ ] Copy is clear and consistent
- [ ] Ran the accessibility skill checklist
- [ ] Told the user about any UX trade-offs or open questions
