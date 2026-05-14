---
name: ui-event-handling
description: >-
  Consume one-shot events (messages) from cubits in the presentation layer.
  Covers template onMessage callbacks, direct IsbEventBusListenerMolecule usage,
  global vs scoped event bus consumption, and the standard UI reactions: dialogs,
  toasts, and navigation.
tools: []
---

## Purpose

Use this skill to implement the **UI side** of one-shot event handling. Cubits fire messages via the EventBus (see `application-event-handling` skill); pages, drawers, and dialogs consume those messages and react with UI actions — showing dialogs, toasts, or triggering navigation.

The UI layer never fires events. It only listens and reacts.

---

## How Events Reach the UI

Messages flow from cubit → EventBus → `IsbEventBusListenerMolecule` → page callback.

```
Cubit ──fire()──▶ EventBus ──stream──▶ IsbEventBusListenerMolecule ──onMessage──▶ Page handler
```

The `IsbEventBusListenerMolecule` is a molecule that subscribes to the EventBus stream, filters by type `<T>`, and invokes the `onMessage` callback. It automatically cancels the subscription on dispose.

---

## Consuming Events via Template `onMessage`

The **preferred** approach. All approved templates accept an `onMessage` parameter with a generic type `<T>`:

```dart
IsbDefaultPageTemplate<SomeMessage>(
  onMessage: (SomeMessage message) => _onMessage(context, message),
  children: [...],
)
```

The template internally wraps its content in `IsbEventBusListenerMolecule<T>`, so you don't need to add one manually.

### Templates that support `onMessage`:

| Template | Parameter name |
|----------|---------------|
| `IsbDefaultPageTemplate<T>` | `onMessage` |
| `IsbProductDetailsTemplate<T>` | `onMessage` |
| `IsbBottomDrawerTemplate<T>` | `onMessage` |
| `IsbContentMessageTemplate<T>` | `onEventBusMessage` |
| `IsbSuccessReceiptTemplate<T>` | `onEventBusMessage` |
| `IsbFullscreenBusyTemplate<T>` | `onMessage` |

### Example: full page with event handling

```dart
class ShowCardNumberPage extends StatelessWidget {
  // ...creator, fields, constructor...

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<ShowCardNumberCubit>()..getData(),
      child: BlocBuilder<ShowCardNumberCubit, ShowCardNumberState>(
        builder: (BuildContext context, ShowCardNumberState state) {
          return IsbDefaultPageTemplate<ShowCardNumberMessage>(
            onMessage: (ShowCardNumberMessage message) => _onMessage(context, message),
            children: [
              // organisms...
            ],
          );
        },
      ),
    );
  }

  void _onMessage(BuildContext context, ShowCardNumberMessage message) {
    switch (message) {
      case ShowCardNumberMessage.loadError:
        AlertDialogPage.show(
          type: AlertDialogType.error,
          title: S.of(context).oops,
          content: S.of(context).error_generic_description,
          onCloseAction: () {
            getIt<Navigation>().pop();
          },
        );
      case ShowCardNumberMessage.cardNumberCopied:
        IsbToast.show(
          context: context,
          text: S.of(context).card_copy_credit_card_number_notified,
          type: ToastType.success,
        );
    }
  }
}
```

---

## Consuming Events via Direct Listener

When you need to listen for events **outside** a template (rare — e.g., wrapping a non-template widget), use `IsbEventBusListenerMolecule` directly:

### Global EventBus

```dart
IsbEventBusListenerMolecule<SomeMessage>(
  onMessage: (SomeMessage message) {
    // handle message
  },
  child: SomeWidget(...),
)
```

### Scoped EventBus

```dart
IsbEventBusListenerMolecule<SomeMessage>.scoped(
  eventBus: context.read<SomeCubit>().eventBus,
  onMessage: (SomeMessage message) {
    // handle message
  },
  child: SomeWidget(...),
)
```

**Note:** In practice, templates already wrap their content with `IsbEventBusListenerMolecule`, so you almost never need the direct approach for new pages.

---

## UI Reactions

When a message is received, the page must react with one of a small set of standard UI actions. The page must **never** perform business logic in the handler.

### 1. Alert Dialog

Show a modal dialog for errors, warnings, or informational messages:

```dart
AlertDialogPage.show(
  type: AlertDialogType.error,        // error | warn | info | success
  title: S.of(context).oops,
  content: S.of(context).error_message,
  originator: NamedRoute.somePage(),   // prevents duplicate dialogs from same page
  logIdentifier: "feature_error_id",   // for pain logging
  popSelf: true,                       // pop the dialog on close (default: true)
  onCloseAction: () {                  // action on dialog close
    getIt<Navigation>().pop();
  },
);
```

#### With primary / secondary actions:

```dart
AlertDialogPage.show(
  type: AlertDialogType.warn,
  title: S.of(context).oops,
  content: S.of(context).warning_message,
  primaryActionText: S.of(context).generic_retry,
  secondaryActionText: S.of(context).generic_cancel,
  onPrimaryAction: () {
    getIt<Navigation>().pop();
    context.read<SomeCubit>().retry();
  },
  onSecondaryAction: () {
    getIt<Navigation>().pop();
  },
);
```

#### Key parameters:

