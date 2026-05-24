# Skill: dependency-injection

## Purpose

Define how dependencies are wired across the infrastructure and application layers.

The project uses `get_it` + `injectable` for compile-time DI registration. All dependencies are injected via constructor parameters — the container resolves the graph automatically from annotations.

Direct `getIt<T>()` calls at call-site are **forbidden** except for the cross-cutting singletons listed below.

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

There are exactly two cross-cutting singletons that may be accessed via `getIt<T>()` directly, without constructor injection:

| Type | Usage |
|------|-------|
| `getIt<EventBus>()` | Firing global one-shot events from cubit method bodies |
| `getIt<IPollAndDebounce>()` | Cross-cutting timer/debounce utility |

These are singletons with app-wide scope. Injecting them via constructor would add noise without benefit.

Navigation is **not** abstracted into a cubit/service here — pages navigate via `App.navigatorKey.currentState?.pushNamed(PageName.x.route)`. See `lib/presentation/core/app.dart`.

---

## Environments

Two environments are declared in `lib/setup.dart`:

```dart
class InjectableEnv {
  static const Environment offline = Environment("offline");
  static const Environment online = Environment("online");
}
```

Annotate environment-specific implementations with `@InjectableEnv.online` or `@InjectableEnv.offline`. Pass the active environment when calling `getIt.init(environment: ...)`.

---

## Modules

Use `@module` abstract classes for third-party types you can't annotate directly:

```dart
@module
abstract class SharedPreferencesModule {
  @InjectableEnv.online
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
```

Existing modules:
- `EventBusModule` — provides `EventBus`
- `SupabaseModule` — provides `SupabaseClient`
- `SharedPreferencesModule` — provides `SharedPreferences` via `@preResolve`

Use `@preResolve` for async getters. This makes `getIt.init()` async — callers must `await getIt.init()` (see `lib/setup.dart`).

---

## Infrastructure Layer

### Services

```dart
@LazySingleton(as: IAuthService)
class AuthService implements IAuthService {
  final SupabaseClient _client;
  AuthService(this._client);
}
```

- Third-party dependencies (`SupabaseClient`, `SharedPreferences`) are resolved via `@module` providers and passed via constructor.

### Repositories

```dart
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final IAuthService _service;
  AuthRepository(this._service);
}
```

- Service dependencies are resolved by the container and passed via constructor.
- `CacheSupport` classes are **not** injected — instantiate them as private final fields:

```dart
final FeatureCacheSupport _cache = FeatureCacheSupport();
```

---

## Application Layer

### Use Cases

```dart
@injectable
class GetFeatureUseCase implements IUseCaseWith<String, FeatureEntity> {
  final IFeatureRepository _repository;
  const GetFeatureUseCase(this._repository);
}
```

### Cubits

```dart
@injectable
class FeatureCubit extends BaseCubit<FeatureState> {
  final GetFeatureUseCase _getFeature;
  FeatureCubit(this._getFeature) : super(FeatureState.initial());
}
```

- Use cases are resolved and passed by the container.
- `getIt<EventBus>()` is allowed inside method bodies for firing one-shot events.

---

## Presentation Layer (UI)

Cubits are **not** constructor-injected in the UI. They are obtained via `getIt<T>()` inside `BlocProvider.create`:

```dart
BlocProvider(
  create: (BuildContext context) => getIt<FeatureCubit>()..init(),
  child: BlocBuilder<FeatureCubit, FeatureState>(...),
)
```

This is the only place in the UI where `getIt<T>()` should appear for cubits.

---

## DI Registration

All annotations are processed by `injectable`'s code generator. After adding/changing annotations or adding/changing constructor dependencies in any DI-managed class (`@injectable`, `@LazySingleton`, `@singleton`, `@module`), regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This regenerates `lib/setup.config.dart`. Do not edit that file manually.

---

## Lifecycle Annotations

| Annotation | When to use |
|-----------|-------------|
| `@LazySingleton(as: IType)` | Infrastructure services and repositories — one instance per session, created on first use |
| `@Singleton()` | App-wide singletons that must exist at startup (used for `SessionManager`, `InitializationService`, `DeviceIdProvider`) |
| `@injectable` | Use cases and cubits — fresh instance on each resolution |
| `@module` | Wrapper for providing third-party types |
| `@preResolve` | On async module getters — the container awaits them during `init` |

---

## Rules

| Rule | Detail |
|------|--------|
| Constructor injection | All dependencies declared as constructor parameters |
| No `getIt<T>()` in business logic | Forbidden in cubits, use cases, services, repositories |
| `getIt<EventBus>()` allowed | Call inside cubit methods to fire global events |
| `getIt<IPollAndDebounce>()` allowed | Call inside cubit methods for debounce |
| `CacheSupport` inline | Instantiated as `final _cache = FeatureCacheSupport()` — not injected |
| `@LazySingleton` for infrastructure | Services and repositories are singletons |
| `@injectable` for cubits and use cases | Fresh instance per resolution |
| `await getIt.init()` | Required because `@preResolve` makes init async |
| Run codegen after DI signature changes | `dart run build_runner build --delete-conflicting-outputs` |
| Bind implementation to interface | Always use `as: IType` to register against the abstract interface |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| `FeatureCubit(UseCase? uc) : _uc = uc ?? const UseCase()` | Optional fallback DI bypasses container wiring and hides required dependencies |
| `getIt<SomeUseCase>()` inside a cubit method | Breaks the DI contract — inject via constructor |
| `final _uc = getIt<SomeUseCase>()` in a cubit field | Same — use case/service dependencies must come from required constructor params |
| `getIt<IRepository>()` inside a use case | Same — constructor injection only |
| Injecting `CacheSupport` via constructor | They have no external dependencies; inline instantiation is the pattern |
| Editing `setup.config.dart` manually | This file is generated — run `dart run build_runner build --delete-conflicting-outputs` |
| Omitting `@injectable` / `@LazySingleton` | The class will not be registered and resolution will fail at runtime |
| Calling `getIt.init()` synchronously | Init is async because of `@preResolve` — must be awaited |
