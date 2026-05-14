# Skill: repository-pattern

## Purpose

Repositories are the boundary between infrastructure and domain. They own the caching lifecycle, convert infrastructure models to domain entities, and expose data via streams (`BehaviorSubject`) or direct `Payload<T>` calls.

Each repository deals with **one resource** (e.g. accounts, cards, loans — not a mix).

---

## File Structure

```
lib/infrastructure/<feature>/repository/
├── i_<feature>_repository.dart           ← interface (implements ICacheLifecycleRepository)
├── <feature>_repository.dart             ← implementation
└── cache/                                ← optional (only if caching is required)
    └── <feature>_cache_support.dart      ← caching (see caching skill)
```

---

## Interface

The interface lives in the infrastructure layer and **implements ICacheLifecycleRepository**:

```dart
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/domain/core/value_objects/stream_payload.dart';
import 'package:isbapp/domain/<feature>/entities/<domain_entity>.dart';
import 'package:isbapp/infrastructure/core/auth/session/i_cache_lifecycle_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class I<Feature>Repository implements ICacheLifecycleRepository {
  ValueStream<StreamPayload<DomainEntity>> subscribe();

  Future<Payload<DomainEntity>> get({required bool forceGet});
}
```

### ICacheLifecycleRepository Contract

```
ICacheLifecycleRepository
├── reload()       → clears cache, flushes the stream, then fetches new data
├── refresh()      → fetches new data without clearing cache first
└── clear()        → inherited from ICacheClearable; clears cache and resets the subject
```

All three methods must be implemented by every repository.

---

## Implementation — Streaming Repository

Most repositories follow this canonical pattern:

```dart
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:isbapp/domain/core/entities/cache_wrapper.dart';
import 'package:isbapp/domain/core/value_objects/failures/failure.dart';
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/domain/core/value_objects/stream_payload.dart';
import 'package:isbapp/domain/<feature>/entities/<domain_entity>.dart';
import 'package:isbapp/infrastructure/<feature>/models/<feature>_model.dart';
import 'package:isbapp/infrastructure/<feature>/repository/cache/<feature>_cache_support.dart';
import 'package:isbapp/infrastructure/<feature>/repository/i_<feature>_repository.dart';
import 'package:isbapp/infrastructure/<feature>/service/i_<feature>_service.dart';
import 'package:isbapp/infrastructure/core/error_handling/error_handler.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: I<Feature>Repository)
class <Feature>Repository implements I<Feature>Repository {
  final I<Feature>Service _service;

  final BehaviorSubject<StreamPayload<DomainEntity>> _subject = BehaviorSubject();
  final <Feature>CacheSupport _cache = <Feature>CacheSupport(); // ← instantiated inline, NOT injected

  Future<void>? _currentFetch;

  <Feature>Repository(this._service);

  // ── ICacheLifecycleRepository ──

  @override
  Future<void> reload() async {
    await clear();
    _fetch(forceGet: true);
  }

  @override
  Future<void> refresh({required bool forceGet}) async {
    final CacheWrapper<DomainEntity> cache = await _getCached();
    _subject.add(StreamPayload.refresh(cache.data ?? const DomainEntity.invalid()));
    _fetch(forceGet: forceGet);
  }

  @override
  Future<void> clear() async {
    await _cache.clear<Feature>();
    _subject.add(StreamPayload.reset());
  }

  // ── Public API ──

  @override
  ValueStream<StreamPayload<DomainEntity>> subscribe() {
    if (!_subject.hasValue) {
      _fetch();
    }
    return _subject;
  }

  // ── Private fetch with dedup ──

  Future<void> _fetch({bool forceGet = false}) {
    if (_currentFetch != null) {
      return _currentFetch!;
    }

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
      final CacheWrapper<DomainEntity> cache = await _getCached();

      if (cache.data != null && cache.data!.valid && !forceGet) {
        _subject.add(StreamPayload.success(cache.data!));
        if (cache.stale) {
          _fetch(forceGet: true);  // background refresh
        }
        return;
      }

      final Payload<FeatureModel> servicePayload = await _service.getData();
      servicePayload.fold(
        (Failure failure) {
          _subject.add(StreamPayload.failure(failure, fallback: cache.data));
        },
        (FeatureModel value) {
          try {
            _cache.add(data: value, timeToLive: servicePayload.timeToLive);
            _subject.add(StreamPayload.success(DomainEntity.fromModel(value)));
          } catch (ex) {
            _subject.add(
              StreamPayload.failure(
                Failure.exceptionThrown(exception: ex, message: ex.toString()),
                fallback: cache.data,
                cacheDataTimeStamp: cache.timeStamp,
              ),
            );
          }
        },
      );
    } catch (ex) {
      err(ex, location: "<Feature>Repository._performActualFetch");
      _subject.add(
        StreamPayload.failure(Failure.exceptionThrown(exception: ex, message: ex.toString())),
      );
    }
  }

  Future<CacheWrapper<DomainEntity>> _getCached() async {
    final CacheWrapper<FeatureModel> cached = await _cache.get();
    return cached.transform((FeatureModel m) => DomainEntity.fromModel(m));
  }
}
```

---

## Key Patterns

### 1. Fetch Deduplication

Prevent concurrent requests for the same data:

```dart
Future<void>? _currentFetch;

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
```

### 2. Cache-first with Stale Refresh

