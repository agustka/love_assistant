# Skill: dependency-injection

## Purpose

Define how dependencies are wired across the infrastructure and application layers.

The project uses `get_it` + `injectable` for compile-time DI registration. All dependencies are injected via constructor parameters — the container resolves the graph automatically from annotations.

Direct `getIt<T>()` calls at call-site are **forbidden** except for the two cross-cutting singletons listed below.

---

## Core Rule

> **Inject via constructor. Never call `getIt<T>()` inside business logic.**

| Layer | Annotation | Resolved by |
|-------|-----------|-------------|
| Infrastructure service | `@LazySingleton(as: IService)` | get_it container |
| Infrastructure repository | `@LazySingleton(as: IRepository)` | get_it container |
| Domain use case | `@injectable` | get_it container |
| Application cubit | `@injectable` | get_it container |

All dependencies (repositories, services, use cases, application helpers) must be declared as constructor parameters — never obtained via `getIt<T>()` inside method bodies, field initializers, or constructors.

---

## Allowed `getIt<T>()` Call-Sites

There are exactly **two** cross-cutting singletons that may be accessed via `getIt<T>()` directly, without constructor injection:

| Type | Usage |
|------|-------|
| `getIt<Navigation>()` | Imperative navigation from cubits |
| `getIt<EventBus>()` | Firing global, cross-feature one-shot events |

These are singletons with app-wide scope. Injecting them via constructor would add noise without benefit.

> **`ScopedEventBus`** is the exception to `EventBus`: it **must** be injected via constructor because each cubit gets its own instance and disposes it in `close()`.

---

## Infrastructure Layer

### Services

```dart
@LazySingleton(as: IFeatureService)
class FeatureService with BaseService implements IFeatureService {
  final FeatureChopperService _chopperService;

  const FeatureService(this._chopperService);
}
```

- Chopper service is resolved by the container and passed via constructor.
- Never call `getIt<FeatureChopperService>()` inside the service body.

### Repositories

```dart
@LazySingleton(as: IFeatureRepository)
class FeatureRepository implements IFeatureRepository {
  final IFeatureService _service;

  FeatureRepository(this._service);
}
```

- The service dependency is resolved by the container and passed via constructor.
- `CacheSupport` classes are **not** injected — they are instantiated as private final fields:

```dart
final FeatureCacheSupport _cache = FeatureCacheSupport();
```

Cache support classes are lightweight, have no external dependencies, and carry no state that needs to be shared or mocked. Instantiating them inline is the established pattern.

---

## Application Layer

### Use Cases

```dart
@injectable
class GetFeatureUseCase implements IUseCaseWith<({String id, bool forceGet}), FeatureEntity> {
  final IFeatureRepository _repository;

  const GetFeatureUseCase(this._repository);
}
```

### Cubits

```dart
@injectable
class FeatureCubit extends IsbCubit<FeatureState> with AnalyticsHelper {
  final GetFeatureUseCase _getFeature;

  FeatureCubit(this._getFeature) : super(FeatureState.initial());
}
```

- Use cases are resolved and passed by the container.
- `getIt<Navigation>()` and `getIt<EventBus>()` may be called inside method bodies, not constructor parameters.

---

## Presentation Layer (UI)

Cubits are **not** constructor-injected in the UI. They are obtained via `getIt<T>()` inside `BlocProvider.create`:

```dart
BlocProvider(
  create: (BuildContext context) => getIt<FeatureCubit>()..getData(),
  child: BlocBuilder<FeatureCubit, FeatureState>(...),
)
```

This is the **only** place in the UI where `getIt<T>()` should appear for cubits.

---

## DI Registration

All annotations are processed by `injectable`'s code generator. After adding/changing annotations **or adding/changing constructor dependencies in any DI-managed class** (`@injectable`, `@LazySingleton`, `@singleton`, including cubits/use cases/services/repositories), run:

```bash
python3 scripts/build.py getit
```

This regenerates `lib/setup.config.dart`. Do not edit that file manually.

---

## Lifecycle Annotations

| Annotation | When to use |
|-----------|-------------|
| `@LazySingleton(as: IType)` | Infrastructure services and repositories — one instance per session, created on first use |
| `@singleton` | App-wide singletons that must exist at startup (rare — prefer `@LazySingleton`) |
| `@injectable` | Use cases and cubits — fresh instance on each resolution |
| `@factoryParam` | Cubits that require a runtime parameter (e.g. an entity passed from a previous screen) |

---

## Rules

| Rule | Detail |
|------|--------|
| Constructor injection | All dependencies declared as constructor parameters |
| No `getIt<T>()` in business logic | Forbidden in cubits, use cases, services, repositories |
| `getIt<Navigation>()` allowed | Call inside cubit methods for imperative navigation |
| `getIt<EventBus>()` allowed | Call inside cubit methods to fire global events |
| `ScopedEventBus` via constructor | Must be injected — each cubit owns its instance |
| `CacheSupport` inline | Instantiated as `final _cache = FeatureCacheSupport()` — not injected |
| `@LazySingleton` for infrastructure | Services and repositories are singletons |
| `@injectable` for cubits and use cases | Fresh instance per resolution |
| Run `getit` build after DI signature changes | `python3 scripts/build.py getit` after annotation changes or constructor dependency changes in DI-managed classes |
| Bind implementation to interface | Always use `as: IType` to register against the abstract interface |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| `FeatureCubit(GetFeatureUseCase? uc) : _uc = uc ?? const GetFeatureUseCase(...)` | Optional fallback DI bypasses container wiring and hides required dependencies |
| `getIt<SomeUseCase>()` inside a cubit method | Breaks the DI contract — inject via constructor |
| `final _uc = getIt<SomeUseCase>()` in a cubit field/lazy getter | Same — use case/service dependencies must come from required constructor params |
| `getIt<IRepository>()` inside a use case | Same — constructor injection only |
| Injecting `CacheSupport` via constructor | They have no external dependencies; inline instantiation is the pattern |
| Calling `getIt<ScopedEventBus>()` | Scoped buses must be constructor-injected so each cubit has its own |
| Editing `setup.config.dart` manually | This file is generated — run `python3 scripts/build.py getit` |
| Omitting `@injectable` / `@LazySingleton` | The class will not be registered and resolution will fail at runtime |
| Using `@singleton` as default | Prefer `@LazySingleton` — only use `@singleton` when startup-time creation is required |