| Parameter | Type | Purpose |
|-----------|------|---------|
| `type` | `AlertDialogType` | Dialog style — `error`, `warn`, `info`, `success` |
| `title` | `String` | Dialog title |
| `content` | `String` | Dialog body text |
| `originator` | `NamedRoute?` | Prevents duplicate dialogs from the same page |
| `logIdentifier` | `String?` | Identifier for pain logging |
| `popSelf` | `bool` | Whether closing the dialog pops it (default: `true`) |
| `showCloseIcon` | `bool` | Show X icon in dialog |
| `primaryActionText` | `String?` | Primary button text |
| `secondaryActionText` | `String?` | Secondary button text |
| `overrideIllustration` | `String?` | Custom illustration asset path |
| `onPrimaryAction` | `Function()?` | Primary button callback |
| `onSecondaryAction` | `Function()?` | Secondary button callback |
| `onCloseAction` | `Function()?` | Close/dismiss callback |

### 2. Toast

Show a temporary notification banner:

```dart
IsbToast.show(
  context: context,
  text: S.of(context).success_message,
  type: ToastType.success,    // success | warning | error | info
);
```

### 3. Navigation

Navigate to another page, pop, or pop-to:

```dart
// Navigate forward
getIt<Navigation>().navigate(routeLink: RouteLink.someSuccessPage());

// Pop current page
getIt<Navigation>().pop();

// Pop to a specific page in the stack
getIt<Navigation>().pop(popTo: NamedRoute.somePage());

// Pop and then navigate
getIt<Navigation>().pop();
getIt<Navigation>().navigate(routeLink: RouteLink.contactUs());
```

---

## Handler Pattern: `_onMessage`

The standard pattern is a private `_onMessage` method that uses exhaustive `switch` on the message type:

### Enum messages

```dart
void _onMessage(BuildContext context, FeatureMessage message) {
  switch (message) {
    case FeatureMessage.errorLoading:
      AlertDialogPage.show(
        type: AlertDialogType.error,
        title: S.of(context).oops,
        content: S.of(context).error_generic_description,
        originator: NamedRoute.featurePage(),
        onCloseAction: getIt<Navigation>().pop,
      );
    case FeatureMessage.successSaving:
      IsbToast.show(
        context: context,
        text: S.of(context).save_success,
        type: ToastType.success,
      );
    case FeatureMessage.navigateToDetails:
      getIt<Navigation>().navigate(routeLink: RouteLink.featureDetails());
  }
}
```

### Sealed class messages

```dart
void _onMessage(BuildContext context, FeatureMessage message) {
  switch (message) {
    case ErrorLoadingFeature():
      AlertDialogPage.show(
        type: AlertDialogType.error,
        title: S.of(context).oops,
        content: S.of(context).error_generic_description,
      );
    case NavigateToDetails(:final itemId):
      getIt<Navigation>().navigate(
        routeLink: RouteLink.featureDetails(itemId: itemId),
      );
    case SuccessRegistering(:final transferInfo):
      getIt<Navigation>().navigate(
        routeLink: RouteLink.transferSuccess(info: transferInfo),
      );
  }
}
```

---

## Multi-State Pages with Events

When a page switches between templates based on state (e.g., loading → content), **both templates must listen for events** if the cubit can fire messages during either state:

```dart
builder: (BuildContext context, SomeState state) {
  if (state.status == Status.loading) {
    return IsbFullscreenBusyTemplate<SomeMessage>(
      onMessage: (SomeMessage msg) => _onMessage(context, msg),
    );
  }
  return IsbDefaultPageTemplate<SomeMessage>(
    onMessage: (SomeMessage msg) => _onMessage(context, msg),
    children: [...],
  );
}
```

The `_onMessage` handler is shared — define it once on the page class and reference it from both templates.

---

## Rules

| Rule | Detail |
|------|--------|
| Pages only react — never fire events | The UI layer consumes messages. Only cubits fire events. |
| Use template `onMessage` parameter | Do not add `IsbEventBusListenerMolecule` manually when the template already provides it. |
| All UI text from `S.of(context).*` | Dialog titles, toast messages, button labels — all localized. |
| Exhaustive switch on message type | Every message variant must be handled. Dart's exhaustive checking enforces this for enums and sealed classes. |
| One `_onMessage` handler per page | Extract it as a private method on the page class. Do not inline in the template parameter. |
| Never perform business logic in handler | Only show dialogs, toasts, or navigate. If more logic is needed, call a cubit method. |
| Pop before navigate when replacing | If you need to replace the current page, pop first then navigate. |
| Use `originator` for dialogs | Set `originator: NamedRoute.thisPage()` to prevent duplicate dialogs from the same page. |
| Use `logIdentifier` for error dialogs | Enables pain logging for error tracking. Convention: `"featureName_errorDescription"`. |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Calling cubit business methods inside `_onMessage` | The handler is for UI reactions only. If you need to trigger retries, call a cubit method that itself decides the logic. |
| Using `BlocListener` for one-shot events | EventBus via template `onMessage` is the project convention. `BlocListener` is for state-transition side effects, not one-shot messages. |
| Nesting `IsbEventBusListenerMolecule` inside a template that already has `onMessage` | Double-listening causes the handler to fire twice. |
| Opening a drawer with `showModalBottomSheet` in response to a message | Drawers are routable screens in this codebase; navigate via `getIt<Navigation>().navigate(routeLink: RouteLink.someDrawer())`. |
| Adding a drawer static `show(...)` helper for regular flows | Static `show(...)` is an exceptional pattern only; default drawer behavior is route-based navigation with `NamedRoute` + `RouteLink`. |
| Hardcoding dialog/toast strings | All strings must come from `S.of(context).*`. |
| Ignoring message variants in switch | Dart will warn, but ensure every case is handled — even if it's a no-op comment explaining why. |
| Firing events from the UI layer | Pages never call `eventBus.fire(...)`. That's the cubit's job. |
| Showing toasts or dialogs directly in `BlocBuilder` | These are side effects and must only happen in the `onMessage` callback, not during build. |
