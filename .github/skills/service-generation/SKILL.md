# Skill: service-generation

## Purpose

Generate service classes that sit between chopper/GraphQL clients and the repository layer. A service wraps one or more chopper services (or a GraphQL client), calls endpoints, handles retries, interprets specific error status codes into typed `Failure` values, and returns `Payload<T>`.

---

## File Structure

```
lib/infrastructure/<feature>/service/
├── i_<feature>_service.dart            ← abstract interface
├── <feature>_service.dart              ← implementation
├── chopper/                            ← chopper services (see chopper-generation skill)
└── graphql/                            ← .graphql files (see graphql-generation skill)
```

---

## Interface

The interface defines the public contract. It uses `Payload<T>` as the return type and only references infrastructure models.

```dart
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/infrastructure/<feature>/models/<response_model>.dart';

abstract interface class I<Feature>Service {
  Future<Payload<ResponseModel>> getData({required String id});
}
```

---

## Implementation — REST (Chopper)

```dart
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/infrastructure/core/service/base_service.dart';
import 'package:isbapp/infrastructure/<feature>/models/<response_model>.dart';
import 'package:isbapp/infrastructure/<feature>/service/chopper/<feature>_chopper_service.dart';
import 'package:isbapp/infrastructure/<feature>/service/i_<feature>_service.dart';

@LazySingleton(as: I<Feature>Service)
class <Feature>Service with BaseService implements I<Feature>Service {
  final <Feature>ChopperService _service;

  const <Feature>Service(this._service);

  @override
  Future<Payload<ResponseModel>> getData({required String id, int level = 1}) async {
    try {
      final Response<ResponseModel> response = await _service.getData(id: id);
      if (await needsRetry(response, level)) {
        return getData(id: id, level: level + 1);
      }
      return handleResponse(response);
    } on Exception catch (e, stacktrace) {
      return handleException(e, stacktrace);
    }
  }
}
```

---

## Implementation — GraphQL

GraphQL services extend `BaseGraphQLService` (or mix in `BaseService` and use `needsRetryGraphQL`). See the **graphql-generation** skill for the full pattern.

---

## Method Structure

Every service method follows this skeleton:

```dart
Future<Payload<T>> doSomething({required params, int level = 1}) async {
  try {
    // 1. Call chopper service
    final Response<T> response = await _service.doSomething(...);

    // 2. (Optional) Interpret specific status codes BEFORE retry
    if (response.statusCode == 403) {
      return Payload.failure(Failure.forbiddenError(message: "403"));
    }

    // 3. Retry on 401
    if (await needsRetry(response, level)) {
      return doSomething(level: level + 1, ...);
    }

    // 4. Delegate to handleResponse
    return handleResponse(response);
  } on Exception catch (e, stacktrace) {
    return handleException(e, stacktrace);
  }
}
```

---

## Custom Error Interpretation

Some endpoints require interpreting specific HTTP status codes into typed failures **before** the generic `handleResponse` path:

| Pattern | When to use |
|---------|-------------|
| `response.statusCode == 403` → `Failure.forbiddenError(...)` | Endpoint returns 403 with terms/authorization data in the body |
| `response.statusCode == 404` → `Failure.notFound(...)` | Resource legitimately might not exist (not an error) |
| `response.statusCode == 204` → custom handling | No-content success that needs special treatment |
| Parse `response.bodyString` → domain-specific failure | Error body contains structured data (e.g. missing terms) |

Example — extracting structured error data from a 403:

```dart
if (response.statusCode == 403) {
  final Map<String, dynamic> data =
      json.decode(response.bodyString) as Map<String, dynamic>;
  return Payload.failure(
    Failure.forbiddenError(
      terms: MissingTermsModel.fromJson(data),
      message: "403",
    ),
  );
}
```

---

## BaseService Helpers

The `BaseService` mixin provides:

| Method | Purpose |
|--------|---------|
| `handleResponse(response)` | Maps successful response to `Payload.success`, failures to `Payload.failure` with `Failure.serverError` |
| `handleResponse(response, dataOverride: ...)` | Same, but replaces the body (e.g. after aggregating paginated results) |
| `handleConvertedResponse(response, convert)` | Maps the body through a converter function before wrapping |
| `handleBodyStringResponse(response)` | Returns `Payload<String>` from `response.bodyString` |
| `needsRetry(response, level)` | Returns `true` for 401 status codes up to 3 retries |
| `handleException(exception, stacktrace)` | Catches `SocketException` as timeout, everything else as server error |
| `extractTimeToLive(response)` | Reads `cache-control: max-age=` header, defaults to 30 minutes |

---

## Registration

See the **dependency-injection** skill for the full DI contract. For services:

- Annotate with `@LazySingleton(as: I<Feature>Service)` — binds the implementation to its interface
- Injectable resolves the chopper service dependency automatically from the constructor parameter
- Use `@InjectableEnv.online` only when there is a corresponding offline implementation
- After adding or modifying the annotation run `python3 scripts/build.py getit`

---

## Rules

| Rule | Detail |
|------|--------|
| Return type | Always `Future<Payload<T>>` |
| Retry | Include `int level = 1` parameter; call `needsRetry` before `handleResponse` |
| Custom errors first | Check specific status codes **before** calling `needsRetry` |
| Constructor | `const` when the service has only final chopper-service fields |
| Mixin | Use `with BaseService` (not `extends`) |
| Multiple chopper services | Name fields `_serviceV1`, `_serviceV2`, etc. |
| No business logic | Translate responses to `Payload` — do not implement domain rules |
| Pagination | Aggregate pages recursively, then return a single `Payload` with combined data |

---

## What NOT to Do

- Do not catch errors silently — always use `handleException`
- Do not return raw `Response` — always wrap in `Payload`
- Do not add domain logic (validation, mapping to domain entities) — that belongs in the repository
- Do not import presentation or application layer classes
- Do not skip the `level` retry parameter on methods that call the network

