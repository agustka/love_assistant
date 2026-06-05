---
name: caching
description: >-
  Add dedicated cache helper classes for infrastructure repositories using Hive
  cache wrappers, TTL and staleness behavior, serialization, and cache-focused
  tests.
tools: []
---

# Skill: caching

## Purpose

Use a dedicated, testable cache helper class only when caching is needed to improve responsiveness against slow/remote data sources.

`*CacheSupport` is strictly for cache concerns (TTL/staleness/`CacheWrapper` over Hive `CacheSupport`).
Do not place repository/business/non-cache persistence logic in cache helpers.

The cache layer serializes models to JSON and stores them in Hive via `IHiveCache`. It returns `CacheWrapper<T>` which tells the caller whether data exists and whether it is stale (TTL expired).

---

## File Structure

```
lib/infrastructure/<feature>/repository/cache/
└── <feature>_cache_support.dart
```

Or if the cache support sits one level up (single-file repositories):

```
lib/infrastructure/<feature>/repository/
└── <feature>_cache_support.dart
```

---

## Canonical Template

```dart
import 'package:la/domain/core/entities/cache_wrapper.dart';
import 'package:la/infrastructure/core/service/cache/cache_support.dart';
import 'package:la/infrastructure/<feature>/models/<feature>_model.dart';

class <Feature>CacheSupport with CacheSupport {
  static const String _box = "<Feature>";
  static const String _key = "<featureData>";

  Map<dynamic, Function> get _conversions => {
    <Feature>Model: (Map<String, dynamic> data) => <Feature>Model.fromJson(data),
  };

  Future<CacheWrapper<<Feature>Model>> get() {
    return getCachedV2<<Feature>Model>(
      box: _box,
      key: _key,
      conversions: _conversions,
    );
  }

  void add({
    required <Feature>Model data,
    required Duration timeToLive,
  }) {
    return addCache(
      box: _box,
      key: _key,
      data: data,
      timeToLive: timeToLive,
    );
  }

  Future<void> clear() {
    return deleteEntry(box: _box);
  }
}
```

---

## CacheSupport Mixin API

The `CacheSupport` mixin (`lib/infrastructure/core/service/cache/cache_support.dart`) provides:

| Method | Return | Purpose |
|--------|--------|---------|
| `getCachedV2<T>(box, key, conversions)` | `Future<CacheWrapper<T>>` | **Use this** — returns wrapper with `data`, `stale`, `timeStamp` |
| `addCache(box, key, data, timeToLive)` | `void` | Serializes `data.toJson()` and stores with expiry |
| `addCacheAsync(box, key, data, timeToLive)` | `Future` | Async version of `addCache` |
| `deleteEntry(box, key?)` | `Future<void>` | Deletes a specific key or the entire box |
| ~~`getCached<T>(box, key, conversions)`~~ | ~~`Future<Payload<T>>`~~ | **Legacy — do not use** |

> Always use `getCachedV2` (returns `CacheWrapper`) instead of the older `getCached` (returns `Payload`).

---

## CacheWrapper

```dart
class CacheWrapper<V> {
  final V? data;       // null if no cache found
  final bool stale;    // true if TTL has expired
  final DateTime timeStamp; // when the data was cached
}
```

Factories:
- `CacheWrapper.noCache()` — no data found
- `CacheWrapper.cache(data, stale:, timeStamp:)` — data exists

---

## Conversions Map

The `conversions` parameter is a `Map<dynamic, Function>` that maps model types to their `fromJson` factories:

```dart
Map<dynamic, Function> get _conversions => {
  <Feature>Model: (Map<String, dynamic> data) => <Feature>Model.fromJson(data),
  <Item>Model: (Map<String, dynamic> data) => <Item>Model.fromJson(data),
};
```

This project does **not** use Chopper, so there is no shared model-converter class to reuse. Define the conversions map inline on the cache support class (or as a private getter). Models must expose `fromJson(Map<String, dynamic>)` factories — hand-written, since `json_serializable` is not in `pubspec.yaml`.

---

## Keying Strategy

| Scenario | Key pattern |
|----------|-------------|
| Single resource | Static string: `"featureData"` |
| Resource by ID | `"Feature_$id"` |
| Parameterized query | Composite: `"feature-$param1-$param2"` |

Example with dynamic key:

```dart
static String _getKey(List<String>? statuses, String? timeFrom) =>
    "data${statuses != null ? "-${statuses.join("-")}" : ""}${timeFrom != null ? "-$timeFrom" : ""}";
```

---

## Clearing

| Method | Use case |
|--------|----------|
| `deleteEntry(box: _box)` | Clear all entries in the box (used in `repository.clear()`) |
| `deleteEntry(box: _box, key: _key)` | Clear a specific key only |

---

## Rules

| Rule | Detail |
|------|--------|
| Dedicated class | Cache logic in `<Feature>CacheSupport` only when cache semantics are required |
| Mix in `CacheSupport` | `class <Feature>CacheSupport with CacheSupport` |
| Use `getCachedV2` | Returns `CacheWrapper<T>` — the modern API |
| Model converter | Reuse the feature's existing model converter for `conversions` |
| Box name | Unique per feature (PascalCase string) |
| TTL from service | Pass `servicePayload.timeToLive` when storing — do not hardcode TTL in cache support |
| Serialization | Models must have `toJson()` (used by `json.encode(data)` inside `addCache`) |
| Testability | The cache support class can be mocked independently in repository tests |
| Concern boundary | Cache helpers only perform cache get/store/invalidate; non-cache persistence stays in repository or dedicated `*Store`/`*LocalDataSource` |
| Optional generation | If no cache-first/TTL/stale behavior is required, do not generate `*CacheSupport` |

---

## Integration with Repository

```dart
class <Feature>Repository implements I<Feature>Repository {
  final <Feature>CacheSupport _cache = <Feature>CacheSupport();

  Future<CacheWrapper<DomainEntity>> _getCached() async {
    final CacheWrapper<<Feature>Model> cached = await _cache.get();
    return cached.transform((<Feature>Model m) => DomainEntity.fromModel(m));
  }

  void _storeInCache(<Feature>Model model, Duration timeToLive) {
    _cache.add(data: model, timeToLive: timeToLive);
  }
}
```

---

## What NOT to Do

- Do not use the legacy `getCached` method (returns `Payload`) — use `getCachedV2` (returns `CacheWrapper`)
- Do not inline cache reads/writes directly in the repository class when cache support is used
- Do not hardcode TTL in the cache support — accept it as a parameter from the service response
- Do not store domain entities in cache — store **models** (they have `toJson`/`fromJson`)
- Do not share box names between unrelated features
- Do not place non-cache local persistence workflow methods in `*CacheSupport` unless they are true cache invalidation/read-through behavior
