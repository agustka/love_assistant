# Streaming Repositories — Implementation Guide

This document describes how repositories are implemented in the `Channels.Flutter.Components` project. It is a companion to `use_cases.md`. Its purpose is to help a coding agent in another Flutter project update that project's agents, skills, and instructions so the same approach is followed consistently.

---

## Overview

Repositories live in the **infrastructure layer** and are the boundary between domain logic and external data sources (network services, device storage, etc.). They own:

- **Caching** — reading and writing from Hive via `CacheSupport`
- **Streaming** — broadcasting state changes via `BehaviorSubject<StreamPayload<T>>`
- **Request deduplication** — preventing concurrent identical fetches
- **Model-to-domain mapping** — calling `.toDomain()` on infrastructure models before exposing them

Directory convention: `lib/infrastructure/<feature>/repository/`

Each repository has:
- An **interface** (`i_<name>_repository.dart`) placed in the same directory
- A **concrete class** (`<name>_repository.dart`) in the same directory
- An optional **cache support class** (`cache/<name>_cache_support.dart`) that encapsulates Hive keys and serialisation

---

## The Interface Hierarchy

```
ICacheClearable
  └─ clear(): Future<void>

ICacheLifecycleRepository  (extends ICacheClearable)
  ├─ clear(): Future<void>      ← inherited; clears cache and emits StreamPayload.reset()
  ├─ reload(): Future           ← clears cache, then fetches fresh data
  └─ refresh({required bool forceGet}): Future   ← fetches without clearing; emits refresh signal first
```

Streaming repositories implement `ICacheLifecycleRepository` plus their own `subscribe()` method:

```dart
abstract interface class IMyRepository implements ICacheLifecycleRepository {
  Stream<StreamPayload<MyEntity>> subscribe();
// optional: extra one-shot methods like getItem({required bool forceGet})
}
```

Non-streaming repositories (mutation-only, no live stream) do **not** extend `ICacheLifecycleRepository`. They expose only `Future<Payload<T>>` methods:

```dart
abstract interface class IMyRepository {
  Future<Payload<void>> doSomething();
  Future<Payload<MyResult>> getItem({required bool forceGet});
}
```

---

## Dependency Injection

Concrete repositories are registered as **lazy singletons** bound to their interface:

```dart
@LazySingleton(as: IMyRepository)
class MyRepository implements IMyRepository { ... }
```

Use `@LazySingleton` (not `@injectable`) for repositories so only one instance exists per session. The singleton is created on first access and lives until the app is disposed or the DI container is reset.

---

## The Streaming Repository Pattern (full template)

This is the canonical shape for a repository that streams live data. All the moving parts are explained inline.

```dart
@LazySingleton(as: IMyRepository)
class MyRepository implements IMyRepository {
  final IMyService _service;           // network/data source, injected
  final MyCacheSupport _cache = MyCacheSupport(); // Hive wrapper, instantiated locally

  final BehaviorSubject<StreamPayload<MyEntity>> _subject = BehaviorSubject();

  Future<void>? _currentFetch;         // deduplication guard

  MyRepository(this._service);

  // ── Public API ──────────────────────────────────────────────────────────────

  @override
  ValueStream<StreamPayload<MyEntity>> subscribe() {
    if (!_subject.hasValue) {
      _fetch();                         // auto-fetch on first subscriber
    }
    return _subject;                    // return BehaviorSubject as ValueStream
  }

  @override
  Future<void> refresh({required bool forceGet}) async {
    final CacheWrapper<MyEntity> cache = await _getCached();
    // Signal "loading" to subscribers while keeping current data visible
    _subject.add(StreamPayload.refresh(cache.data ?? const MyEntity.invalid()));
    _fetch(forceGet: forceGet);
  }

  @override
  Future<void> reload() async {
    await clear();                      // wipe cache, emit reset
    _fetch(forceGet: true);
  }

  @override
  Future<void> clear() async {
    await _cache.clear();
    _subject.add(StreamPayload.reset());
  }

  // ── Internal fetch logic ────────────────────────────────────────────────────

  Future<void> _fetch({bool forceGet = false}) {
    // Deduplicate: if a fetch is already in flight, return the same Future
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
          // Background refresh for stale-while-revalidate behaviour
          _fetch(forceGet: true);
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
          _subject.add(StreamPayload.success(model.toDomain()));
        },
      );
    } catch (ex) {
      err(ex, location: "MyRepository._performActualFetch");
      _subject.add(StreamPayload.failure(
        Failure.exceptionThrown(exception: ex, message: ex.toString()),
      ));
    }
  }

  Future<CacheWrapper<MyEntity>> _getCached() async {
    final CacheWrapper<MyEntityModel> raw = await _cache.get();
    return raw.transform((MyEntityModel m) => m.toDomain());
  }
}
```

