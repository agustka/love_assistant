# Atomic Design Composition Skill

## Purpose

Defines how to compose UI using the atomic design system when building pages, drawers, and dialogs. Covers the composition hierarchy, the Definition pattern for configuring organisms and templates, which templates to use, and how the static analysis enforces correctness.

This skill is used **together with** the `ui-components-catalog` skill, which provides the full inventory of available components.

---

## Composition Hierarchy

| Layer    | May compose                            | May NOT compose                       |
|----------|----------------------------------------|---------------------------------------|
| Atom     | Other atoms only                       | Molecules, organisms, templates, pages |
| Molecule | Atoms, other molecules                 | Organisms, templates, pages           |
| Organism | Atoms, molecules, other organisms      | Templates, pages                      |
| Template | Organisms, structural wrappers         | Pages                                 |
| Page     | Templates, organisms, BLoC orchestration | Raw atoms, raw molecules              |

### Key rules

- **Pages** compose templates and organisms. They must use **at least 1 template** and **no more than 3**.
- **Pages** must never use atoms or molecules directly — these must be wrapped in organisms or templates.
- **Templates** compose organisms and provide layout structure (scaffold, app bar, scroll views, padding).
- **Organisms** compose atoms and molecules to form self-contained, reusable UI sections.
- **Molecules** compose atoms to form small functional UI units.
- **Atoms** are indivisible primitives (text, icon, divider).

---

## The Definition Pattern

Organisms and templates are configured via **Definition classes** — immutable data objects that describe *what* to render without referencing widgets directly.

### How it works

1. A `Definition` class holds the data and configuration for an organism.
2. The page creates `Definition` instances using cubit state and passes them to the template or organism.
3. The organism reads the `Definition` and renders the appropriate atoms/molecules.

### Example: configuring an info table

```dart
// Page creates Definition from cubit state
InfoTableDefinition(
  title: S.of(context).generic_info,
  items: [
    InfoTableCellDefinition(
      title: S.of(context).account_number,
      value: TableCellValueDefinition.text(state.accountNumber),
      loading: state.isLoading,
    ),
    InfoTableCellDefinition(
      title: S.of(context).balance,
      value: TableCellValueDefinition.text(state.balance.toAmountString()),
      loading: state.isLoading,
    ),
  ],
)
```

### Example: configuring a bottom panel

```dart
BottomPanelDefinition.singleButton(
  key: SomeKeys.confirmButtonKey,
  text: S.of(context).generic_confirm,
  onTap: context.read<SomeCubit>().confirm,
  loading: state.isSubmitting,
)
```

### Example: configuring action buttons

```dart
List<ButtonGridItemDefinition> actionItems = [
  ButtonGridItemDefinition(
    key: SomeKeys.transferKey,
    text: S.of(context).make_transfer,
    icon: Assets.icons.transfer.provider(),
    onTap: () => context.read<SomeCubit>().navigateToTransfer(),
  ),
];
```

### Common Definition classes

| Definition class                    | Used by                          | Purpose                                    |
|-------------------------------------|----------------------------------|--------------------------------------------|
| `FeatureHeadingTitleDefinition`     | Most templates                   | Page title                                 |
| `FeatureHeadingSubtitleDefinition`  | Most templates                   | Page subtitle                              |
| `BottomPanelDefinition`            | Templates with footer buttons     | Bottom action panel with buttons           |
| `BottomButtonsDefinition`          | `BottomPanelDefinition`          | Button list for bottom panel               |
| `BottomButtonDefinition`           | `BottomButtonsDefinition`        | Single button in bottom panel              |
| `BottomSupportingContentDefinition`| `BottomPanelDefinition`          | Supporting content above buttons           |
| `InfoTableDefinition`              | `IsbInfoTableOrganism`           | Table of key-value information rows        |
| `InfoTableCellDefinition`          | `InfoTableDefinition`            | Single row in an info table                |
| `TableCellValueDefinition`         | `InfoTableCellDefinition`        | Cell value (text, badge, custom)           |
| `ButtonGridItemDefinition`         | `IsbButtonGridOrganism`          | Single action button in a grid             |
| `SelectableListDefinition`         | `IsbBottomDrawerSelectableListOrganism` | List with selectable items         |
| `SelectableListItemDefinition`     | `SelectableListDefinition`       | Single selectable item                     |
| `ParagraphAmountData`              | `IsbDefaultPageTemplate`         | Amount display with sub-text               |
| `NotificationBoxDefinition`        | Various templates/organisms       | Notification/info box                      |
| `ProcessingContentDefinition`      | `IsbProcessingTemplate`          | Processing state content                   |
| `ProcessingMessageDefinition`      | `ProcessingContentDefinition`    | Processing message text                    |

