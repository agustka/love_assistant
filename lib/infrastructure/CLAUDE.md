**Location**: `lib/infrastructure/` — the external world interface layer.

# Infrastructure Layer Rules

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
- Inline serialization or entity-to-map logic inside service/repository/store classes (no `_toJson(entity)` helpers, no hand-built `Map<String, dynamic>`). Serialization lives on Model DTOs (`toJson`/`fromJson`); entity ↔ model conversion lives on the entity (`fromModel`/`toModel`). Serialize via `entity.toModel().toJson()`; deserialize via `Model.fromJson(...)` → `Entity.fromModel(...)`.

## Repository Implementation Rules

- **Annotate every concrete class with `@LazySingleton(as: IMyRepository)`**
- **Streaming repositories** extend `ICacheLifecycleRepository` and expose `subscribe()` returning `Stream<StreamPayload<T>>` in the interface (concrete returns `BehaviorSubject` directly)
- **Mutation-only repositories** do NOT extend `ICacheLifecycleRepository` — expose only `Future<Payload<T>>` methods
- `StreamPayload<T>` states: `success`, `refresh`, `reset`, `failure`
- Implement `refresh()` (emits refresh signal first, then fetches), `reload()` (clears cache first), and `clear()` (resets cache and emits reset)
- Cache support classes are instantiated inline as private fields — never injected
- Use `forceGet` parameter to bypass cache; use stale-while-revalidate for stale cache
- Apply `servicePayload.timeToLive` when storing to cache — never hardcode TTL
- Convert models to domain entities via `DomainEntity.fromModel(model)` — never `model.toDomain()`
- Use try-catch with `err()` logging and emit `StreamPayload.failure` on all exception paths — repositories must never throw
- Use `_currentFetch` / `Completer` guard to prevent concurrent duplicate fetches
- Every streaming repository must be registered in `session_manager.dart`

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

**Boundaries never throw — they return a domain result.** Every infrastructure boundary reachable from the application/domain layers (repositories, services, and local stores/datasources) must catch its own errors and return a result rather than propagating an exception:
- `Future`-returning methods return `Payload.success(value)` / `Payload.failure(Failure(...))` — never `void`, never a raw value that can throw past the boundary.
- Streaming repositories emit `StreamPayload.success(...)` / `StreamPayload.failure(...)`.
- `Failure` is constructed as `Failure("message", {reference})` — it has no named variants (`Failure.invalidValue()` etc. do not exist).
- Always `err(ex, trace: st, location: "ClassName.methodName")` before returning the failure.

This keeps error handling consistent and safe across the whole codebase: upstream layers (use cases, cubits) branch on `Payload`/`StreamPayload` rather than wrapping infrastructure calls in try-catch.

### Repository / Store Layer
- Wrap every method body in try-catch; on error, log via `err(...)` then return `Payload.failure(Failure(...))` (or emit `StreamPayload.failure(...)` for streaming repos)
- Transform service Payloads using `.fold()` to propagate or handle failures
- Local stores/datasources (shared-preferences/Hive-backed, platform stores) follow the same contract — `Future<Payload<T>>`, never `Future<void>`/raw returns

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