```dart
if (cache.data != null && cache.data!.valid && !forceGet) {
  _subject.add(StreamPayload.success(cache.data!));
  if (cache.stale) {
    _fetch(forceGet: true);  // triggers background refresh
  }
  return;
}
```

### 3. Domain Conversion

Models are converted to domain entities via `DomainEntity.fromModel(model)` **inside the repository** — never in the service. The domain entity owns the mapping logic:

```dart
_subject.add(StreamPayload.success(DomainEntity.fromModel(value)));
```

### 4. Failure with Fallback

On error, pass the last cached data as fallback so the UI can still display stale data:

```dart
_subject.add(StreamPayload.failure(failure, fallback: cache.data));
```

---

## Non-Streaming Methods

Some repositories also expose direct `Payload<T>` methods (e.g. get-by-id, create, update):

```dart
@override
Future<Payload<DomainEntity>> get({required bool forceGet, required String id}) async {
  if (!forceGet) {
    final CacheWrapper<Model> payload = await _cache.getById(id: id);
    if (!payload.stale && payload.data != null) {
      return Payload.success(DomainEntity.fromModel(payload.data!));
    }
  }
  return _fetchFromService(id: id);
}

Future<Payload<DomainEntity>> _fetchFromService({required String id}) async {
  final Payload<Model> payload = await _service.getById(id: id);
  return payload.fold(
    (Failure failure) => Payload.failure(failure),
    (Model model) {
      _cache.add(id: id, data: model, timeToLive: payload.timeToLive);
      return Payload.success(DomainEntity.fromModel(model));
    },
  );
}
```

Mutating methods (create/update/delete) typically skip the cache on write:

```dart
@override
Future<Payload<DomainEntity>> create({required CreateParams params}) async {
  final requestModel = CreateRequestModel.fromDomain(params);
  final Payload<Model> payload = await _service.create(body: requestModel);
  return payload.fold(
    (Failure failure) => Payload.failure(failure),
    (Model model) => Payload.success(DomainEntity.fromModel(model)),
  );
}
```

---

## Session Manager Registration

Every repository that implements `ICacheLifecycleRepository` **must** be registered in `session_manager.dart`:

1. Add the interface as a constructor parameter
2. Add it to the `_repos` list

```dart
// session_manager.dart
class SessionManager {
  final I<Feature>Repository _<feature>Repository;
  // ...

  List<ICacheLifecycleRepository> get _repos => [
    // ...existing repos...
    _<feature>Repository,
  ];
}
```

> A static analysis rule (`session_manager_completeness_rule.py`) verifies that every `ICacheLifecycleRepository` subtype is registered. Failing to add it will be caught in CI.

Optionally, if the repository should **not** be refreshed on screen unlock, add it to `_excludeFromUnlockRefresh` as well.

---

## StreamPayload States

The subject emits these states:

| Factory | Meaning |
|---------|---------|
| `StreamPayload.success(data)` | Fresh or cached data, valid |
| `StreamPayload.refresh(currentData)` | Currently refreshing; shows existing data |
| `StreamPayload.reset()` | Cache cleared, no data |
| `StreamPayload.failure(failure, fallback:)` | Error, with optional stale data |

---

## Rules

| Rule | Detail |
|------|--------|
| One resource per repository | Do not mix unrelated data in one repository |
| Always implement `ICacheLifecycleRepository` | Unless the repository is truly transient (very rare) |
| Register in `session_manager.dart` | Required for lifecycle management |
| Use `@LazySingleton` | Repositories are singletons — they own the `BehaviorSubject`. See dependency-injection skill |
| `BehaviorSubject` | Use `BehaviorSubject<StreamPayload<T>>` — never `StreamController` |
| Domain conversion in repo | Call `DomainEntity.fromModel(model)` here, not in the service layer |
| Cache wrapper | Always go through `CacheWrapper` and check both `data != null` and `!stale` |
| Dedup fetches | Use the `_currentFetch` / `Completer` pattern to avoid concurrent requests |
| forceGet | Bypass cache when `true`; respect TTL when `false` |
| Cache support is optional | Do not generate `*CacheSupport` for direct passthrough or non-cache local persistence repositories |

---

## Domain Entity Dependency

The repository layer depends on **domain entities** that provide `DomainEntity.fromModel(model)` factories. These entities are produced by the **domain agent**, not the infrastructure agent.

**If domain entities do not yet exist**, the infrastructure agent must:

1. Generate everything up to and including optional cache support (models, converter, chopper/graphql, service, and cache support only when cache semantics are required)
2. **Stop before generating the repository**
3. Mark the handoff status as `incomplete` with the gap: `"repository pending domain entities"`

The pipeline agent is then responsible for running the domain agent to produce the entities, and re-running (or continuing) the infrastructure agent to finalize the repository.

> **Never** generate a repository that references a domain entity that doesn't exist — it won't compile and creates unnecessary noise.

---

## What NOT to Do

- Do not expose infrastructure models from the repository interface — return domain entities
- Do not call chopper services directly — call the service layer
- Do not skip cache lifecycle methods (`reload`, `refresh`, `clear`)
- Do not forget to add the repository to `session_manager.dart`
- Do not use `StreamController` — use `BehaviorSubject` from rxdart
- Do not implement business logic (validation, orchestration) — that belongs in use cases
- Do not use `model.toDomain()` — this is deprecated; use `DomainEntity.fromModel(model)` instead (the domain entity owns its construction)