### Rules for Definition usage

- Pages create `Definition` instances from cubit state — they never construct organisms directly with raw data.
- All strings in definitions come from `S.of(context).*` — never hardcoded.
- Keys for testability are set on definitions, not on organisms directly.
- Definitions support `loading` flags — use them to show skeleton states.

---

## Approved Templates

All new pages **must** use one of the approved templates. Legacy pages that do not use approved templates exist but must not be used as reference.

### `IsbDefaultPageTemplate<T>`

The general-purpose page layout. Use for most new pages.

**Slots / parameters:**
- `children: List<Widget>` — organisms to display in the body.
- `title: FeatureHeadingTitleDefinition?` — page title.
- `subtitle: FeatureHeadingSubtitleDefinition?` — page subtitle.
- `paragraphAmount: ParagraphAmountData?` — amount display below title.
- `bottomPanel: BottomPanelDefinition?` — bottom action buttons.
- `onMessage: void Function(T message)?` — event bus listener for cubit messages.
- `onClose: void Function()?` — custom back button behavior.
- `onCancel: void Function()?` — cancel action in app bar.
- `cancelText: String?` — text for cancel button.
- `onRefresh: Future<void> Function()?` — pull-to-refresh handler.
- `onResumed: void Function()?` — lifecycle resumed callback.
- `appBarType: AppBarType` — app bar style (default: `AppBarType.background`).
- `showBack: bool` — show back button (default: `true`).
- `contentPadding: bool` — add horizontal padding (default: `true`).
- `wrapBodyInScrollView: bool` — scrollable body (default: `true`).

**Usage:**
```dart
IsbDefaultPageTemplate<SomeMessage>(
  title: FeatureHeadingTitleDefinition(title: S.of(context).page_title),
  subtitle: FeatureHeadingSubtitleDefinition(subtitle: state.subtitle),
  onMessage: (SomeMessage message) => _handleMessage(context, message),
  bottomPanel: BottomPanelDefinition.singleButton(
    text: S.of(context).generic_confirm,
    onTap: context.read<SomeCubit>().confirm,
  ),
  children: [
    SomeFormOrganism(...),
    IsbInfoTableOrganism(...),
  ],
)
```

### `IsbProductDetailsTemplate<T>`

For product detail screens (accounts, cards, loans).

**Slots / parameters:**
- `title: FeatureHeadingTitleDefinition?` — product name.
- `subtitle: FeatureHeadingSubtitleDefinition?` — product identifier.
- `actionItemsDefinition: List<ButtonGridItemDefinition>` — action button grid.
- `infoTablesDefinitions: List<InfoTableDefinition>` — info tables.
- `notification: NotificationBoxDefinition?` — optional notification box.
- `onMessage: void Function(T message)?` — event bus listener.
- `onPullToRefresh: Future<void> Function()?` — pull-to-refresh.
- `onResumed: void Function()?` — lifecycle resumed callback.
- `loading: bool` — loading state.

### `IsbContentMessageTemplate<T>`

For informational/error/empty-state screens with an illustration.

**Slots / parameters:**
- `asset: ImageAssetInfo` — illustration image.
- `title: String` — heading text.
- `message: String` — body text.
- `bottomPanel: BottomPanelDefinition` — action buttons.
- `onEventBusMessage: void Function(T event)?` — event bus listener.
- `showBack: bool` — show back button.
- `backgroundType: ThemeBackgroundType` — background style.

### `IsbSuccessReceiptTemplate<T>`

For success/confirmation screens with a receipt card.

