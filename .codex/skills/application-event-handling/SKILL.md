---
name: application-event-handling
description: >-
  Define and fire one-shot events (messages) from cubits to the presentation
  layer via the EventBus. Covers message class design and UI consumption.
tools: []
---

## Purpose

Use this skill to implement one-shot event communication from the application layer to the presentation layer. Events (called "messages") represent transient signals — error toasts, success banners, navigation triggers, UI commands — that must not live in the state because they are not part of the current UI snapshot.

---

## When to Use Events vs. State

| Signal type | Mechanism | Example |
|---|---|---|
| Persistent UI data | State field via `emit(state.copyWith(...))` | loading status, form values, entity data |
| One-shot notification | EventBus `.fire(...)` | error toast, success banner, navigation command |

**Rule of thumb:** if the UI should react once and not re-render the same message on rebuild, use the EventBus.

---

## EventBus

The project uses a single global `EventBus` from the `event_bus` package, registered as a singleton via `EventBusModule` (`lib/infrastructure/core/event/event_bus_module.dart`). Accessed via `getIt<EventBus>()`.

There is **no** scoped EventBus pattern in this project.

```dart
getIt<EventBus>().fire(WizardEvent.missingName);
```

---

## Message Definitions

### Enum Messages

For simple signals without payload, use an enum:

```dart
enum WizardEvent {
  missingName,
  missingPronoun,
  missingBirthday,
  confirmNoAnniversary,
}
```

Fired as:
```dart
getIt<EventBus>().fire(WizardEvent.missingName);
```

### Class Messages with Data

For messages that carry data, define a small `@immutable` class:

```dart
@immutable
class WizardEventGoToPage {
  final int page;
  const WizardEventGoToPage({required this.page});
}

@immutable
class WizardInitialSetupCompletedEvent {
  final UserPartnerProfile profile;
  const WizardInitialSetupCompletedEvent({required this.profile});
}
```

Fired as:
```dart
getIt<EventBus>().fire(WizardEventGoToPage(page: nextStepIndex));
getIt<EventBus>().fire(WizardInitialSetupCompletedEvent(profile: _buildPartnerProfile()));
```

See `lib/application/wizard/wizard_state.dart` for the established pattern in this project.

### File Location

| Message style | Location |
|---|---|
| Enum, cubit-specific | Inside `<cubit_name>_state.dart` (above the state class) |
| Class with data | Inside `<cubit_name>_state.dart` or alongside the cubit file |

---

## Firing Events from Cubits

```dart
getIt<EventBus>().fire(<FeatureName>Message.errorOccurred);
getIt<EventBus>().fire(SomeEventWithPayload(data: data));
```

---

## Consuming Events in the Presentation Layer

The project ships a listener widget at `lib/presentation/core/ui_components/la_event_bus_listener.dart`. Pages subscribe to events of a specific type and react in a callback:

```dart
LaEventBusListener<WizardEvent>(
  onMessage: (WizardEvent message) {
    switch (message) {
      case WizardEvent.missingName:
        // show error, scroll, etc.
        break;
      case WizardEvent.missingPronoun:
        // ...
        break;
      // ...
    }
  },
  child: ...,
)
```

The listener subscribes to the global `EventBus` stream, filters by type `<T>`, and invokes the `onMessage` callback. It cancels the subscription on dispose.

---

## Rules

| Rule | Detail |
|------|--------|
| Messages are immutable | Use `const` constructors |
| Messages carry minimal data | Only what the UI needs to react — not the full state |
| Enum for simple signals | No payload needed |
| Class with data for typed messages | When messages carry data |
| Never store messages in state | They are fire-and-forget; state is for persistent UI data |
| One message type per feature | Define an enum or a small set of classes per cubit |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Storing `lastError` in state to trigger toast | Toast would re-trigger on every rebuild |
| Using `BlocListener` for one-shot events | The project's convention is EventBus + `LaEventBusListener` |
| Firing events in the constructor | Listeners may not be registered yet |
| Using raw strings as event payloads | Use typed enums or `@immutable` classes |
