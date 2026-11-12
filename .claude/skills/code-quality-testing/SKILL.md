---
name: code-quality-testing
description: Use whenever writing, refactoring, debugging, or reviewing code in any language, and before declaring any coding task complete. Covers readability, structure, error handling, and writing and running tests. Also use when the user mentions tests, bugs, refactoring, code review, linting, or "is this done?".
---

# Code Quality & Testing Standards

Code is read far more often than it is written. Write code a new teammate could understand, change, and trust. "Done" means working and verified, not just written.

## Before writing code
- Restate what the change must do and how you'll know it works (acceptance criteria). Ask if unclear.
- Read the surrounding code first. Follow the project's existing conventions, structure, and libraries.
- Prefer the smallest change that solves the problem. Don't rewrite unrelated code.

## Writing code
- **Clear names:** variables and functions say what they are/do (`calculateMonthlyTotal`, not `calc2`).
- **Small units:** each function does one thing. If you need "and" to describe it, split it.
- **No duplication:** extract shared logic instead of copy-pasting.
- **Simple over clever:** readable code beats short code.
- **Handle errors explicitly:** never swallow exceptions silently; give useful messages; handle null/empty/edge cases.
- **No magic values:** use named constants or config.
- **Comments explain *why*, not *what*.** Keep them up to date.
- Remove dead code, debug logs, and commented-out blocks before finishing.
- Use types (TypeScript, type hints) where the project supports them.

## Testing
- Every new feature or bug fix gets tests. For bugs: first write a test that fails, then fix it.
- Test behavior, not implementation details.
- Cover: the happy path, edge cases (empty, zero, max, invalid input), and error paths.
- Use the project's existing test framework. If none exists, propose one before adding it.
- Tests must be independent, repeatable, and fast. Mock external services, not your own logic.
- **Actually run the tests** and the linter/formatter/type-checker. Report real results.

## Never
- Say "this should work" or "done" without running the code or tests
- Delete, skip, or weaken a failing test to make the suite pass
- Leave TODOs, placeholder logic, or fake/hard-coded data that pretends to work without telling the user
- Silently change behavior outside the scope of the task

## Before you say you're done
- [ ] Code runs without errors
- [ ] Tests written for new/changed behavior, and all tests pass (show the output)
- [ ] Linter / formatter / type-checker clean (if the project has them)
- [ ] No debug code, secrets, or unused code left behind
- [ ] Ran the security skill checklist if the change touches input, auth, data, or dependencies
- [ ] Summarized for the user: what changed, how it was tested, and anything left unfinished