**Slots / parameters:**
- `title: String` — success heading.
- `subtitle: String` — success subheading.
- `receiptCard: IsbReceiptInfoCardOrganism` — receipt card organism.
- `bottomPanel: BottomPanelDefinition` — action buttons.
- `onEventBusMessage: void Function(T event)?` — event bus listener.
- `onClose: void Function()?` — custom close behavior.
- `backgroundType: ThemeBackgroundType` — background style.

### `IsbFullscreenBusyTemplate<T>`

For full-screen loading states.

**Slots / parameters:**
- `onMessage: void Function(T event)?` — event bus listener.

### `IsbProcessingTemplate`

For processing/waiting states (e.g., authentication, transaction processing).

**Slots / parameters:**
- `title: String` — processing title.
- `explanation: String` — processing explanation.
- `hasError: bool` — error state.
- Content definitions for messages and notification boxes.

### `IsbBottomDrawerTemplate<T>`

For bottom drawer sheets.

**Slots / parameters:**
- `children: List<Widget>` — organisms to display.
- `title: FeatureHeadingTitleDefinition?` — drawer title.
- `subtitle: FeatureHeadingSubtitleDefinition?` — drawer subtitle.
- `bottomPanel: BottomPanelDefinition?` — action buttons.
- `onDismissDrawer: void Function()?` — dismiss handler.
- `dismissDrawerText: String?` — dismiss button text.
- `onMessage: void Function(T message)?` — event bus listener.
- `contentPadding: bool` — add horizontal padding (default: `true`).

### Other available templates

| Template                            | Use case                              |
|-------------------------------------|---------------------------------------|
| `IsbConfirmationTemplate`           | Confirmation/summary screens          |
| `IsbPinEntryTemplate`              | PIN input screens                     |
| `IsbWebViewTemplate`              | Embedded web views                    |
| `IsbPdfViewerTemplate`            | PDF document viewing                  |
| `IsbPicturePreviewTemplate`       | Image preview screens                 |
| `IsbImageAndFormTemplate`         | Image upload with form                |
| `IsbIntroductionTemplate`         | Feature onboarding/intro screens      |
| `IsbAlertDialogTemplate`          | Alert dialog layout                   |
| `IsbProgressDialogTemplate`       | Progress dialog layout                |

---

## Composing a Page

### Step 1: Choose the right template

Match the page's purpose to a template:

| Page purpose                  | Template                          |
|-------------------------------|-----------------------------------|
| General form/content page     | `IsbDefaultPageTemplate`          |
| Product details (account/card)| `IsbProductDetailsTemplate`       |
| Informational/error/empty     | `IsbContentMessageTemplate`      |
| Success/receipt confirmation  | `IsbSuccessReceiptTemplate`      |
| Full-screen loading           | `IsbFullscreenBusyTemplate`      |
| Processing/waiting            | `IsbProcessingTemplate`          |
| Bottom drawer                 | `IsbBottomDrawerTemplate`        |

### Step 2: Identify required organisms

Look at what the page needs to display:
- Information tables → `IsbInfoTableOrganism`
- Action button grid → `IsbButtonGridOrganism`
- Form inputs → `IsbAccountFormOrganism`, `IsbAmountFormOrganism`, `IsbTextInputFormOrganism`, etc.
- Selectable lists → `IsbBottomDrawerSelectableListOrganism`
- Receipt cards → `IsbReceiptInfoCardOrganism`
- Navigation links → `IsbNavigationLinksOrganism`
- Options lists → `IsbOptionsOrganism`
- Section headings → `IsbSectionHeadingOrganism`

### Step 3: Configure via Definitions

Create `Definition` objects from cubit state and pass them to template/organism parameters.

### Step 4: Wire up BLoC

- Wrap the template in `BlocProvider` + `BlocBuilder` (or `BlocConsumer` if side effects are needed).
- Pass cubit actions to Definition callbacks (e.g., `onTap: context.read<SomeCubit>().doSomething`).
- Use the template's `onMessage` parameter for event bus messages from the cubit.

---

## Event Bus Message Handling

