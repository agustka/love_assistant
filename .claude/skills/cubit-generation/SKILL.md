---
name: cubit-generation
description: >-
  Generate application-layer cubits from BDD scenarios and domain layer outputs.
  Produces cubits that orchestrate domain use cases, manage UI-facing state,
  and communicate one-shot events via the EventBus.
tools: []
---

## Purpose

Use this skill to generate Dart cubit classes for the application layer. Cubits translate user interactions into domain operations and expose state for the presentation layer.

Cubits live exclusively in the application layer. They orchestrate domain use cases, manage loading/success/error transitions, and fire one-shot messages via the EventBus.

---

## Input

- BDD scenarios describing user flows
- Available domain use cases, entities, value objects

---

## File Location

```
lib/application/<feature>/<cubit_name>_cubit.dart
lib/application/<feature>/<cubit_name>_state.dart      ← part file
```

State is a `part` file of the cubit file. See `WizardCubit` / `wizard_state.dart` for the established pattern in this codebase.

---

## Canonical Template

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';

part '<cubit_name>_state.dart';

@injectable
class <CubitName>Cubit extends BaseCubit<<CubitName>State> {
  final GetSomethingUseCase _getSomething;

  <CubitName>Cubit(this._getSomething) : super(<CubitName>State.initial());

  Future<void> getData() async {
    final Payload<SomeEntity> payload = await _getSomething.execute();
    payload.fold(
      (Failure failure) {
        err(failure, location: "<CubitName>Cubit.getData");
        emit(state.copyWith(status: <CubitName>Status.error));
      },
      (SomeEntity data) {
        emit(state.copyWith(status: <CubitName>Status.loaded, data: data));
      },
    );
  }
}
```

---

## Rules

### Class Structure

| Rule | Detail |
|------|--------|
| Annotation | `@injectable` — always, for DI registration via `get_it` + `injectable` |
| Base class | Extend `BaseCubit<State>` from `lib/application/core/base_cubit.dart` (it gates `emit` against `isClosed`) |
| Constructor | Accept domain use cases and application services via constructor injection |
| Initial state | Call `super(<CubitName>State.initial())` in the constructor |
| `part` directive | State file is always a `part`; messages/events may live in the state file or alongside it |

### Logging

- `err(...)` is a top-level function in `lib/infrastructure/core/error_handling/error_handler.dart`. Import it and call directly: `err(failure, location: "<CubitName>.<method>");`
- For analytics events, mix in `AnalyticsHelper` (`lib/application/core/analytics/analytics_helper.dart`) and call `log(Event)`. `AnalyticsHelper` only exposes `log` — it does not expose `err`.

### Dependency Injection

See the **dependency-injection** skill for the full DI contract. Key rules for cubits:

- Dependencies are **domain use cases** and **application services** — inject all via constructor parameters
- **Do not inject repository interfaces directly** — use domain use cases to access repositories
- Direct `getIt<T>()` calls are only acceptable inside method bodies for two cross-cutting singletons:
  - `getIt<EventBus>()` — firing one-shot events (see `WizardCubit` for the established pattern)
  - `getIt<IPollAndDebounce>()` — debounced calls
- Imperative navigation is done directly through `App.navigatorKey.currentState?.pushReplacementNamed(PageName.x.route)` — there is no `Navigation` wrapper class in this project

### State Management

- Emit new states via `emit(state.copyWith(...))` — never mutate state directly
- Use a status enum for page lifecycle: `loading`, `loaded`, `error`, plus feature-specific statuses (e.g. `submitting`)
- Private fields on the cubit are acceptable for tracking internal status that feeds into computed state

### Method Naming

| Method type | Convention | Example |
|---|---|---|
| Initialization | `init`, `getData` | `Future<void> init()` |
| User actions | `on<Action>Tap`, `on<Action>Changed` | `onNameChanged(String)` |
| Internal handlers | `_receive<DataType>` | `_receiveData(StreamPayload<X>)` |

- Use `receive` for payload and stream data handlers because the cubit receives data from a use case or subscription.
- Reserve the `on` prefix for user actions and UI callbacks, for example `onTap`, `onLongPress`, and `onProfileCtaActionTap`.

### Error Handling

- Use `payload.fold(onFailure, onSuccess)` for `Payload<T>`
- Use `streamPayload.resolve(...)` for `StreamPayload<T>`
- Log errors with `err(failure, location: "<CubitName>.<method>")`
- Fire error messages via EventBus for the UI to react (toasts, dialogs)

### Reading a Payload's Value

- Never read `payload.value` — it is the raw **nullable** accessor and reintroduces the `null` the payload exists to eliminate.
- Use `fold(onFailure, onSuccess)` when failure and success take different branches.
- Use `getOr(default)` when both failure and absence collapse to the same handling. The default must be non-null — typically the entity's `const Entity.invalid()` — so downstream code branches on `result.valid`, never on `result == null`.
- Payload type arguments are non-nullable (`Payload<Entity>`, not `Payload<Entity?>`), so absence already arrives as an `.invalid()`/`.empty()` instance — see **use-case-generation** and **repository-pattern**.

```dart
// Both failure and "no profile" route to the wizard → getOr with an invalid fallback
final Payload<UserPartnerProfile> payload = await _getLocalProfile.execute();
final UserPartnerProfile profile = payload.getOr(const UserPartnerProfile.invalid());
final bool signedIn = profile.valid && await _hasActiveSession();
```

### Stream Subscriptions

When subscribing to streams:

```dart
StreamSubscription<StreamPayload<Data>>? _subscription;

<CubitName>Cubit(this._watchData) : super(State.initial()) {
  _subscription ??= _watchData.subscribe().listen(_receiveData);
}

@override
Future<void> close() {
  _subscription?.cancel();
  return super.close();
}
```

### Firing Events

Use the singleton `EventBus` directly inside method bodies:

```dart
getIt<EventBus>().fire(WizardEvent.missingName);
getIt<EventBus>().fire(WizardEventGoToPage(page: nextStepIndex));
```

See `WizardCubit` (lib/application/wizard/wizard_cubit.dart) for the established pattern.

### Comment Discipline

- Canonical template comments in this skill are illustrative only.
- Do not emit section headers, scaffold comments, or doc comments (`///`) in generated cubit/state files.
- Use comments only for rare non-obvious rationale.

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Business logic in cubit | Belongs in domain layer (use cases, entities) |
| Direct HTTP/Supabase calls in the cubit | Use a repository → use case chain |
| Injecting repository interfaces directly | Repositories are consumed by use cases, not cubits |
| UI code (widgets, BuildContext) | Cubits must not import Flutter widgets |
| Mutable state fields exposed to UI | Always use immutable state + `copyWith` |
| Calling `getIt<>()` for use cases | Inject via constructor |
| Reading `payload.value` (the nullable accessor) | Use `fold` / `getOr(Entity.invalid())` — value arrives non-null |
| Skipping `@injectable` | Breaks DI registration |
| Forgetting `close()` override when using subscriptions | Causes memory leaks |
| Adding doc comments or section banners | Creates noise and violates project comment discipline |

---

## Output

For each cubit, produce:

- `<cubit_name>_cubit.dart` — cubit class
- `<cubit_name>_state.dart` — state class as a `part` file

After creating cubits, verify compilation with:

```bash
dart analyze lib/application/<feature>/
```

And regenerate DI:

```bash
dart run build_runner build --delete-conflicting-outputs
```
