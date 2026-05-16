---
name: ui-components-catalog
description: >-
  Reference for discovering and using ISB design system components in pages.
  Covers how to find available organisms and templates, the padding responsibility
  model, barrel import conventions, and component discovery strategy.
tools: []
---

## Purpose

Provides guidance on discovering and using existing ISB design system components when building pages, drawers, and dialogs. The component catalog is large and evolving — this skill teaches **how to find** the right component rather than listing every one.

---

## The Padding Responsibility Model

Padding responsibilities are strictly divided by layer:

| Concern | Responsible layer | Example |
|---------|------------------|---------|
| Internal padding (inside a component) | The component itself (atom, molecule, organism) | Cell padding inside an info table row |
| External padding / spacing between children | The **template** | Horizontal page margins, vertical gaps between organisms |
| Page-level padding | **Forbidden** — pages must never define padding | No `EdgeInsets`, no `Padding` widget, no `SizedBox` spacers |

### Why this matters

- Templates like `IsbDefaultPageTemplate` apply `IsbPadding.spacing5` horizontal padding and `IsbPadding.spacing5` vertical spacing between children automatically.
- If a page adds its own padding, it **doubles up** with the template's padding, breaking the layout.
- The static analysis (`AtomicDesignRule`) blocks any `EdgeInsets` usage in page files.

### What pages must NOT do

```dart
// ❌ WRONG — page defining padding
Padding(padding: EdgeInsets.all(16), child: SomeOrganism(...))

// ❌ WRONG — page adding spacers
SizedBox(height: 24)

// ❌ WRONG — page using EdgeInsets
EdgeInsets.symmetric(horizontal: 16)
```

### What pages should do

```dart
// ✅ CORRECT — pass organisms as children; template handles spacing
IsbDefaultPageTemplate(
  children: [
    SomeFormOrganism(...),     // template adds spacing between these
    IsbInfoTableOrganism(...), // no manual padding needed
  ],
)
```

---

## What Pages Can Use

Pages compose **templates** and **organisms** only. They must never use atoms or molecules directly.

### Templates (required — at least 1, max 3 per page)

Import via: `import 'package:isbapp/presentation/core/isb/isb_templates.dart';`

Templates provide the page skeleton: scaffold, app bar, scroll behavior, content padding, bottom panel, and event bus listener. Every page must have a template as its outermost layout widget (inside the BlocBuilder).

### Organisms (page children)

Import via: `import 'package:isbapp/presentation/core/isb/isb_organisms.dart';`

Organisms are the building blocks that go inside template slots (typically the `children` parameter). They are self-contained, reusable UI sections.

---

## How to Discover Components

The design system is large. Rather than memorizing every component, use these strategies:

### 1. Read the barrel files

The barrel files are the authoritative catalog:

| File | Layer | What's inside |
|------|-------|---------------|
| `lib/presentation/core/isb/isb_templates.dart` | Templates | All available templates |
| `lib/presentation/core/isb/isb_organisms.dart` | Organisms | All available organisms |
| `lib/presentation/core/isb/isb_molecules.dart` | Molecules | All molecules (used by organisms, not pages) |
| `lib/presentation/core/isb/isb_atoms.dart` | Atoms | All atoms (used by molecules, not pages) |

### 2. Search by UI need

Match what you need to display to an organism category:

| UI need | Search in | Likely organisms |
|---------|-----------|-----------------|
| Key-value information display | `organisms/information/` | `IsbInfoTableOrganism`, `IsbMessageOrganism` |
| Action buttons | `organisms/grid/button_grid/` | `IsbButtonGridOrganism` |
| Form inputs | `organisms/forms/` | `IsbAccountFormOrganism`, `IsbAmountFormOrganism`, `IsbTextInputFormOrganism`, `IsbDateFormOrganism`, `IsbSelectionFormOrganism`, `IsbKennitalaFormOrganism`, `IsbSliderFormOrganism` |
| Compound forms | `organisms/forms/` | `IsbAccountAndKennitalaFormOrganism`, `IsbDateAndAmountFormOrganism`, `IsbFullAddressFormOrganism`, `IsbNameAndEmailFormOrganism`, `IsbForeignAccountOrganism` |
| Selectable lists (drawers) | `organisms/bottom_drawer/` | `IsbBottomDrawerSelectableListOrganism` |
| Navigation links | `organisms/tappable/` | `IsbNavigationLinksOrganism`, `IsbOptionsOrganism` |
| Switches / toggles | `organisms/tappable/switch/` | `IsbSwitchTableOrganism` |
| Cards | `organisms/card/` | `IsbVerticalCardOrganism`, `IsbHorizontalCardOrganism`, `IsbSliderCardOrganism` |
| Carousel | `organisms/carousel/` | `IsbCarouselOrganism`, `IsbIntroCarouselOrganism` |
| Receipt / success info | `organisms/information/` | `IsbReceiptInfoCardOrganism` |
| Section headings | `organisms/header/` | `IsbSectionHeadingOrganism` |
| Collapsible panels | `organisms/information/` | `IsbCollapsePanelOrganism` |
| Error states | `organisms/error/` | `IsbFeatureErrorOrganism` |
| Empty states | `organisms/dialogs/` | `IsbEmptyStateOrganism` |
| Tab bars | `organisms/tab_bar/` | `IsbTabBarButtonsOrganism`, `IsbTabBarViewOrganism` |
| Footer / bottom panel | `organisms/footer/` | `IsbBottomPanelOrganism`, `IsbBottomButtonsOrganism` |
| Lists | `organisms/lists/` | `IsbTileListOrganism`, `IsbSectionListOrganism`, `IsbExpansionPanelOrganism` |
| Transaction statements | `organisms/statement_transactions/` | `IsbStatementTransactionsListOrganism` and related |
| Progress info | `organisms/progress_info/` | `IsbProgressInfoOrganism` |
| Timeline | `organisms/timeline/` | `IsbTimelineOrganism` |
| Calendar | `organisms/time/calendar/` | `IsbCalendarOrganism` |
| PIN input | `organisms/pin_input/` | `IsbPinInputOrganism` |
| Maps | `organisms/` | `IsbMapOrganism` |

### 3. Browse golden files for visual reference

Every ISB component has golden test images showing how it looks across themes and accessibility modes. These are the **visual catalog** of the design system.

Golden files live under `test/presentation/core/isb/` and mirror the component structure. Each component folder has a `goldens/` directory containing `.png` snapshots — typically `light_mode.png`, `dark_mode.png`, and `accessibility_mode.png`.

**To browse visually**, open the golden images for a component category:

| Component area | Golden location |
|----------------|----------------|
| Organisms — info tables, messages | `test/presentation/core/isb/organisms/information/goldens/` |
| Organisms — forms | `test/presentation/core/isb/organisms/forms/primitives/goldens/` |
| Organisms — cards | `test/presentation/core/isb/organisms/cards/*/goldens/` |
| Organisms — buttons | `test/presentation/core/isb/organisms/buttons/*/goldens/` |
| Organisms — lists | `test/presentation/core/isb/organisms/lists/goldens/` |
| Organisms — error states | `test/presentation/core/isb/organisms/error/goldens/` |
| Organisms — dialogs | `test/presentation/core/isb/organisms/dialogs/goldens/` |
| Organisms — navigation / app bar | `test/presentation/core/isb/organisms/navigation/goldens/` |
| Organisms — carousel | `test/presentation/core/isb/organisms/carousel/goldens/` |
| Organisms — header | `test/presentation/core/isb/organisms/header/goldens/` |
| Organisms — timeline | `test/presentation/core/isb/organisms/timeline/goldens/` |
| Organisms — progress info | `test/presentation/core/isb/organisms/progress_info/goldens/` |
| Organisms — scaffold | `test/presentation/core/isb/organisms/scaffold/goldens/` |
| Organisms — profile card | `test/presentation/core/isb/organisms/profile_card/goldens/` |
| Molecules — buttons | `test/presentation/core/isb/molecules/tappable/button/goldens/` |
| Molecules — text fields | `test/presentation/core/isb/molecules/texts/goldens/` or `test/presentation/core/isb/texts/goldens/` |
| Molecules — feedback / tags | `test/presentation/core/isb/molecules/feedback/goldens/` |
| Molecules — notifications | `test/presentation/core/isb/molecules/info/notification_box/goldens/` |
| Atoms — icons | `test/presentation/core/isb/atoms/icons/goldens/` |
| Atoms — indicators | `test/presentation/core/isb/atoms/indicators/goldens/` |
| Atoms — loading | `test/presentation/core/isb/atoms/loading/goldens/` |