Templates support a generic type `<T>` for event bus messages. This is how cubits send one-shot events (navigation, toasts, dialogs) to pages:

```dart
// In the page
IsbDefaultPageTemplate<SomeMessage>(
  onMessage: (SomeMessage message) {
    switch (message) {
      case SomeMessage.error:
        AlertDialogPage.show(
          type: AlertDialogType.error,
          title: S.of(context).oops,
          content: S.of(context).error_message,
          originator: NamedRoute.somePage(),
        );
      case SomeMessage.success:
        getIt<Navigation>().navigate(routeLink: RouteLink.someSuccessPage());
    }
  },
  children: [...],
)
```

---

## Side Widgets

When a page's build method becomes too large, extract sections into **private side widgets** using `part of`:

```dart
// In the main page file
part 'widgets/some_page_info_section.dart';

// Usage in build()
_SomePageInfoSection(state: state)
```

```dart
// widgets/some_page_info_section.dart
part of "some_page.dart";

class _SomePageInfoSection extends StatelessWidget {
  final SomeState state;
  const _SomePageInfoSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return IsbInfoTableOrganism(
      title: S.of(context).info_section_title,
      items: [
        // ... InfoTableCellDefinitions from state
      ],
    );
  }
}
```

Side widgets:
- Must be **private** (prefixed with `_`).
- Must be connected via `part of`.
- Follow the same composition rules as the page — they can only use organisms and templates, **not** atoms or molecules.
- Are purely organizational — they extract sections of the page build tree when the file gets large.
- Are useful for extracting info table builders, action button builders, or conditional UI sections.

---

## Multi-State Pages

Pages often need to render different templates based on state:

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (BuildContext context) => getIt<SomeCubit>()..getData(),
    child: BlocBuilder<SomeCubit, SomeState>(
      builder: (BuildContext context, SomeState state) {
        // Loading state
        if (state.status == Status.loading) {
          return IsbFullscreenBusyTemplate<SomeMessage>(
            onMessage: (SomeMessage msg) => _handleMessage(context, msg),
          );
        }

        // Success state
        return IsbDefaultPageTemplate<SomeMessage>(
          onMessage: (SomeMessage msg) => _handleMessage(context, msg),
          children: [
            // organisms configured from state
          ],
        );
      },
    ),
  );
}
```

This is allowed — the template count rule counts templates **instantiated at runtime**, and switching between templates based on state is a valid pattern.

---

## What is NOT Allowed in Composition

These will be caught by the `AtomicDesignRule` static analysis and will **fail CI**:

1. **Using atoms/molecules directly in pages:**
   ```dart
   // ❌ WRONG — atom in page
   IsbTextAtom(text: "Hello")

   // ❌ WRONG — molecule in page
   IsbParagraphMolecule(data: ParagraphData(...))
   ```

2. **Using raw Flutter widgets in pages:**
   ```dart
   // ❌ WRONG — raw Flutter widgets
   Column(children: [...])
   Container(padding: ...)
   SizedBox(height: 16)
   Padding(padding: EdgeInsets.all(8), child: ...)
   Text("Hello")
   Image.asset(...)
   ```

3. **Using EdgeInsets in pages:**
   ```dart
   // ❌ WRONG — EdgeInsets in page
   Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: ...)
   ```

4. **Hardcoded sizes:**
   ```dart
   // ❌ WRONG — hardcoded size
   SizedBox(height: 32)
   ```

All of these must be encapsulated within organisms or templates.

---

## Composition Checklist

Before completing a page/drawer/dialog:

1. ☐ Uses an approved template as the root widget
2. ☐ Body children are organisms only (no atoms, molecules, or raw Flutter widgets)
3. ☐ All data flows through Definition objects
4. ☐ All strings come from `S.of(context).*`
5. ☐ Loading/error states are handled (via template `loading` flags or `IsbFullscreenBusyTemplate`)
6. ☐ Event bus messages are wired up for one-shot events (navigation, toasts, dialogs)
7. ☐ Side widgets are private and connected via `part of`
8. ☐ Keys are defined in the `_keys.dart` part file
9. ☐ No `EdgeInsets`, no hardcoded sizes, no raw widgets at page level
