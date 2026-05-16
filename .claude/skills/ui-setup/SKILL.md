# UI Setup Skill

## Purpose

Defines how to create and register new pages, drawers, and dialogs in the presentation layer. Covers file structure, routing registration, atomic design enforcement, and all conventions that must be followed.

---

## UI Construct Types

There are three routable UI constructs:

| Type     | Class suffix | Animation                  | Transparent background |
|----------|-------------|----------------------------|------------------------|
| Page     | `*Page`     | `PageAnimation.adaptive`   | `false`                |
| Drawer   | `*Drawer`   | `PageAnimation.bottomDrawer`| `true`                 |
| Dialog   | `*Dialog`   | `PageAnimation.dialog` or `PageAnimation.popUpDialog` | `true` |

---

## File & Folder Structure

All UI constructs live under `lib/presentation/[feature]/[sub_feature]/`.

```
lib/presentation/
  [feature]/
    [sub_feature]/
      [sub_feature]_page.dart          ← main page file
      [sub_feature]_keys.dart          ← Key constants (part file)
      widgets/                         ← side widgets (part files)
        [sub_feature]_[widget_name].dart
```

### Naming conventions

- File names use `snake_case`.
- Class names use `PascalCase` with the suffix matching the construct type: `Page`, `Drawer`, or `Dialog`.
- Side widgets (helpers) are `part of` the main page file and must be **private** (prefixed with `_`).
- Keys are defined in a separate `part` file with suffix `_keys.dart`.

### Part file pattern

Main page file:
```dart
part 'sub_feature_keys.dart';
part 'widgets/sub_feature_some_widget.dart';
```

Part file:
```dart
part of "sub_feature_page.dart";
```

---

## Static Creator Pattern

Every page, drawer, and dialog **must** define a static `creator` method. This is the factory function used by the routing system.

