# Design principles (Flutter / BetterHalf)

Visual craft, interactive states, and accessibility, adapted from `impeccable` for this app. CSS removed; everything maps to Flutter widgets and the `LaTheme` / `LaPadding` / `LaSize` / `LaCornerRadius` tokens.

## Color

- **Use `LaTheme` roles, never raw colors.** `LaTheme.primary()`, `onPrimary()`, `surface()`, `onSurface()`, `background()`, `secondaryContainer()`, `error()`, `hintText()`, etc. They already resolve light/dark. A literal `Color(0x…)` or `Colors.black`/`Colors.white` in a widget is a finding.
- The palette is built around a warm primary (`#D85555`) and warm-tinted neutrals — fitting for a relationship product. Don't flatten neutrals to pure gray; the warmth is intentional cohesion.
- **The accent earns its power by being rare.** Reserve `primary()` for the one key action per screen (CTAs, the active state). If primary is everywhere, nothing reads as primary.
- Don't convey meaning by color alone (error red, success). Pair it with an icon, label, or shape — required for color-blind users and for `boldText`/high-contrast.
- Heavy use of alpha (`withOpacity`) is usually a missing token. Prefer a defined `LaTheme` surface/container role over translucent stacks, except for genuine overlays and pressed/focus states.

## Theme (light vs dark)

The app ships both via `LaTheme.brightness`. Dark is not inverted light:

- In dark mode, depth comes from lighter surfaces (`_darkSurface` → `secondaryContainer` → `tertiaryContainer`), not heavier shadows.
- Verify every screen in both modes. The golden suite already covers light/dark/accessibility/landscape — keep it green.

## Typography

- Hierarchy through **scale + weight contrast**, not many sizes one point apart. Pick few steps with clear jumps.
- Use `LaTheme.font` and the project text styles; route sizing through `Accessibility.getScaledFont` rather than fixed `fontSize`, so large-text users scale correctly.
- Cap measure for any long-form text so lines stay readable on a narrow phone; let `LaText` wrap rather than truncating meaning silently.
- Don't pair two similar typefaces; one family in multiple weights almost always wins.

## Layout & spacing

- **Every spacing value comes from `LaPadding`/`LaSize`** (`extraSmall 4 → small 8 → mediumSmall 12 → medium 16 → large 24 → extraLarge 32 → huge 40 → extraHuge 48`). Arbitrary literals are a finding.
- **Vary spacing for rhythm.** Tight gaps inside a group, generous gaps between groups. Uniform padding everywhere is monotony, not consistency.
- Group by proximity and dividers (`LaDivider`) before reaching for a `LaCard`. Cards only when content is genuinely distinct and tappable. Never nest cards.
- Prefer the existing layout atoms (`LaColumn`, `LaRow`, `LaSeparatedColumnMolecule`, `LaPadding` widgets, `LaSizedBox`) over re-implementing spacing inline.
- Respect device chrome with `LaSafeArea`; don't let content sit under the notch or home indicator.
- Build for portrait and landscape — templates already support both; confirm the screen reflows rather than overflowing.

## Motion

- Timing buckets: ~100–150ms instant feedback (taps, toggles), ~200–300ms state changes (sheet/menu), ~300–500ms layout changes (drawer, expand). Exit ≈ 75% of enter.
- Use decelerating curves (`Curves.easeOutCubic` / `easeOutQuart`-style). Avoid bounce/elastic — they read as amateur.
- **Respect reduced motion.** Check `MediaQuery.disableAnimationsOf(context)` (or `MediaQuery.of(context).disableAnimations`) and fall back to a crossfade or instant change. Keep functional motion (progress, loaders) but drop spatial movement.
- Animate transform/opacity/cross-fade (e.g. `LaAnimatedCrossFade`), not expensive per-frame layout. Don't animate everything; motion fatigue is real.

## States

Every interactive element and every data region needs its states designed, not just the happy default.

**Interactive element states** — design at least these for buttons, tiles, fields:

| State | Flutter treatment |
|---|---|
| Default | base styling from theme |
| Pressed | `LaTapVisual` / `LaGestureDetector` feedback; visible response < 100ms |
| Disabled | reduced emphasis, non-interactive, still legible |
| Loading | inline spinner (`LaCircularProgress` / `LaDotLoader`); disable to block double-submit |
| Error | inline message near the field, not a wiped form |
| Success | brief confirmation; don't over-celebrate |

There is no hover/focus-ring concept on touch; don't port web focus styling. Do keep targets ≥ 48dp.

**Data-region states** — for any list, fetch, or async area:

- **Loading**: prefer a skeleton/`LaLoadingBox` over a bare spinner; it previews the shape and feels faster. Drive it from cubit state.
- **Empty**: never blank. Say what will appear here, why it matters, and offer the action. (Wording → `betterhalf-voice`; structure → here. The project ships `LaFeatureHeadingMolecule`, illustrations via `LaTheme.illustrations`, and `LaAuthIllustrationMolecule` for this.) Distinguish first-use vs no-results vs user-cleared.
- **Error**: explain what happened and offer retry; don't dump exceptions. Errors arrive as view state from the cubit — the widget renders them, it never catches business exceptions.

## Accessibility resilience (mobile)

- Touch targets ≥ 48dp (Material) / 44dp (Cupertino). A visually small `LaIcon` button needs an expanded tap area.
- No overflow at `Accessibility.maxFontScale` (3.11). Use `Accessibility.of(context)` and `getScaledFont`; let containers grow with text instead of fixed heights.
- `LaSemantics` for interactive/non-text meaning; `LaExcludeSemantics` to hide decorative duplicates; label icon-only controls and images.
- Honor `screenReader` and `boldText` from `Accessibility`. Verify VoiceOver/TalkBack order is logical.
- Use the project's voiceover helpers (`Accessibility.convertDateTimeToVoiceOverSentence`, `convertStringToVoiceOverSentence`) for dates and digit strings rather than reading raw values.
