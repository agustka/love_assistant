# Critique rubric

Scoring and persona lenses for a `mobile-design-review` pass. The heuristics and severity scales are taken verbatim from `impeccable` (they are platform-agnostic); the personas are trimmed to the ones that fire on a touch app and re-pointed at this product.

## Nielsen's 10 heuristics (score each 0–4)

Be honest. A 4 is genuinely excellent, not "good enough." Most real screens land 20–32.

| # | Heuristic | What to check on a screen |
|---|---|---|
| 1 | Visibility of system status | Loading/progress feedback, confirmation of save/submit/delete, inline validation, current location in a flow |
| 2 | Match system ↔ real world | Plain language (no jargon), familiar icons, natural order — defer wording specifics to `betterhalf-voice` |
| 3 | User control & freedom | Cancel/back/undo, easy exit from a multi-step wizard, clearing filters/selections |
| 4 | Consistency & standards | Same action → same result, shared `ui_components` reused, consistent tokens and platform conventions |
| 5 | Error prevention | Confirm destructive actions, constrain input (pickers/dropdowns over free text), smart defaults, draft preservation |
| 6 | Recognition over recall | Visible options not buried, labels on icon-only controls, no cross-screen memory demands |
| 7 | Flexibility & efficiency | Smart defaults, autofill, sensible shortcuts that don't complicate the basics |
| 8 | Aesthetic & minimalist | One primary element, hierarchy clear, no decorative clutter competing for attention |
| 9 | Error recovery | Plain-language errors near the source, actionable next step, user input preserved |
| 10 | Help & documentation | Contextual hints where a step is non-obvious; concise, in place |

**Scoring per heuristic:** 0 = absent, 1 = rare/major gaps, 2 = partial, 3 = good with minor gaps, 4 = excellent.

**Total /40 bands:** 36–40 Excellent (ship) · 28–35 Good (fix weak areas) · 20–27 Acceptable (real work needed) · 12–19 Poor (overhaul) · 0–11 Critical (redesign).

### Issue severity (tag every finding)

| Priority | Meaning | Action |
|---|---|---|
| **P0** Blocking | Prevents task completion | Fix immediately |
| **P1** Major | Significant difficulty / WCAG-AA-level a11y failure | Fix before release |
| **P2** Minor | Annoyance with a workaround | Next pass |
| **P3** Polish | No real user impact | If time permits |

If unsure between two levels, ask: "would a user contact support about this?" If yes, it's at least P1.

## Cognitive load

Cognitive load is the mental effort a screen demands. Eliminate the avoidable kind ruthlessly.

**Working memory (Miller / Cowan):** people hold ≤ 4 items at once. At any decision point, count the competing options/actions:
- ≤ 4 — fine.
- 5–7 — group or use progressive disclosure.
- 8+ — overloaded; users skip, misclick, or abandon.

Applied to mobile: ≤ 1 primary action + 1–2 secondary visible at a time; chunk forms into ≤ 4 fields before a break; reveal complexity only when needed (the wizard flow is the natural home for this). One decision per screen beats a wall of choices.

**Checklist** — count failures (0–1 good · 2–3 address soon · 4+ critical):

- [ ] Single focus: primary task uncluttered by competing elements
- [ ] Chunking: information in groups of ≤ 4
- [ ] Grouping: related items visually grouped (proximity, divider, container)
- [ ] Hierarchy: most important element is immediately obvious
- [ ] One decision at a time
- [ ] Minimal choices: ≤ 4 visible options at any decision point
- [ ] No cross-screen memory demand (don't make users remember step 1 to do step 3)
- [ ] Progressive disclosure: complexity revealed only when needed

## Personas (mobile)

Walk the screen's primary action as 2–3 of these. Report the specific element that breaks for each — not a generic description.

### Casey — distracted, one-handed, on the go
Thumb only, frequently interrupted, possibly on slow data.
**Red flags:** primary action stranded at the top out of thumb reach; state lost on backgrounding/return; free-text required where a picker would do; tap targets < 48dp or crowded together.

### Sam — accessibility-dependent
Screen reader (VoiceOver/TalkBack), large text, possibly low vision or motor impairment.
**Red flags:** unlabeled icon buttons or fields; meaning carried by color alone; overflow/clipping at large `Accessibility` scales; illogical screen-reader order; missing `Semantics`.

### Jordan — first-timer
New to the category, reads everything, abandons rather than guesses.
**Red flags:** icon-only navigation with no labels; jargon; no confirmation an action succeeded; ambiguous next step; no visible way back.

### Riley — stress tester
Pushes past the happy path with long strings, emoji, empty data, mid-flow backgrounding.
**Red flags:** empty/error states that show nothing useful; data lost on interruption; layout broken by a 100-character name or emoji; inconsistent behavior between similar controls.

### BetterHalf-specific lens
The audience leans male and spots fake polish instantly; the product is a "thoughtful friend + secretary," **not** an assistant or chatbot. **Red flags:** chat-style surfaces or "Ask me anything" affordances (structural violation — route to `betterhalf-voice` / the product-decision doctrine); patronizing tone; anything that reads as generic AI-product chrome.

### Selecting
- Wizard / form flow → Jordan, Sam, Casey
- Landing / first impression → Jordan, Riley, Casey
- Any data list or detail → Riley, Sam