```dart
class ExamplePage extends StatelessWidget {
  static Widget creator(RouteArguments args) {
    final ExamplePayload payload =
        args.getDynamic("payload") as ExamplePayload? ?? const ExamplePayload.invalid();

    return ExamplePage(
      payload: payload,
    );
  }

  final ExamplePayload payload;

  const ExamplePage({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

- The `creator` must be a `static Widget Function(RouteArguments args)`.
- Extract arguments using the typed getters on `RouteArguments`: `getString`, `getInt`, `getBool`, `getDynamic`, etc.
- Treat all route arguments as nullable and always provide typed fallbacks when extracting arguments.
- Prefer domain/value-object invalid factories for fallbacks (for example `const KnownForeignRecipientSummary.invalid()`).
- The `creator` must always return the target page/drawer/dialog widget.
- Never return placeholder widgets (`SizedBox.shrink()`, `Container()`, etc.) from `creator`.

Bad:

```dart
static Widget creator(RouteArguments args) {
  final KnownForeignRecipientSummary? recipient = args.getDynamic("recipient") as KnownForeignRecipientSummary?;
  if (recipient == null) {
    return const SizedBox.shrink();
  }
  return TransferForeignRecipientDetailsDrawer(recipient: recipient);
}
```

Good:

```dart
static Widget creator(RouteArguments args) {
  final KnownForeignRecipientSummary recipient =
      args.getDynamic("recipient") as KnownForeignRecipientSummary? ??
      const KnownForeignRecipientSummary.invalid();

  return TransferForeignRecipientDetailsDrawer(recipient: recipient);
}
```

---

## Route Registration

Every new UI construct requires registration in **four** places:

### 1. `PageName` enum — `lib/domain/core/navigation/named_route.dart`

Add a new entry to the `PageName` enum with a kebab-case route string:

```dart
enum PageName {
  // ...existing entries...
  exampleFeature("/example-feature"),
  // ...
}
```

### 2. `NamedRoute` factory — same file

Add a factory constructor on `NamedRoute`:

```dart
factory NamedRoute.exampleFeature() => const NamedRoute._(
  creator: ExampleFeaturePage.creator,
  name: PageName.exampleFeature,
  animation: PageAnimation.adaptive,  // or bottomDrawer, dialog, popUpDialog
);
```

Configuration options:
- `animation` — controls page transition (see table above).
- `hasTransparentBackground` — set to `true` for drawers and dialogs.
- `singleTop` — set to `true` to prevent duplicate instances on the route stack.
- `sensitive` — defaults to `true`; set to `false` for non-sensitive screens.

For **drawers**:
```dart
factory NamedRoute.exampleDrawer() => const NamedRoute._(
  creator: ExampleDrawer.creator,
  name: PageName.exampleDrawer,
  animation: PageAnimation.bottomDrawer,
  hasTransparentBackground: true,
);
```

For **dialogs**:
```dart
factory NamedRoute.exampleDialog() => const NamedRoute._(
  creator: ExampleDialog.creator,
  name: PageName.exampleDialog,
  animation: PageAnimation.dialog,
  hasTransparentBackground: true,
);
```

### 3. `RouteLink` factory — `lib/domain/core/navigation/route_link.dart`

Add a factory constructor on `RouteLink` that wraps the `NamedRoute` and passes arguments:

```dart
factory RouteLink.exampleFeature({required String someId}) {
  return RouteLink._(
    route: NamedRoute.exampleFeature(),
    arguments: RouteArguments({"someId": someId}),
  );
}
```

- If no arguments are needed, omit the `arguments` parameter.
- Argument keys in `RouteArguments` **must match exactly** what the `creator` method extracts.

### 4. Adobe subsection mapping — `lib/domain/core/adobe/entities/adobe_subsection.dart`

Add the new `PageName` entry to `AdobeSubSectionX.toAdobeSubsection()` and map it to the correct `SiteSubsection`.

```dart
extension AdobeSubSectionX on PageName {
  SiteSubsection toAdobeSubsection() {
    return switch (this) {
      // ...existing mappings...
      PageName.exampleFeature => SiteSubsection.transfers,
    };
  }
}
```

- This switch is exhaustive for `PageName`; missing a new page mapping can break builds.
- Do not leave new entries unmapped; choose the closest analytics subsection explicitly.

---

## Navigation

Navigation is performed through the `Navigation` cubit (obtained via `getIt<Navigation>()`):

```dart
getIt<Navigation>().navigate(routeLink: RouteLink.exampleFeature(someId: "123"));
getIt<Navigation>().pop();
getIt<Navigation>().pop(popTo: NamedRoute.someOtherPage());
```

Pages must **never** use `Navigator.push()` or `Navigator.pop()` directly.

For drawers, use the exact same route-driven pattern:

```dart
getIt<Navigation>().navigate(routeLink: RouteLink.exampleDrawer());
```

- Do **not** open new drawers with `showModalBottomSheet`.
- Do **not** add a static `show(...)` helper for drawers as the default pattern.
- A static `show(...)` helper is reserved for explicitly documented exceptional cases (must be required by `bdd.md` or an existing framework integration constraint).

---

## Atomic Design Enforcement

The project enforces strict atomic design rules via a static code analysis script (`scripts/static_code_analysis/rules/atomic_design_rule.py`). This runs in CI and blocks PRs that violate the rules.

### Hierarchy (bottom → top)

| Level     | Suffix         | Location                                   |
|-----------|---------------|--------------------------------------------|
| Atom      | `*Atom`       | `lib/presentation/core/isb/atoms/`         |
| Molecule  | `*Molecule`   | `lib/presentation/core/isb/molecules/`     |
| Organism  | `*Organism`   | `lib/presentation/core/isb/organisms/`     |
| Template  | `*Template`   | `lib/presentation/core/isb/templates/`     |
| Page      | `*Page`       | `lib/presentation/[feature]/`              |
| Drawer    | `*Drawer`     | `lib/presentation/[feature]/`              |
| Dialog    | `*Dialog`     | `lib/presentation/[feature]/`              |

### What the static analysis enforces

The `AtomicDesignRule` scans every `.dart` file under `lib/presentation/` (excluding `lib/presentation/core/`) and checks all widget constructor calls inside methods.

#### Pages and Drawers may ONLY use:

1. **Templates** — widgets ending in `Template`. Pages must contain **at least 1** and **no more than 3** templates.
2. **Organisms** — widgets ending in `Organism`.
3. **Gadgets** — widgets ending in `Gadget`.
4. **Other pages/drawers/dialogs** — widgets ending in `Page`, `Drawer`, `Dialog`.
5. **Boundary wrappers** — widgets ending in `Boundary`, `Guard`, `EventsListener`, `Coordinator`.
6. **Bloc orchestration widgets** — `BlocProvider`, `MultiBlocProvider`, `BlocBuilder`, `BlocConsumer`, `BlocListener`, `Builder`.
7. **Key types** — `Key`, `GlobalKey`, `ValueKey`, `ObjectKey`, `UniqueKey`, `List`.
8. **Localization accessor** — `S` (for `S.of(context).some_key`).
9. **Allowed non-widget types** — `PageController`, `File`, `Function`, `RegExp`, `Time`, `MediaQuery`, `Accessibility`, `Scrollable`, `Localizations`, `FocusScope`, `FocusNode`, `TextEditingController`.
10. **Definition classes** — any class ending in `Definition` or `Keys`.
11. **Registered design system components** — classes defined in `lib/presentation/core/isb/molecules/`, `lib/presentation/core/isb/organisms/`, `lib/presentation/core/isb/templates/`, `lib/application/`, and `lib/domain/`.
12. **Private side widgets** — locally-defined widgets that are private (`_WidgetName`) and connected via `part of`.

#### Pages and Drawers must NEVER use:

- **Atoms or Molecules directly** — widgets ending in `Atom`, `Atoms`, `Molecule`, `Molecules` trigger a hard failure. Wrap them in organisms or templates.
- **EdgeInsets** — `EdgeInsets.*` usage in pages is forbidden. Move padding into an organism or template.
- **Any raw Flutter widget** (e.g., `Container`, `Column`, `Row`, `Padding`, `SizedBox`, `Scaffold`) — these must be encapsulated within organisms or templates.
- **Hardcoded sizes** — caught by `HardcodedSizeCheckerRule`.

#### Suppressing the rule (escape hatch)

Add a comment on the line **above** the violation:

```dart
//ignore: atomic_design_rule
SomeDisallowedWidget(...)
```

Use this sparingly.

### Approved templates

All new pages and drawers **must** use one of the approved atomic design templates from `lib/presentation/core/isb/templates/approved_templates/`. These are the canonical page layouts:

- `IsbDefaultPageTemplate` — standard scrollable page layout
- `IsbProductDetailsTemplate` — product detail pages with info tables and action items
- `IsbFullscreenBusyTemplate` — full-screen loading state
- `IsbProcessingTemplate` — processing/waiting state
- `IsbContentMessageTemplate` — informational content pages
- `IsbSuccessReceiptTemplate` — success/receipt confirmation pages

Other templates (e.g., `IsbBottomDrawerTemplate`, `IsbConfirmationTemplate`, `IsbPinEntryTemplate`, `IsbWebViewTemplate`, etc.) are available for specific use cases.

When in doubt, prefer an approved template. If none fits the layout requirement, report it as a gap.

### Barrel exports

Design system components are exported via barrel files:

- `lib/presentation/core/isb/isb_atoms.dart`
- `lib/presentation/core/isb/isb_molecules.dart`
- `lib/presentation/core/isb/isb_organisms.dart`
- `lib/presentation/core/isb/isb_templates.dart`

Import these barrel files in pages — never import atoms/molecules/organisms/templates directly by path.

---

## Page Build Pattern

A typical page follows this structure:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isbapp/application/[feature]/[cubit].dart';
import 'package:isbapp/domain/core/navigation/route_arguments.dart';
import 'package:isbapp/presentation/core/isb/isb_organisms.dart';
import 'package:isbapp/presentation/core/isb/isb_templates.dart';
import 'package:isbapp/presentation/core/localization/l10n.dart';
import 'package:isbapp/setup.dart';

part '[feature]_keys.dart';
part 'widgets/[feature]_some_widget.dart';

class FeaturePage extends StatelessWidget {
  static Widget creator(RouteArguments args) {
    return FeaturePage(
      someId: args.getString("someId") ?? "",
    );
  }

  final String someId;

  const FeaturePage({
    super.key,
    required this.someId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<FeatureCubit>()..getData(someId: someId),
      child: BlocBuilder<FeatureCubit, FeatureState>(
        builder: (BuildContext context, FeatureState state) {
          return SomeTemplate(
            // pass state to template/organism props
          );
        },
      ),
    );
  }
}
```

