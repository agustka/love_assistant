# Skill: chopper-generation

## Purpose

Generate Chopper service classes that define HTTP endpoints for the infrastructure layer. Chopper services are abstract classes with annotated methods that map directly to OpenAPI paths.

---

## Code Generation Command

```bash
python3 scripts/build.py chopper
```

Run this after creating or modifying any chopper service file. It generates the corresponding `.chopper.dart` part file.

---

## File Structure

```
lib/infrastructure/<feature>/service/chopper/<name>_chopper_service.dart
```

Each chopper service also requires a generated part file:

```
lib/infrastructure/<feature>/service/chopper/<name>_chopper_service.chopper.dart
```

---

## Canonical Template

```dart
import 'package:chopper/chopper.dart';
import 'package:isbapp/infrastructure/<feature>/models/<response_model>.dart';
import 'package:isbapp/infrastructure/<feature>/models/requests/<request_model>.dart';

part '<name>_chopper_service.chopper.dart';

@ChopperApi(baseUrl: "<base-path>")
abstract class <Name>ChopperService extends ChopperService {
  static <Name>ChopperService create([ChopperClient? client]) =>
      _$<Name>ChopperService(client);

  @GET(path: "/<resource>")
  Future<Response<ResponseModel>> getResource();
}
```

---

## Rules

| Rule | Detail |
|------|--------|
| `part` directive | Always declare `part '<filename>.chopper.dart';` |
| `@ChopperApi(baseUrl:)` | Set to the common path prefix from the OpenAPI spec (e.g. `/payments/v1`) |
| Class | `abstract class`, extends `ChopperService` |
| Factory | `static <Name>ChopperService create([ChopperClient? client]) => _$<Name>ChopperService(client);` |
| HTTP methods | Use `@GET`, `@POST`, `@PUT`, `@PATCH`, `@DELETE` with `path:` relative to `baseUrl` |
| Path params | `@Path("name") required String name` |
| Query params | `@Query("name") Type? name` — nullable unless always required |
| List query params | Add `listFormat: ListFormat.repeat` and `includeNullQueryVars: false` to the annotation |
| Body | `@Body() required RequestModel body` |
| Headers | `@Header("X-Header-Name") required String headerName` or with a default value |
| Return type | `Future<Response<ModelType>>` — use `void` for no-content responses |
| Comments | Keep comments minimal; do not add per-method doc comments unless explicitly required by a consuming tool/process |

---

## Naming

- File: `<feature>_chopper_service.dart` (snake_case)
- Class: `<Feature>ChopperService` (PascalCase)
- One service per logical API group (maps to an OpenAPI tag or path prefix)
- If versioned: `<feature>_v2_chopper_service.dart` → `<Feature>V2ChopperService`

---

## What NOT to Do

- Do not write serialization logic — that belongs in the model converter
- Do not add business logic or error handling in the chopper service
- Do not manually create the `.chopper.dart` file — run the build command
- Do not import domain layer classes
- Do not add `@override Type get definitionType => runtimeType;` — this is legacy and not needed in newer services
- Do not add verbose comments or section banners in service files

---

## Integration — Service Module

Every chopper service is wired into the DI container via a **service module** that lives in the same `service/` directory:

```
lib/infrastructure/<feature>/service/<feature>_service_module.dart
```

### Service Module Template

```dart
import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:isbapp/infrastructure/core/auth/interceptors/auth_request_interceptor.dart';
import 'package:isbapp/infrastructure/core/service/interceptors/rest_logging_interceptor.dart';
import 'package:isbapp/infrastructure/<feature>/models/converter/<feature>_model_converter.dart';
import 'package:isbapp/infrastructure/<feature>/service/chopper/client/i_<feature>_client_provider.dart';
import 'package:isbapp/infrastructure/<feature>/service/chopper/<feature>_chopper_service.dart';
import 'package:isbapp/setup.dart';

@module
abstract class <Feature>ServiceModule {
  <Feature>ChopperService get <feature>ChopperService {
    final ChopperClient chopper = ChopperClient(
      client: getIt<I<Feature>ClientProvider>().getClient(),
      baseUrl: Uri.parse(FlavorConfig.instance.variables.isbHost),
      services: [
        <Feature>ChopperService.create(),
      ],
      converter: <Feature>ModelConverter(),
      interceptors: [
        getIt<AuthRequestInterceptor>(),
        getIt<IRestLoggingInterceptor>(),
      ],
    );

    return chopper.getService<<Feature>ChopperService>();
  }
}
```

### Key Points

| Element | Detail |
|---------|--------|
| `@module` | Marks the class as an injectable module |
| `abstract class` | Injectable generates a concrete subclass |
| Getter per service | One getter per chopper service; returns the typed service from the client |
| `client:` | Resolved via a feature-specific `IClientProvider` — abstracts the HTTP client for online/offline switching |
| `baseUrl:` | Usually `FlavorConfig.instance.variables.isbHost`; some features use a different host |
| `converter:` | The feature's model converter (handles JSON ↔ model mapping) |
| `interceptors:` | Typically `AuthRequestInterceptor` + `IRestLoggingInterceptor` |

### Multiple Chopper Services in One Module

When a feature has multiple chopper services (e.g. versioned endpoints), add one getter per service in the same module. They can share the same converter and client provider:

```dart
@module
abstract class CardsServiceModule {
  DebitCardsChopperService get debitCardsChopperService { ... }
  CreditCardsChopperService get creditCardsChopperService { ... }
  SplitPaymentsChopperService get splitPaymentsChopperService { ... }
}
```

### Client Provider Interface

Each feature defines a client provider interface at:

```
lib/infrastructure/<feature>/service/chopper/client/i_<feature>_client_provider.dart
```

```dart
import 'package:http/http.dart' as http;

abstract class I<Feature>ClientProvider {
  http.Client getClient();
}
```

This is implemented by both an online provider (real HTTP) and an offline provider (test stubs).