### Key invariants

| Rule | Reason |
|---|---|
| `subscribe()` returns a `ValueStream` (i.e., the `BehaviorSubject` itself) | New subscribers immediately get the last-emitted value without waiting for a new fetch |
| `subscribe()` triggers an initial fetch only when `!_subject.hasValue` | Avoids redundant network calls when multiple widgets subscribe |
| `refresh()` emits `StreamPayload.refresh(currentData)` before fetching | Lets the UI show a non-blocking loading indicator while keeping stale data visible |
| `reload()` calls `clear()` first, then fetches | Guarantees subscribers receive `StreamPayload.reset()` and blank state before new data |
| `clear()` emits `StreamPayload.reset()` | Ensures subscribers reset their state (e.g., on logout) |
| `_currentFetch` guard | Prevents two simultaneous network calls when `subscribe()` and `refresh()` are called together |
| Stale cache → background `_fetch(forceGet: true)` | Stale-while-revalidate: serve cached data instantly, silently refresh in the background |
| Failure always includes `fallback: cache.data` | UI can display last-known data alongside the error instead of going blank |
| Catch all exceptions in `_performActualFetch` | Repository must never throw; all errors travel as `StreamPayload.failure(...)` |

---

## Cache Support

Each streaming repository owns a dedicated `CacheSupport` subclass that encapsulates box names, key schemes, and model serialisation.

```dart
class MyCacheSupport with CacheSupport {
  static const String _box = "MyFeature";       // unique Hive box name
  static const String _key = "myEntityKey";

  final MyModelConverter _converter = MyModelConverter();

  Future<CacheWrapper<MyEntityModel>> get() {
    return getCachedV2<MyEntityModel>(
      box: _box,
      key: _key,
      conversions: _converter.conversions,
    );
  }

  void add({required MyEntityModel model, required Duration timeToLive}) {
    addCache(box: _box, key: _key, data: model.toJson(), timeToLive: timeToLive);
  }

  Future<void> clear() => deleteEntry(box: _box, key: _key);
}
```

Rules:
- `CacheSupport` is a **mixin**, not a base class — use `with CacheSupport`.
- Box names must be unique across the app. Use a feature-scoped constant string.
- When a cache entry is parameterised (e.g., by ID or locale), derive the key with a static helper: `static String _keyFor(String id) => "myEntity-$id"`.
- Always store infrastructure models (`*Model`), never domain entities. Domain mapping happens in the repository when reading.
- Pass `payload.timeToLive` (from `Payload<T>`) to `addCache` so the server-dictated TTL is respected.
- Use `getCachedV2` (returns `CacheWrapper<T>`) rather than `getCached` (returns `Payload<T>`). `CacheWrapper` carries a `stale` flag needed for stale-while-revalidate.

---

## One-Shot (Non-Streaming) Repository Methods

Repositories that only serve one-shot operations (no live stream) — or streaming repositories that also need request/response methods — follow a consistent pattern:

```dart
@override
Future<Payload<MyResult>> getItem({required int id, required bool forceGet}) async {
  if (!forceGet) {
    final Payload<MyResultModel> cached = await _cache.getItem(id: id);
    return cached.fold(
          (_) => _fetchItem(id: id),            // cache miss → fetch
          (MyResultModel value) {
        if (cached.stale) return _fetchItem(id: id);  // stale → re-fetch
        return Payload.success(value.toDomain());
      },
    );
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
        return Payload.success(model.toDomain());
      },
    );
  } on Exception catch (e, stacktrace) {
    err(e, trace: stacktrace, location: "MyRepository._fetchItem");
    return Payload.failure(Failure.exceptionThrown(exception: e, message: e.toString()));
  }
}
```

For mutation methods (POST/PUT/DELETE) that should invalidate related streams, call `reload()` or a sibling repository's `reload()` inside the success branch:

```dart
return response.fold(
(Failure failure) => Payload.failure(failure),
(MyResultModel model) {
reload();                  // invalidate own stream
_otherRepo.reload();       // invalidate related streams
return Payload.success(model.toDomain());
},
);
```

---

## Interface Design Rules

- A streaming repository interface always extends `ICacheLifecycleRepository`.
- A mutation-only repository interface extends nothing — just declare `Future<Payload<T>>` methods.
- `subscribe()` returns `Stream<StreamPayload<T>>` in the interface (not `ValueStream<...>`), even though the concrete class returns the `BehaviorSubject` directly. This keeps the interface decoupled from rxdart.
- When the repository needs an extra one-shot getter alongside the stream (e.g., `getAccounts`), add it to the interface explicitly.
- Never expose `BehaviorSubject` directly through the interface — only `Stream` or `ValueStream`.

---

## The Concrete ↔ Interface Registration Table

| Concrete class | Registered as | DI annotation |
|---|---|---|
| Streaming repository | `IMyRepository` | `@LazySingleton(as: IMyRepository)` |
| Mutation-only repository | `IMyRepository` | `@LazySingleton(as: IMyRepository)` |
| Cache support | (not injected, instantiated inline) | none |
| Service | `IMyService` | `@LazySingleton(as: IMyService)` |

---

## File Layout Reference

```
lib/
  infrastructure/
    core/
      auth/
        session/
          i_cache_clearable.dart          ← ICacheClearable
          i_cache_lifecycle_repository.dart ← ICacheLifecycleRepository
      service/
        cache/
          cache_support.dart              ← CacheSupport mixin
    <feature>/
      repository/
        i_<name>_repository.dart          ← interface
        <name>_repository.dart            ← concrete class
        cache/
          <name>_cache_support.dart       ← Hive wrapper
      service/
        i_<name>_service.dart             ← network/data service interface
        <name>_service.dart               ← concrete service
      models/
        <name>_model.dart                 ← infrastructure model (freezed/json_serializable)
```

---

## Checklist for a New Streaming Repository

1. Create the interface in `i_<name>_repository.dart` extending `ICacheLifecycleRepository`; add `subscribe()` returning `Stream<StreamPayload<T>>`.
2. Create `<name>_cache_support.dart` with `with CacheSupport`; define a constant box name and typed `get`/`add`/`clear` methods.
3. Create the concrete class with `@LazySingleton(as: I<Name>Repository)`.
4. Add a `BehaviorSubject<StreamPayload<T>>` field and a `Future<void>? _currentFetch` guard.
5. Implement `subscribe()`: guard with `!_subject.hasValue`, then return `_subject`.
6. Implement `refresh()`: emit `StreamPayload.refresh(cachedData)`, then call `_fetch(forceGet: forceGet)`.
7. Implement `reload()`: call `clear()` (which emits reset), then `_fetch(forceGet: true)`.
8. Implement `clear()`: clear the cache, emit `StreamPayload.reset()`.
9. Implement `_fetch()` with the `_currentFetch` deduplication pattern.
10. Implement `_performActualFetch()`: check cache → serve cache or fetch service → update cache → emit to subject. Wrap in try/catch.
11. Implement `_getCached()`: read from cache support, call `.transform(m => m.toDomain())`.
12. Ensure all exception paths emit `StreamPayload.failure(...)` — never throw.