**Tip:** To find all golden directories, run:
```bash
find test/presentation/core/isb -name "goldens" -type d | sort
```

This gives you 79+ golden directories covering the full design system. Open the `.png` files to see exactly what each component renders.

### 4. Read the organism source

Once you identify a candidate organism (via barrel files or golden images), read its source file to understand:
- What **Definition** class it expects
- What parameters it accepts
- What states it supports (loading, error, empty)

### 5. Check existing pages for patterns

Search for pages that solve similar problems. Look at how they compose organisms inside templates.

---

## Organism Configuration via Definitions

Most organisms are configured through `Definition` classes rather than raw parameters. The page creates a Definition from cubit state and passes it to the organism:

```dart
// ✅ Organism configured via Definition
IsbInfoTableOrganism(
  title: S.of(context).section_title,
  items: [
    InfoTableCellDefinition(
      title: S.of(context).label,
      value: TableCellValueDefinition.text(state.someValue),
      loading: state.isLoading,
    ),
  ],
)
```

See the `atomic-design-composition` skill for the full Definition reference.

---

## Import Conventions

| What you need | Import |
|--------------|--------|
| Templates | `import 'package:isbapp/presentation/core/isb/isb_templates.dart';` |
| Organisms | `import 'package:isbapp/presentation/core/isb/isb_organisms.dart';` |
| Molecules (only inside organisms) | `import 'package:isbapp/presentation/core/isb/isb_molecules.dart';` |
| Atoms (only inside molecules) | `import 'package:isbapp/presentation/core/isb/isb_atoms.dart';` |
| Theme tokens | Exported from `isb_organisms.dart` and `isb_templates.dart` via `utils/theme/` |
| Accessibility | `import 'package:isbapp/presentation/core/isb/isb.dart';` |

**Always import barrel files** — never import individual component files by path.

---

## When a Component Doesn't Exist

If no existing organism satisfies the layout requirement, follow this escalation path:

### 1. Try to compose from existing organisms

Can the layout be achieved by combining multiple existing organisms inside a template's `children`? If yes, no new component is needed.

### 2. Create a feature-specific side widget

If a page file is getting large, extract sections into **private side widgets** in the page's `widgets/` folder. Side widgets are purely organizational — they are not new components. They:

- Are private (`_WidgetName`) and connected via `part of`
- Live in the page's directory, not in `lib/presentation/core/isb/`
- Must only use **organisms and templates** — the same composition rules as the page itself
- Must **not** use atoms or molecules directly (those belong inside organisms)
- Must not contain business logic
- Must be reported as **advisory gaps** in the handoff so they can be evaluated for promotion to shared organisms later

```dart
// widgets/some_page_info_section.dart
part of "some_page.dart";

class _InfoSection extends StatelessWidget {
  final SomeState state;

  const _InfoSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return IsbInfoTableOrganism(
      title: S.of(context).section_title,
      items: [
        InfoTableCellDefinition(
          title: S.of(context).label,
          value: TableCellValueDefinition.text(state.someValue),
          loading: state.isLoading,
        ),
      ],
    );
  }
}
```

### 3. Block only when truly impossible

If the layout requires a fundamentally new **template** (new scaffold structure, new page skeleton) or capabilities that cannot be composed from any existing primitives — report a **blocking gap** and mark status as `failed`.

**Do not block** for missing organisms — if the layout can be achieved by composing existing organisms inside template `children`, do that. If the page file gets large, extract sections into private side widgets.

### What must NEVER be created

- New shared components in `lib/presentation/core/isb/` (atoms, molecules, organisms, templates)
- New templates of any kind
- New barrel file entries
- Side widgets that use atoms or molecules directly (side widgets follow page-level composition rules)