### Key conventions:

- Cubits are obtained via `getIt<T>()` (dependency injection).
- Cubit methods are called in the `create` callback using cascade (`..getData()`).
- `BlocBuilder` wraps the template/organism tree.
- `BlocConsumer` is used when the page needs to react to state changes with side effects (e.g., navigation, toasts, dialogs).
- All user-facing strings come from `S.of(context).some_key` — never hardcoded.

---

## Keys Convention

Keys for testability are defined in a `part` file:

```dart
part of "feature_page.dart";

class FeatureKeys {
  static const Key someButtonKey = Key("FeaturePage_someButtonKey");
}
```

Key format: `"ClassName_descriptiveKeyName"`.

---

## Drawer Build Pattern

Drawers follow the same pattern but use `IsbBottomDrawerTemplate`:

```dart
class FeatureDrawer extends StatelessWidget {
  static Widget creator(RouteArguments args) {
    final KnownForeignRecipientSummary recipient =
        args.getDynamic("recipient") as KnownForeignRecipientSummary? ??
        const KnownForeignRecipientSummary.invalid();

    return FeatureDrawer(
      recipient: recipient,
    );
  }

  final KnownForeignRecipientSummary recipient;

  const FeatureDrawer({
    super.key,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<FeatureCubit>()..getData(),
      child: BlocBuilder<FeatureCubit, FeatureState>(
        builder: (BuildContext context, FeatureState state) {
          return IsbBottomDrawerTemplate(
            children: [
              // organisms only
            ],
          );
        },
      ),
    );
  }
}
```

