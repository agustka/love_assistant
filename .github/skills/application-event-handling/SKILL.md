---
name: application-event-handling
description: >-
  Define and fire one-shot events (messages) from cubits to the presentation
  layer via the EventBus. Covers both global EventBus and scoped EventBus
  patterns, message class design, and UI consumption.
tools: []
---

## Purpose

Use this skill to implement one-shot event communication from the application layer to the presentation layer. Events (called "messages") represent transient signals — error toasts, success banners, navigation triggers, or UI commands — that must not live in the state because they are not part of the current UI snapshot.

---

## When to Use Events vs. State

| Signal type | Mechanism | Example |
|---|---|---|
| Persistent UI data | State field via `emit(state.copyWith(...))` | loading status, form values, entity data |
| One-shot notification | EventBus `.fire(...)` | error toast, success banner, navigation command |
| Request from cubit to parent cubit | EventBus `.fire(...)` | `RegisterTransfer`, `StartAuthentication` |

**Rule of thumb:** if the UI should react once and not re-render the same message on rebuild, use the EventBus.

---

## EventBus Types

### Global EventBus (`EventBus`)

- Registered as `@singleton` in DI
- Accessed via `getIt<EventBus>()`
- Lives for the entire app session
- Use for **cross-feature** or **app-wide** messages

```dart
getIt<EventBus>().fire(SomeMessage.errorOccurred);
```

### Scoped EventBus (`ScopedEventBus`)

- Registered as `@injectable` in DI (new instance per injection)
- Injected via constructor into the cubit
- Disposed in the cubit's `close()` method
- Use for **feature-scoped** messages between a cubit and its own page/parent

```dart
// In cubit constructor
final ScopedEventBus eventBus;

// Fire
eventBus.fire(const ErrorRejectingPaymentRequest());

// Cleanup
@override
Future<void> close() {
  eventBus.dispose();
  return super.close();
}
```

### Which to Choose

| Scenario | EventBus type |
|---|---|
| Error/success toast on the same page | global `getIt<EventBus>()` or scoped, depending on feature isolation |
| Cubit communicating to a parent page (e.g. transfer flow) | Scoped — injected and disposed with the cubit |
| Cross-feature event (e.g. logout, authentication start) | Global `getIt<EventBus>()` |
| Simple enum messages (no payload) | Global — simpler wiring |
| Sealed class messages with data | Scoped or global, depends on scope |

---

## Message Definitions

### Enum Messages

For simple signals without payload, use an enum:

```dart
enum <FeatureName>Message {
  errorSendingLead,
  successSendingLead,
  missingContactInfo,
  invalidEmail,
  invalidPhone,
  scrollToTop,
}
```

Fired as:
```dart
getIt<EventBus>().fire(<FeatureName>Message.errorSendingLead);
```

### Sealed Class Messages

For messages that carry data or need type-safe matching, use a sealed class hierarchy in a `part` file:

```dart
part of '<cubit_name>_cubit.dart';

sealed class <CubitName>Message {
  const <CubitName>Message();
}

class ErrorRejectingRequest extends <CubitName>Message {
  const ErrorRejectingRequest();
}

class RegisterTransfer extends <CubitName>Message {
  final NewTransferInfo transferInfo;
  const RegisterTransfer({required this.transferInfo});
}

class SuccessAcceptingRequest extends <CubitName>Message {
  const SuccessAcceptingRequest();
}
```

### Standalone Message Classes

For cross-feature messages, define them in a separate file (not a `part` file):

```dart
// lib/application/<feature>/<feature>_message.dart
sealed class LoginMessage {
  const LoginMessage();
}

class StartAuthentication extends LoginMessage {
  final AuthorizationCredentials credentials;
  const StartAuthentication({required this.credentials});
}
```

### File Location

| Message style | Location |
|---|---|
| Sealed class, cubit-specific | `<cubit_name>_messages.dart` as `part` of the cubit |
| Enum, cubit-specific | Inside `<cubit_name>_state.dart` (above the state class) |
| Cross-feature sealed class | `<feature>_message.dart` as standalone file |

---

## Firing Events from Cubits

### Pattern: Global EventBus

```dart
getIt<EventBus>().fire(<FeatureName>Message.errorOccurred);
getIt<EventBus>().fire(StartAuthentication(credentials: credentials));
```

### Pattern: Scoped EventBus

```dart
eventBus.fire(const ErrorAcceptingPaymentRequest());
eventBus.fire(RegisterTransfer(transferInfo: transferInfo));
```

### Pattern: UI Intent

For generic UI commands shared across features, use the `UiIntent` enum:

```dart
getIt<EventBus>().fire(UiIntent.endEdit);
```

---

## Consuming Events in the Presentation Layer

Events are consumed via `IsbEventBusListenerMolecule`:

### Global EventBus

```dart
IsbEventBusListenerMolecule<SomeMessage>(
  onMessage: (SomeMessage message) {
    // show snackbar, navigate, etc.
  },
  child: ...,
)
```

### Scoped EventBus

```dart
IsbEventBusListenerMolecule<SomeMessage>.scoped(
  eventBus: context.read<SomeCubit>().eventBus,
  onMessage: (SomeMessage message) {
    // handle
  },
  child: ...,
)
```

---

## Rules

| Rule | Detail |
|------|--------|
| Messages are immutable | Use `const` constructors |
| Messages carry minimal data | Only what the UI needs to react — not the full state |
| Enum for simple signals | No payload needed |
| Sealed class for typed messages | When messages carry data or need exhaustive matching |
| Scoped EventBus requires `close()` | Always call `eventBus.dispose()` in the cubit's `close()` |
| Never store messages in state | They are fire-and-forget; state is for persistent UI data |
| One message type per cubit | All messages for a cubit share a sealed base or a single enum |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Storing "lastError" in state to trigger toast | Toast would re-trigger on every rebuild |
| Using `BlocListener` for one-shot events that are not state transitions | EventBus is the project convention for one-shot signals |
| Forgetting `eventBus.dispose()` | Leaks stream controllers |
| Firing events in the constructor | Listeners may not be registered yet |
| Using raw strings as event payloads | Use typed message classes or enums |

