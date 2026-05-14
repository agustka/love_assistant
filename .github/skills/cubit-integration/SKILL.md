---
name: cubit-integration
description: >-
  Wire cubits into pages, drawers, and dialogs. Covers BlocProvider placement,
  BlocBuilder/BlocConsumer usage, accessing cubit methods, and DI via getIt.
tools: []
---

## Purpose

Defines how the UI layer connects to cubits. Pages provide cubits, build from their state, and forward user actions to cubit methods. The page never contains business logic — it delegates everything to the cubit.

---

## Providing Cubits

### Single cubit

```dart
BlocProvider(
  create: (BuildContext context) => getIt<FeatureCubit>()..getData(someId: someId),
  child: BlocBuilder<FeatureCubit, FeatureState>(
    builder: (BuildContext context, FeatureState state) {
      return SomeTemplate(...);
    },
  ),
)
```

### Multiple cubits

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<PrimaryCubit>(
      create: (BuildContext context) => getIt<PrimaryCubit>()..getData(),
    ),
    BlocProvider<SecondaryCubit>(
      create: (BuildContext context) => getIt<SecondaryCubit>(),
    ),
  ],
  child: BlocBuilder<PrimaryCubit, PrimaryState>(
    builder: (BuildContext context, PrimaryState state) {
      return SomeTemplate(...);
    },
  ),
)
```

### Rules

- Cubits are always obtained via `getIt<T>()` — never constructed directly.
- Initialization methods are called in the `create` callback using cascade (`..getData()`).
- `BlocProvider` is placed at the **page level only** — never inside organisms or templates.
- Multiple cubits use `MultiBlocProvider`, not nested `BlocProvider` widgets.

---

## Building from State

### `BlocBuilder` — for rendering state

Use when the page only needs to rebuild its UI from cubit state:

```dart
BlocBuilder<FeatureCubit, FeatureState>(
  builder: (BuildContext context, FeatureState state) {
    return SomeTemplate(
      loading: state.isLoading,
      title: FeatureHeadingTitleDefinition(title: state.title),
      children: [...],
    );
  },
)
```

### `BlocConsumer` — for rendering + side effects

Use when the page needs to react to state transitions with side effects (navigation, toasts) **in addition to** rebuilding the UI. This is the **legacy pattern** — prefer template `onMessage` with EventBus for new pages:

```dart
BlocConsumer<FeatureCubit, FeatureState>(
  listener: (BuildContext context, FeatureState state) {
    // Side effects on state transitions (legacy pattern)
  },
  builder: (BuildContext context, FeatureState state) {
    return SomeTemplate(...);
  },
)
```

### When to choose

| Requirement | Widget |
|-------------|--------|
| Render state only | `BlocBuilder` |
| Render state + one-shot events via EventBus | `BlocBuilder` + template `onMessage` (preferred) |
| Render state + react to state transitions | `BlocConsumer` (legacy — avoid for new pages) |

---

## Accessing Cubit Methods

### `context.read<T>()` — for calling actions

Use to get the cubit instance and call methods. Does **not** trigger rebuilds.

```dart
// In Definition callbacks
onTap: context.read<FeatureCubit>().confirm,
onTap: () => context.read<FeatureCubit>().selectItem(item),

// In event handlers
onCloseAction: context.read<FeatureCubit>().exit,

// Pull-to-refresh
onRefresh: context.read<FeatureCubit>().pullToRefresh,
```

### `context.watch<T>()` — avoid in pages

Rarely needed in pages. Use `BlocBuilder` instead for explicit rebuild scoping.

### Extracting cubit to a local variable

When a builder references the cubit frequently, extract it:

```dart
builder: (BuildContext context, FeatureState state) {
  final FeatureCubit cubit = context.read<FeatureCubit>();
  return SomeTemplate(
    onRefresh: cubit.pullToRefresh,
    onResumed: cubit.onPageResumed,
    children: [
      SomeOrganism(
        onTap: cubit.doSomething,
        onChanged: cubit.updateField,
      ),
    ],
  );
}
```

---

## Accessing Scoped EventBus

When the cubit uses a `ScopedEventBus`, the page accesses it through the cubit:

```dart
context.read<SomeCubit>().eventBus
```

This is passed to `IsbEventBusListenerMolecule.scoped()` when not using the template's `onMessage` parameter.

---

## StatefulWidget Pages

Use `StatefulWidget` only when the page needs to manage `FocusNode` or `TextEditingController` instances:

```dart
class SomePage extends StatefulWidget {
  // ...creator...

  @override
  State<StatefulWidget> createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<SomeCubit>()..init(),
      child: BlocBuilder<SomeCubit, SomeState>(...),
    );
  }
}
```

Prefer `StatelessWidget` when no focus/controller management is needed.

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Constructing cubits directly (`SomeCubit()`) | Always use `getIt<T>()` for dependency injection |
| Putting `BlocProvider` inside organisms/templates | Cubit provision is a page-level concern only |
| Calling repository/service methods from the page | The page delegates all logic to cubits |
| Storing UI state outside the cubit | All state lives in the cubit; no `setState()` for data |
| Using `context.watch` when `BlocBuilder` suffices | `BlocBuilder` makes rebuild scope explicit |
