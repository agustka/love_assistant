# Skill: repository-pattern

## Purpose

Repositories live in the **infrastructure layer** and are the boundary between domain logic and external data sources. They own caching, streaming, request deduplication, and model-to-domain mapping.

Each repository deals with **one resource** (e.g. accounts, cards — not a mix).

---

## File Structure

```
lib/
  infrastructure/
    core/
      auth/
        session/
          i_cache_clearable.dart               ← ICacheClearable
          i_cache_lifecycle_repository.dart    ← ICacheLifecycleRepository
          session_manager.dart                 ← lifecycle orchestrator
      service/
        cache/
          cache_support.dart                   ← CacheSupport mixin
    <feature>/
      repository/
        i_<name>_repository.dart               ← interface
        <name>_repository.dart                 ← concrete class
        cache/
          <name>_cache_support.dart            ← Hive wrapper (when caching required)
      service/
        i_<name>_service.dart
        <name>_service.dart
      models/
        <name>_model.dart
```

---

## The Interface Hierarchy

```
ICacheClearable
  └─ clear(): Future<void>

ICacheLifecycleRepository  (extends ICacheClearable)
  ├─ clear(): Future<void>      ← clears cache and emits StreamPayload.reset()
  ├─ reload(): Future<void>     ← clears cache, then fetches fresh data
  └─ refresh({required bool forceGet}): Future<void>
```

**Streaming repositories** extend `ICacheLifecycleRepository` and add `subscribe()`:

```dart
abstract interface class IMyRepository implements ICacheLifecycleRepository {
  Stream<StreamPayload<MyEntity>> subscribe();
  // optional extra one-shot methods
}
```

**Mutation-only repositories** (no live stream) do **not** extend `ICacheLifecycleRepository`:

```dart
abstract interface class IMyRepository {
  Future<Payload<void>> doSomething();
  Future<Payload<MyResult>> getItem({required bool forceGet});
}
```

> `subscribe()` returns `Stream<StreamPayload<T>>` in the interface — **not** `ValueStream` — to keep the interface decoupled from rxdart. The concrete class returns the `BehaviorSubject` directly, which satisfies this contract.

---

## Dependency Injection

```dart
@LazySingleton(as: IMyRepository)
class MyRepository implements IMyRepository { ... }
```

Use `@LazySingleton` (not `@injectable`). Repositories are singletons — they own the `BehaviorSubject` and must not be re-created per injection.

| Artifact | Registered as | DI annotation |
|---|---|---|
| Streaming repository | `IMyRepository` | `@LazySingleton(as: IMyRepository)` |
| Mutation-only repository | `IMyRepository` | `@LazySingleton(as: IMyRepository)` |
| Cache support | (not injected — instantiated inline) | none |
| Service | `IMyService` | `@LazySingleton(as: IMyService)` |

---

## Streaming Repository — Canonical Template

```dart
@LazySingleton(as: IMyRepository)
class MyRepository implements IMyRepository {
  final IMyService _service;
  final MyCacheSupport _cache = MyCacheSupport();  // instantiated inline, NOT injected

  final BehaviorSubject<StreamPayload<MyEntity>> _subject = BehaviorSubject();
  Future<void>? _currentFetch;                      // deduplication guard

  MyRepository(this._service);

  // ── Public API ──────────────────────────────────────────────────────────────

  @override
  Stream<StreamPayload<MyEntity>> subscribe() {
    if (!_subject.hasValue) {
      _fetch();                   // auto-fetch on first subscriber
    }
    return _subject;              // BehaviorSubject satisfies Stream<> contract
  }

  @override
  Future<void> refresh({required bool forceGet}) async {
    final CacheWrapper<MyEntity> cache = await _getCached();
    _subject.add(StreamPayload.refresh(cache.data ?? const MyEntity.invalid()));
    _fetch(forceGet: forceGet);
  }

  @override
  Future<void> reload() async {
    await clear();
    _fetch(forceGet: true);
  }

  @override
  Future<void> clear() async {
    await _cache.clear();
    _subject.add(StreamPayload.reset());
  }

  // ── Internal fetch logic ────────────────────────────────────────────────────

  Future<void> _fetch({bool forceGet = false}) {
    if (_currentFetch != null) return _currentFetch!;

    final Completer<void> completer = Completer<void>();
    _currentFetch = completer.future;

    _performActualFetch(forceGet: forceGet).whenComplete(() {
      _currentFetch = null;
      completer.complete();
    });

    return _currentFetch!;
  }

  Future<void> _performActualFetch({bool forceGet = false}) async {
    try {
      final CacheWrapper<MyEntity> cache = await _getCached();

      if (cache.data != null && cache.data!.valid && !forceGet) {
        _subject.add(StreamPayload.success(cache.data!));
        if (cache.stale) {
          _fetch(forceGet: true);   // stale-while-revalidate
        }
        return;
      }

      final Payload<MyEntityModel> servicePayload = await _service.getMyEntity();
      servicePayload.fold(
        (Failure failure) {
          _subject.add(StreamPayload.failure(failure, fallback: cache.data));
        },
        (MyEntityModel model) {
          _cache.add(model: model, timeToLive: servicePayload.timeToLive);
          _subject.add(StreamPayload.success(MyEntity.fromModel(model)));
        },
      );
    } catch (ex) {
      err(ex, location: "MyRepository._performActualFetch");
      _subject.add(StreamPayload.failure(
        Failure(ex.toString()),
      ));
    }
  }

  Future<CacheWrapper<MyEntity>> _getCached() async {
    final CacheWrapper<MyEntityModel> raw = await _cache.get();
    return raw.transform((MyEntityModel m) => MyEntity.fromModel(m));
  }
}
```

