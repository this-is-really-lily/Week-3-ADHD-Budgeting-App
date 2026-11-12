---
name: accessibility
description: Use whenever creating, modifying, or reviewing user interface code (HTML, CSS, React/Vue/Svelte components, forms, modals, menus, navigation, images, colors, animations, or any interactive element) to ensure it meets WCAG 2.2 Level AA. Also use when the user mentions a11y, screen readers, keyboard navigation, or contrast.
---

# Accessibility (WCAG 2.2 AA)

Every UI you build must be usable by people who rely on keyboards, screen readers, magnification, voice control, or who have color vision, motor, or cognitive differences. Accessibility is a requirement, not a nice-to-have.

## Core rules

### Structure & semantics
- Use native HTML elements first (`<button>`, `<a>`, `<nav>`, `<main>`, `<label>`, `<table>`). Only add ARIA when no native element does the job. No ARIA is better than wrong ARIA.
- One `<h1>` per page; headings go in order (no skipping from h2 to h4).
- Set `<html lang="...">` and a unique, descriptive `<title>` for each page.
- Use landmarks (`header`, `nav`, `main`, `footer`) and provide a "Skip to main content" link.

### Keyboard & focus
- Everything clickable must work with the keyboard alone (Tab, Shift+Tab, Enter, Space, Esc, arrow keys where expected).
- Never remove focus outlines without a visible replacement. Focus must be clearly visible and not hidden behind sticky headers or overlays.
- Modals: move focus in on open, trap focus inside, close on Esc, return focus to the trigger on close.
- Tab order must follow visual reading order. Avoid positive `tabindex`.

### Text alternatives
- Meaningful images need `alt` text describing their purpose; decorative images use `alt=""`.
- Icon-only buttons need an accessible name (`aria-label` or visually hidden text).
- Video needs captions; audio needs transcripts.

### Color & visuals
- Text contrast at least 4.5:1 (3:1 for large text ≥ 24px, or ≥ 18.66px bold).
- UI components and focus indicators at least 3:1 against their background.
- Never use color alone to convey meaning (add text, icons, or patterns).
- Content must work at 200% zoom and reflow at 320px width without horizontal scrolling.
- Respect `prefers-reduced-motion`; nothing flashes more than 3 times per second.

### Forms
- Every input has a visible `<label>` programmatically tied to it. Placeholder text is not a label.
- Errors: identify the field, describe the problem in text, suggest a fix, and announce it to screen readers (e.g., `aria-describedby`, `aria-live`).
- Don't ask users to re-enter information they already gave in the same process.
- Don't require memory puzzles or transcription for login; allow paste and password managers.

### Pointer & touch
- Interactive targets at least 24×24 CSS pixels (44×44 recommended).
- Anything done by dragging must also have a single-click alternative.

### Dynamic content
- Announce important updates (toasts, loading results, errors) with `aria-live` regions.
- Custom widgets (tabs, accordions, comboboxes) follow the WAI-ARIA Authoring Practices patterns for roles, states, and keyboard behavior.

## Before you say you're done
- [ ] Walked through the feature with keyboard only
- [ ] All images, icons, and controls have accessible names
- [ ] Contrast checked for text, components, and focus states
- [ ] Headings and landmarks are logical
- [ ] Forms have labels and accessible error messages
- [ ] Works at 200% zoom and 320px width
- [ ] Reduced-motion respected
- [ ] If tooling is available, ran an automated check (e.g., axe-core, Lighthouse) and fixed the issues
- [ ] Told the user about any accessibility issues you could not fix

## Never
- Use `<div>` or `<span>` with click handlers instead of buttons/links
- Use `outline: none` without a replacement focus style
- Claim something is "accessible" without checking it against this list
