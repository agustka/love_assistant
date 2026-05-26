---
name: mobile-design-review
description: >-
  Review, critique, and improve the visual and UX quality of a Flutter screen,
  page, organism, or molecule in the BetterHalf (love_assistant) app. Use when
  asked to design, redesign, critique, audit, polish, or otherwise improve a
  screen's layout, visual hierarchy, spacing, typography, color, motion,
  interactive states, empty/error/loading states, accessibility, or
  design-system reuse. Mobile- and Atomic-Design-native. Defers user-facing
  wording to betterhalf-voice and layer/placement rules to architecture-validation.
user-invocable: true
---

# Mobile design review

Critique and improve the craft of a Flutter screen in this app. Adapted from the web-oriented `impeccable` skill — CSS, browser, and harness machinery removed; every principle rephrased for Flutter, Material/Cupertino, Atomic Design, and this project's design tokens.

## What this skill does and does not own

| Concern | Owner |
|---|---|
| Visual hierarchy, spacing, color, motion, states, a11y, design-system reuse | **this skill** |
| User-facing wording (labels, errors, empty-state copy, success/loading text) | `betterhalf-voice` |
| Layer boundaries, where a widget should live, DI/navigation | `architecture-validation` + `know-the-code` |
| Locking in the visual result against regression | `golden-test-generation` |

When a review finds a copy problem, name it and hand the wording to `betterhalf-voice`; do not rewrite strings here. When a fix would move logic across layers, defer to `architecture-validation`.

## Before reviewing

1. Read the target widget and the templates/organisms/molecules it composes. Pages must drive a template; templates take definitions/organisms/molecules, never atoms. If the target violates that, it is an architecture finding, not a design one — flag and route it.
2. Read the design tokens you will judge against: `LaPadding`, `LaSize`, `LaCornerRadius`, `LaElevation`, `LaTheme` (`lib/presentation/core/theme/la_theme.dart`) and the `Accessibility` helper (`lib/presentation/core/ui_components/accessibility.dart`).
3. Check whether a shared component in `lib/presentation/core/ui_components/` already solves the problem before proposing a new widget.

## The AI-slop test (mobile)

If someone could look at the screen and say "a generator made that," it failed. The match-and-refuse bans, translated to Flutter:

- **Hardcoded `Colors.black` / `Colors.white` / raw hex.** Every color comes from a `LaTheme.*` role. The palette is already tinted toward the warm primary (`#D85555`); don't undo that with pure neutrals.
- **Gradient text** (a `ShaderMask` gradient over a `Text`). Decorative, never meaningful. Use one solid `LaTheme` color; create emphasis with weight or size.
- **Glassmorphism by default** (`BackdropFilter` blur as decoration). Rare and purposeful, or none.
- **Side-stripe accents** (a thick colored `Border(left: …)` on a card/tile/banner). Rewrite with a full border, a `LaTheme` background tint, a leading icon, or nothing.
- **Identical card grids** — `LaCard` repeated with icon + heading + text, endlessly. A plain `LaColumn`/list with spacing and dividers usually reads better. **Never nest a card in a card.**
- **Modal/dialog as first thought.** Exhaust inline and progressive options first; when a surface is warranted, prefer the project's `LaBottomDrawerTemplate` over a blocking dialog.
- **Cards as the default container.** Most content does not need one. Spacing and alignment group things for free.

## Review procedure

Produce a critique, not a vibe. Work through these, then report.

### 1. Visual craft

Judge against [reference/design-principles.md](reference/design-principles.md): hierarchy (the squint test), spacing rhythm via `LaPadding`/`LaSize` (no literals, no uniform padding everywhere), typography scale and weight contrast, color strategy and `LaTheme` role use, and motion (Flutter `Duration`/`Curves`, reduced-motion).

### 2. States

Every interactive element and every data region needs its states designed — default, pressed, disabled, loading, error, empty, success. See [reference/design-principles.md](reference/design-principles.md) §States. Loading/empty/error are not afterthoughts; they are part of the screen. Confirm they exist and are driven by cubit state (the page maps state → view; widgets don't catch exceptions).

### 3. Cognitive load

Score against [reference/critique-rubric.md](reference/critique-rubric.md) §Cognitive load (Miller's ≤4 rule, progressive disclosure, one decision at a time). Flag any decision point with >4 competing options.

### 4. Accessibility

- Touch targets ≥ 48dp (Material) / 44dp (Cupertino).
- No overflow at `Accessibility.maxFontScale` (3.11). Test large text; use the `Accessibility.getScaledFont` path rather than fixed font sizes.
- `Semantics` / `LaSemantics` on interactive or non-text meaning; `LaExcludeSemantics` on decorative duplicates; meaningful labels on icon-only buttons and images.
- Meaning never carried by color alone (respects color-blind users and `boldText`).
- Verify in both light and dark `LaTheme` and with `screenReader` on.

### 5. Heuristic score and personas

Score Nielsen's 10 heuristics 0–4 and run the mobile personas from [reference/critique-rubric.md](reference/critique-rubric.md). Tag findings P0–P3.

## Reporting

Lead with the AI-slop verdict, then the heuristic table (`/40` with rating band), then 3–5 priority issues ordered by impact. For each: **what**, **why it matters to the user**, **the concrete fix** (name the widget, token, or `LaTheme` role), and the **owner skill** if the fix belongs elsewhere. Be direct and specific — "the primary button in `LaBottomButtonsMolecule`," not "some elements." End by offering to apply the fixes and to add/refresh a golden via `golden-test-generation` once the visuals settle.