---

## Dialogs

Dialogs are typically shown via `AlertDialogPage.show(...)`:

```dart
AlertDialogPage.show(
  type: AlertDialogType.error,       // error, info, warn
  title: S.of(context).some_title,
  content: S.of(context).some_message,
  originator: NamedRoute.featurePage(),
  onCloseAction: () => context.read<FeatureCubit>().exit(),
);
```

---

## Toasts

Toasts use `IsbToast.show(...)`:

```dart
IsbToast.show(
  context: context,
  text: S.of(context).some_message,
  type: ToastType.warning,  // or success, error, info
);
```

---

## Imports

- Use single quotes for all `import`, `export`, and `part` declarations.
- Use double quotes for all string literals in code.
- Import barrel files for design system components, not individual files.

## Comment Discipline

- Keep generated UI files self-documenting through naming and structure.
- Do not add method/property/function doc comments (`///`) in generated pages, drawers, dialogs, or side widgets.
- Do not add banner/section comments in generated code.
- Allow comments only for analyzer ignore directives or rare non-obvious rationale.

---

## Legacy Pages

Many existing pages in the project predate the atomic design system and do **not** follow these conventions. They may use raw Flutter widgets, direct atom/molecule usage, inline padding, and other patterns that are now prohibited.

- **Do not use legacy pages as reference** when building new UI. They are not representative of current standards.
- All **new** pages, drawers, and dialogs **must** use approved atomic design templates.
- Over time, all legacy pages will be migrated to atomic design. Legacy pages are tracked in the static analysis exclusion lists (`generated_legacy_widget_excludes.py` and `manual_legacy_widget_excludes.py`).
- If you encounter a legacy page during development, do not modify it to partially comply — full migration is a separate effort.

---

## Do NOT Create New Shared Atomic Components

Do not create new shared atoms, molecules, organisms, or templates in `lib/presentation/core/isb/`. Do not add entries to barrel files. Shared component creation follows the `atomic-design-planner` skill and is a separate effort.

When an existing organism doesn't satisfy the layout, create a **feature-specific private side widget** instead (see `ui-components-catalog` skill for the escalation path). Side widgets are purely organizational — they extract sections of the page's build tree into separate files when the page file gets large. Side widgets follow the same composition rules as pages: they must only use organisms and templates, never atoms or molecules.

---

## Checklist for Adding a New UI Construct

1. ☐ Create the page/drawer/dialog file under `lib/presentation/[feature]/[sub_feature]/`
2. ☐ Implement the `static Widget creator(RouteArguments args)` method
3. ☐ Add a `PageName` entry in `named_route.dart`
4. ☐ Add a `NamedRoute` factory in `named_route.dart`
5. ☐ Add a `RouteLink` factory in `route_link.dart`
6. ☐ Add the new `PageName` mapping in `AdobeSubSectionX.toAdobeSubsection()` in `lib/domain/core/adobe/entities/adobe_subsection.dart`
7. ☐ Import the page in `named_route.dart` (top-level imports)
8. ☐ Create `_keys.dart` part file for test keys
9. ☐ Use only templates + organisms + private side widgets in the build tree (no raw Flutter widgets at page level, no atoms/molecules at page level)
10. ☐ Ensure at least 1 template is used (max 3)
11. ☐ No `EdgeInsets`, no hardcoded sizes, no raw `Text`/`Image`/`SvgPicture` widgets at page level
12. ☐ Side widgets (if any) use design tokens and are private with `part of`
13. ☐ Strings via `S.of(context)` only
14. ☐ Cubits via `getIt<T>()` only
15. ☐ Drawers are opened via `getIt<Navigation>().navigate(routeLink: RouteLink.<drawerFactory>())`, not `showModalBottomSheet`
16. ☐ `creator` always returns the target page/drawer/dialog and uses typed nullable fallbacks (no placeholder widget returns)