### Key invariants

| Rule | Reason |
|---|---|
| `subscribe()` returns `_subject` directly | New subscribers immediately get the last-emitted value (BehaviorSubject) |
| Initial fetch only when `!_subject.hasValue` | Avoids redundant network calls when multiple widgets subscribe |
| `refresh()` emits `StreamPayload.refresh(currentData)` first | Non-blocking loading indicator while keeping stale data visible |
| `reload()` calls `clear()` first | Subscribers receive `StreamPayload.reset()` before new data |
| `_currentFetch` guard | Prevents concurrent identical network calls |
| Stale cache → background `_fetch(forceGet: true)` | Stale-while-revalidate: serve instantly, silently refresh |
| Failure always includes `fallback: cache.data` | UI can show last-known data alongside the error |
| All exceptions caught in `_performActualFetch` | Repository must never throw |

---

## Non-Streaming (One-Shot) Methods

### Read with cache

```dart
@override
Future<Payload<MyResult>> getItem({required int id, required bool forceGet}) async {
  if (!forceGet) {
    final CacheWrapper<MyResultModel> cached = await _cache.getItem(id: id);
    if (cached.data != null && !cached.stale) {
      return Payload.success(MyResult.fromModel(cached.data!));
    }
  }
  return _fetchItem(id: id);
}

Future<Payload<MyResult>> _fetchItem({required int id}) async {
  try {
    final Payload<MyResultModel> response = await _service.getItem(id: id);
    return response.fold(
      (Failure failure) => Payload.failure(failure),
      (MyResultModel model) {
        _cache.addItem(id: id, model: model, timeToLive: response.timeToLive);
        return Payload.success(MyResult.fromModel(model));
      },
    );
  } on Exception catch (e, stacktrace) {
    err(e, trace: stacktrace, location: "MyRepository._fetchItem");
    return Payload.failure(Failure(e.toString()));
  }
}
```

### Mutation with stream invalidation

When a mutation should invalidate related streams, call `reload()` in the success branch:

```dart
@override
Future<Payload<void>> deleteItem({required int id}) async {
  final Payload<void> response = await _service.deleteItem(id: id);
  return response.fold(
    (Failure failure) => Payload.failure(failure),
    (_) {
      reload();               // invalidate own stream
      _otherRepo.reload();    // invalidate related streams if needed
      return Payload.success(null);
    },
  );
}
```

---

## Session Manager Registration

Every repository that implements `ICacheLifecycleRepository` **must** be registered in `session_manager.dart`:

```dart
class SessionManager {
  final IMyRepository _myRepository;
  // ...

  List<ICacheLifecycleRepository> get _repos => [
    // ...existing repos...
    _myRepository,
  ];
}
```

If the repository should **not** be refreshed on screen unlock, add it to `_excludeFromUnlockRefresh` as well.

---

## StreamPayload States

| Factory | Meaning |
|---|---|
| `StreamPayload.success(data)` | Fresh or cached data |
| `StreamPayload.refresh(currentData)` | Refreshing; current data visible |
| `StreamPayload.reset()` | Cache cleared, no data |
| `StreamPayload.failure(failure, fallback:)` | Error, with optional stale data |

---

## Domain Entity Dependency

Repositories call `DomainEntity.fromModel(model)` for domain conversion — **never** `model.toDomain()`. The domain entity owns its construction from the infrastructure model.

If domain entities do not yet exist when generating the infrastructure layer:
1. Generate models, converter, service, and cache support
2. **Stop before generating the repository**
3. Mark the handoff `incomplete` with gap: `"repository pending domain entities"`

The pipeline then runs the domain agent and re-triggers the infrastructure agent.

---

## Rules

| Rule | Detail |
|---|---|
| Streaming repos extend `ICacheLifecycleRepository` | Required for lifecycle management |
| Mutation-only repos do NOT extend `ICacheLifecycleRepository` | Only expose `Future<Payload<T>>` methods |
| `subscribe()` returns `Stream<>` in interface | Decoupled from rxdart; concrete returns `BehaviorSubject` directly |
| `@LazySingleton` | Repositories are singletons — they own the `BehaviorSubject` |
| Register in `session_manager.dart` | Required for every `ICacheLifecycleRepository` implementation |
| `BehaviorSubject` not `StreamController` | Replay last value to new subscribers |
| `DomainEntity.fromModel(model)` | Not `model.toDomain()` — domain entity owns its construction |
| Cache support instantiated inline | `final MyCacheSupport _cache = MyCacheSupport()` — not injected |
| `getCachedV2` | Returns `CacheWrapper<T>` with `stale` flag — not the legacy `getCached` |
| Dedup with `_currentFetch` | Prevents concurrent identical network calls |
| Failure with `fallback: cache.data` | UI shows stale data alongside error |
| One resource per repository | Do not mix unrelated data |

---

## What NOT to Do

- Do not expose infrastructure models from the interface — return domain entities
- Do not use `model.toDomain()` — use `DomainEntity.fromModel(model)` instead
- Do not use `ValueStream` in the interface — use `Stream` (keep rxdart out of interfaces)
- Do not use `StreamController` — use `BehaviorSubject`
- Do not inject `CacheSupport` — instantiate it inline
- Do not call services directly from use cases — always go through the repository
- Do not implement business logic in repositories — that belongs in use cases
- Do not forget to register streaming repositories in `session_manager.dart`
- Do not skip `ICacheLifecycleRepository` for streaming repos
- Do not add `ICacheLifecycleRepository` to mutation-only repos
