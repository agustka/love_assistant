**Location**: `lib/presentation/`

# Presentation Layer & Atomic Design Guidelines

Unified reference for implementing UI in the Presentation Layer following Clean Architecture + Atomic Design.

## Scope of the Presentation Layer
The Presentation Layer is strictly responsible for turning data from Application / Domain layers into user interface, handling user interaction at UI level, and reflecting state emitted by Cubits/Blocs.

### Responsibilities (Allowed)
- Flutter widgets (atoms → pages)
- Atomic composition & layout
- Light UI-only state (animation controllers, focus, scroll)
- Input validation & formatting (UI feedback only: masks/formatters, allowed chars, length/pattern checks; business validation lives in Application/Domain)
- Theme, styling, spacing, typography, colors, responsive rules
- Accessibility and semantics
- Subscribing to cubit/bloc state via `BlocBuilder`
- Localized string usage (from prepared localization system)
- Declarative animations and transitions

### Explicit Non-Responsibilities (Forbidden Here)
- Business rules / domain logic
- Repository, service, API, HTTP, DB access
- Persistence, caching, file I/O (outside pure asset loading handled by Flutter framework)
- Complex orchestration logic or data transformation pipelines
- Instantiating Cubits/Blocs manually (use DI / Providers higher up)
- Security, authentication decisions
- Feature toggling logic (already resolved before reaching UI)

## Atomic Design Levels (Flutter Adaptation)
Allowed import direction: Pages can import Templates and Organisms (which can be composed directly on pages). Templates can import Organisms, which can import Molecules, which can import Atoms. Lower levels never import higher levels. Only Templates and Organisms are allowed on a page.

### Global Design System (ISB)
The shared, reusable UI components for the whole app live under `lib/presentation/core/isb/`:
- Atoms: `lib/presentation/core/isb/atoms/`
- Molecules: `lib/presentation/core/isb/molecules/`
- Organisms: `lib/presentation/core/isb/organisms/`
- Templates: `lib/presentation/core/isb/templates/`
- Utilities: `lib/presentation/core/isb/utils/`

Use these ISB components for common patterns across features. Feature-specific widgets should be placed under `lib/presentation/<feature>/widgets`.

Lower atomic levels must not import higher levels, and feature widgets should not modify ISB components directly.

### 1. Atoms
Smallest visual / interactive primitives.
- Pure UI, single responsibility
- Stateless (prefer) or trivial local state (e.g. hover)
- Theme-consistent (no hardcoded colors/fonts; use design tokens)
- No direct bloc subscriptions

### 2. Molecules
Meaningful combinations of atoms delivering a focused function.
- May have minimal UI behavior state (e.g. text field focus) but no domain logic
- Accept data via constructor; never fetch
- Can expose callbacks (e.g. `onChanged`, `onTap`)

### 3. Organisms
Composable UI sections made of molecules & atoms.
- Arrange and coordinate child widgets visually
- Subscribe to Cubit/Bloc state (read-only) when necessary
- We intentionally restrict organisms to UI coordination only — no domain/business logic.
- Break down if responsibilities drift (keep cohesive)

### 4. Templates
Structural layouts defining placement constraints.
- Provide consistent page skeleton (regions)
- No feature-specific business content; use placeholders / slots
- Provide layout composition API (named constructors / slots / builders)
- Support portrait/landscape and responsive layouting

### 5. Pages
Concrete screen instances binding templates with real content and Cubit state.
- Subscribe to necessary Cubits/Blocs (injected above) for rendering
- Assemble organisms/molecules/atoms with actual data
- Contain only presentation logic (UI state switching, mapping already-sanitized DTO/view models)

## File & Naming Conventions
- Folder segmentation under `lib/presentation/` per feature:
  - `widgets/my_example_widget.dart`
  - `widgets/another_widget.dart`
- Global ISB design system lives in `lib/presentation/core/isb/` with clearly segmented folders (`atoms/`, `molecules/`, `organisms/`, `templates/`, `utils/`). Prefer ISB components for cross-feature reuse.
- Widget class names: `PascalCase` describing purpose (`LocationCard`, `AppHeaderBar`)
- File name aligns with primary public widget: `location_card.dart`
- One primary widget per file; related private helper widgets may live below it.
- Avoid widget-returning methods; extract as separate widget classes.

## Const & Stateless Priority
- Always mark constructors `const` when possible.
- Favor `StatelessWidget`; use `StatefulWidget` only for ephemeral UI state (animation, controllers, focus). Never for business logic.

## State Subscription Rules
- Use `BlocBuilder`, `BlocListener` (for side-effects), or `BlocConsumer` (to combine both) at the organism or page level where necessary.
- Pages orchestrate which blocs are visible; organisms may subscribe if they are a cohesive UI section requiring direct state.
- Molecules & atoms should receive already-prepared data via constructor parameters.

## Styling & Theming
- Centralize: use theme extensions, color schemes, typography scale, spacing tokens.
- No arbitrary literals: extract numbers, durations, strings, keys into constants or design tokens.
- Semantic naming: `primaryBackground`, `dangerText`, `spacingXL`.
- Support dark/light modes and accessibility (contrast & scaling).

## Localization
- Use this app's localization system via `S` in `lib/presentation/core/localization/l10n.dart`—do not hardcode strings in widgets.
- Typical usage in widgets: `S.of(context).<key>`; for non-widget contexts where a `BuildContext` is unavailable, use `S.current.<key>`.
- Avoid formatting logic (pluralization, gender, date/number formatting) in presentation widgets; this should be resolved before reaching the UI component.
- Keep localization keys and usage centralized; prefer composition with ISB components that follow the same localization strategy.
- Dont create new keys in presentation layer; all keys must be defined in core localization files.

## Accessibility
- Provide `Semantics` where interactive/non-textual meaning needs clarity.
- Respect user text scaling: test with large accessibility fonts.
- Provide labels / `alt` text for icons & images.

## Error & Empty UI Handling
- Organisms & pages display visual states (loading spinners, retry buttons) based on prepared view state objects.
- No direct exception catching of business processes—errors arrive as part of view model/cubit state.

## Common Anti-Patterns - AVOID
- Building complex inline UI in page build method (extract organisms)
- Passing `BuildContext` deeply when not needed (prefer data-only parameters)
- Instantiating blocs/cubits inside widgets (use DI/injection layer)
- Hardcoded colors/strings/spacings
- Mixing layout and data transformation logic
