---
name: git-workflow
description: "Use whenever working with git or GitHub: creating branches, staging and committing changes, writing commit messages, pushing, opening or reviewing pull requests, merging, or resolving conflicts. Also use at the start of any coding task in a git repository to make sure work happens on the right branch."
---

# Git & Pull Request Workflow

Keep history clean, changes reviewable, and `main` always working.

## Branches
- Never commit directly to `main`. Start every task on a new branch from an up-to-date `main`.
- Branch names: `type/short-description`, e.g. `feature/budget-dashboard`, `fix/login-error`, `docs/readme-update`.
- One branch = one focused change.

## Commits
- Make small, logical commits; each one should leave the code working.
- Use Conventional Commits format: `type: short summary` (under ~72 chars, imperative mood)
  - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
  - Example: `feat: add accessibility skill with WCAG 2.2 AA checklist`
- Add a body when the *why* isn't obvious.
- Before committing: review the diff (`git diff --staged`), run tests/linters, and check that no secrets, `.env` files, build output, or large files are included.
- Keep `.gitignore` up to date.

## Pull requests
- Push the branch and open a PR into `main`.
- PR title follows the commit format. PR description includes:
  - **What** changed and **why**
  - **How it was tested**
  - Screenshots for UI changes
  - Known limitations or follow-ups
- Keep PRs small enough to review in one sitting.
- Merge only after checks pass and the user approves. Delete the branch after merging.

## Safety
- Ask the user before pushing, merging, force-pushing, rebasing shared branches, or deleting branches.
- Never use `git push --force` on `main` or shared branches. Never run `git reset --hard` or discard changes without confirming.
- If there are merge conflicts, explain them and resolve carefully. Don't just accept one side blindly.

## Never
- Commit secrets, credentials, or `.env` files
- Commit directly to `main`
- Use vague messages like "update", "fix stuff", "changes"
- Rewrite published history without explicit permission

## Before you say you're done
- [ ] Work is on a feature branch, not `main`
- [ ] Diff reviewed; no secrets or junk files
- [ ] Tests and checks pass
- [ ] Commit messages follow the format
- [ ] PR has a clear description and testing notes
- [ ] Told the user what was pushed and what's left to do (merge, review)
