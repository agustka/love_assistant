---
applyTo: "lib/infrastructure/**/*.dart"
---

# Infrastructure Layer Rules

**Location**: `lib/infrastructure/` — the external world interface layer.

## What BELONGS in Infrastructure

- Repository implementations & interfaces (prefix interfaces with `I`)
- HTTP client services using Chopper (with BaseService mixin)
- GraphQL services using Ferry (extending BaseGraphQLService, Dio as HTTP adapter)
- Hive cache implementations (in cache support classes)
- Platform-specific services and file system operations
- External API integrations
- Client providers (for GraphQL/Chopper client configuration)
- **Model Layer**: External API DTOs with json_serializable (separate from Domain entities)
- Model files in `/models` directories with `_model.dart` suffix
- Model converters for Chopper: extend `JsonConverter` with `BaseConverter` mixin, define `conversions` map, override `convertResponse`
- Models use `@JsonSerializable()` and `@immutable` annotations; do NOT extend Equatable

## What NEVER belongs in Infrastructure

- UI components, widgets, cubits, or state management
- Business logic, domain rules, or application workflow logic
- Domain entity creation with business rules

## Repository Implementation Rules

- **Annotate every concrete class with `@LazySingleton` and bind to interface**
- Use `BehaviorSubject` for streaming data with `subscribe()` methods returning `ValueStream<StreamPayload<T>>`
- `StreamPayload<T>` states: success, failure, refreshData, reset
- Implement `refresh()` (soft, cache fallback), `reload()` (hard, clears cache first), and `clear()` (reset cache and stream)
- Cache support classes are instantiated as private final fields (not injected)
- Use `forceGet` parameter to bypass cache; handle stale cache via `refreshInBackground`
- Apply cache TTL from service payload when storing data
- Transform models to domain entities via `toDomain()` before emitting to stream
- Use try-catch with `err()` logging and emit `StreamPayload.failure` on exceptions
- Repository may orchestrate non-cache local persistence methods when required by `api.yaml` workaround behavior

## HTTP & GraphQL Client Rules

- Services use `@LazySingleton(as: IInterface)` annotations
- Handle authentication and headers consistently
- BaseService handles DioException retries; GraphQL services use Ferry's `OperationResponse` and generated request/data/var classes
- Never expose raw HTTP responses or exceptions to upper layers — always wrap in `Payload`
- Use DTOs (models) for all JSON serialization/deserialization

## Caching Rules

- Use Hive via cache support classes (`*_cache_support.dart`) extending `CacheSupport` mixin
- Cache support classes define box names and key generation methods
- Pattern: check cache first with `forceGet` flag → if not stale, return cached; otherwise fetch, store with `timeToLive`
- Cache at repository level, not service level
- `*_cache_support.dart` is reserved for cache concerns only (TTL/staleness/cache key invalidation)
- Non-cache local persistence must be implemented in repository or a dedicated local datasource/store class, not in cache support

## Error Handling

### Repository Layer
- Log with `err(ex, location: "ClassName.methodName")` including stack traces: `err(e, trace: st, location: "...")`
- Use specific Failure types (e.g., `Failure.invalidValue()`, `Failure.notAuthorized()`)
- Transform service Payloads using `.fold()` to propagate or handle failures

### Service Layer
- Use `BaseService` mixin methods: `handleResponse()` and `handleException()`
- Wrap methods in try-catch catching `Exception` with stack traces
- Use `handleException(e, stacktrace)` for consistent error transformation into `Payload`

## NEVER use

- Direct http package or non-cache local storage mechanisms for API response caching
- Synchronous operations where async/streams are appropriate
- Business logic in infrastructure services
- Direct entity creation without validation

## Structure

Typical folder structure per feature:
- `/models` — DTOs, converters
- `/repository` — Implementations, interfaces (`I*`), cache support classes
- `/service` — Implementations, interfaces (`I*`), `/chopper` or `/graphql` subdirectories

## Offline Implementations

Offline implementations provide mock service responses for testing/development, loaded only in `@InjectableEnv.offline`.

### Offline Service Implementations

- Annotate with `@InjectableEnv.offline` and `@LazySingleton(as: IServiceInterface)`
- Place in `/offline/` subdirectories; name classes with `Offline` prefix
- Mix in `OfflineHelper`; load data from `AppAssets.test.offlineData.*`
- Return `Payload<T>` types consistent with production services

### Offline Client Implementations (Chopper/HTTP)

- Annotate client providers with `@InjectableEnv.offline` and `@LazySingleton(as: IClientProvider)`
- Place in `/client/offline/`; clients extend `BaseOfflineClient` with `OfflineHelper` mixin
- Pattern match on URL paths and HTTP methods; return `http.Response` with JSON from assets
- Support configurable responses via nullable properties for test scenarios