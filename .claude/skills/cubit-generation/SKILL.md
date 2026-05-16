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

- BDD scenarios describing user flows (specs/bdd.md)
- domain.handoff.md listing available use cases, entities, value objects

---

## File Location

```
lib/application/<feature>/<cubit_name>/
├── <cubit_name>_cubit.dart
├── <cubit_name>_state.dart      ← part file
└── <cubit_name>_messages.dart   ← part file (optional, for sealed message classes)
```

State and messages are `part` files of the cubit file.

---

## Canonical Template

```dart
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:isbapp/application/core/analytics/analytics_helper.dart';
import 'package:isbapp/application/core/cubit/isb_cubit.dart';
import 'package:isbapp/domain/core/value_objects/failures/failure.dart';
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/infrastructure/core/service/event_bus.dart';
import 'package:isbapp/setup.dart';

part '<cubit_name>_state.dart';
part '<cubit_name>_messages.dart'; // optional

@injectable
class <CubitName>Cubit extends IsbCubit<<CubitName>State> with AnalyticsHelper {
  final GetSomethingUseCase _getSomething;

  <CubitName>Cubit(
    this._getSomething,
  ) : super(<CubitName>State.initial());

  Future<void> getData() async {
    final Payload<SomeEntity> payload = await _getSomething();
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
| Base class | Extend `IsbCubit<State>` (preferred) or `Cubit<State>` from `flutter_bloc` |
| Mixin | `with AnalyticsHelper` — for `log(Event)` and `err(...)` methods |
| Constructor | Accept domain use cases and application services via constructor injection |
| Initial state | Call `super(<CubitName>State.initial())` in the constructor |
| `part` directives | State file is always a `part`; messages file is a `part` when messages use sealed classes |

### Dependency Injection

See the **dependency-injection** skill for the full DI contract. Key rules for cubits:

- Dependencies are **domain use cases** (e.g. `GetAccountsUseCase`, `SubmitTransferUseCase`) and **application services** (e.g. `ScopedEventBus`, `IPollAndDebounce`)
- Inject all dependencies via constructor parameters — **never** call `getIt<T>()` to obtain use cases or services
- `getIt<EventBus>()` is the only acceptable direct `getIt` call for firing global one-shot events inside method bodies
- `getIt<Navigation>()` is the only acceptable direct `getIt` call for imperative navigation inside method bodies
- `ScopedEventBus` **must** be injected via constructor (each cubit owns its instance)
- **Do not inject repository interfaces directly** — use domain use cases to access repositories

### State Management

- Emit new states via `emit(state.copyWith(...))` — never mutate state directly
- Use a status enum for page lifecycle: `loading`, `loaded`, `error`, plus feature-specific statuses (e.g. `accepting`, `rejecting`)
- Private fields on the cubit are acceptable for tracking internal status that feeds into computed state (see emit-override pattern below)

### Emit Override Pattern

When a cubit tracks multiple async data sources, override `emit` to compute the aggregate status:

```dart
@override
void emit(<State> state) {
  // Derive composite status from private tracking fields
  Status status = state.status;
  if (_sourceAStatus == _SourceAStatus.error) {
    status = Status.error;
  } else if (_sourceAStatus == _SourceAStatus.loading) {
    status = Status.loading;
  }
  super.emit(state.copyWith(status: status));
}
```

### Method Naming

| Method type | Convention | Example |
|---|---|---|
| Data loading | `getData`, `pullToRefresh` | `Future<void> getData({required bool forceGet})` |
| User actions | `on<Action>Tap`, `on<Action>Changed` | `onPayNowTap()`, `onAmountChanged(String)` |
| Internal handlers | `_receive<DataType>` | `_receiveAccounts(StreamPayload<AccountsV2>)` |
| Lifecycle | `init`, `onResumed` | `void init({required String? param})` |

### Error Handling

- Use `payload.fold(onFailure, onSuccess)` for `Payload<T>`
- Use `streamPayload.resolve(onFailure:, onData:, onDataRefresh:, onDataCleared:)` for `StreamPayload<T>`
- Log errors with `err(failure, location: "<CubitName>Cubit.<method>")` or `log(Event.error(...))`
- Fire error messages via EventBus for the UI to show snackbars/toasts

### Stream Subscriptions

When subscribing to streams (e.g. account updates):

```dart
StreamSubscription<StreamPayload<Data>>? _subscription;

<CubitName>Cubit(...) : super(State.initial()) {
  _subscription ??= _subscribeToDataUseCase().listen(_receiveData);
}

@override
Future<void> close() {
  _subscription?.cancel();
  return super.close();
}
```

### Navigation

- Use `getIt<Navigation>().pop()`, `.navigate(routeLink:)`, `.navigateAndPopTo(routeLink:, popTo:)`
- Use `RouteLink` factories for route construction

### Analytics

- Log user actions: `log(<Feature>Event.<eventFactory>())`
- Log errors: `log(<Feature>Event.<errorFactory>(failure: failure))`
- Use named factory constructors on event classes

### Comment Discipline

- Canonical template comments in this skill are illustrative only.
- Do not emit section headers, scaffold comments, or method/property/function doc comments (`///`) in generated cubit/state/message files.
- Use comments only for rare non-obvious rationale.

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Business logic in cubit | Belongs in domain layer (use cases, entities) |
| Direct infrastructure calls (HTTP, cache) | Use domain use cases |
| Injecting repository interfaces directly | Repositories are consumed by use cases, not cubits |
| UI code (widgets, BuildContext) | Cubits must not import Flutter widgets |
| Mutable state fields exposed to UI | Always use immutable state + `copyWith` |
| Calling `getIt<>()` for use cases | Inject via constructor — see dependency-injection skill |
| Validating input on every keystroke by default | See `application-input-handling` skill |
| Skipping `@injectable` | Breaks DI registration |
| Forgetting `close()` override when using subscriptions | Causes memory leaks |
| Adding verbose section/doc comments in generated files | Creates noise and violates project comment discipline |

---

## Output

For each cubit, produce:

- `<cubit_name>_cubit.dart` — cubit class
- `<cubit_name>_state.dart` — state class (as `part` file)
- `<cubit_name>_messages.dart` — messages (as `part` file, when needed)

After creating cubits, verify compilation with:

```bash
dart analyze lib/application/<feature>/
```
