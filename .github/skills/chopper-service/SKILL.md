---
name: chopper-service
description: Create or update Chopper REST service definitions in Infrastructure (`*_chopper_service.dart`). Use when implementing endpoint methods (`@GET/@POST/...`) after contract resolution, including service-file selection, contract-to-annotation mapping, and chopper code generation.
argument-hint: "<feature_name> [path_or_url_or_keyword] [method_or_operationId]"
user-invokable: true
---

# Chopper Service

Implement Chopper abstract service methods for REST endpoints.

## Required handoff

Before editing a service, require:

- normalized endpoint path: `/{domain}/{version}/{endpoint...}`
- HTTP method + operationId
- resolved contract file path
- path/query/header parameter specs with required/optional flags
- request body DTO type (if present)
- response DTO type + shape (`object` or `array`)
- deprecation flag

## Workflow

0. Validate DTO readiness

- Run the DTO readiness gate checks before selecting or editing a service file.
- If DTOs are not ready, ask user, suggest running `api-models` and resume only after DTO verification passes.

0.5 Confirm DTO selection with user (when ambiguous)

- If request/response DTO selection is ambiguous or inferred, call `ask_questions` once with:
  - resolved endpoint + method
  - selected request DTO (or `none`)
  - selected response DTO + shape
  - short rationale for the mapping
- Proceed with service edits only after user confirmation.

1. Select target service file

- Inspect existing files under `lib/infrastructure/<feature>/service/chopper/`.
- Reuse an existing service when the endpoint belongs to the same resolved contract.
- If the user specifies a target file, use that file.
- If multiple existing services are valid, use `ask_questions` once.
- Create a new service only when no existing service fits.

2. Choose annotation path style

- If `@ChopperApi(baseUrl: "/<domain>/<version>")` matches the endpoint prefix, use a relative method path.
- If `baseUrl` is absent or does not match, use the full endpoint path in the method annotation.
- Keep path style consistent with existing methods in the same file.

3. Add or update endpoint method

- Use the correct HTTP annotation: `@GET`, `@POST`, `@PUT`, `@PATCH`, or `@DELETE`.
- Map contract parameters and body to Chopper annotations.
- Use `includeNullQueryVars: false` for optional query params when the file already follows this convention.
- Use `listFormat: ListFormat.repeat` when query arrays must be sent as repeated keys.
- Return `Future<Response<T>>` where `T` matches the DTO from `api-models`.
- Skip deprecated endpoints by default. If explicitly requested, implement and warn that the endpoint is deprecated.

4. Preserve service class conventions

- Keep `part '../../../copilot/skills/chopper-service/<feature>_chopper_service.chopper.dart';`.
- Keep `Type get definitionType => runtimeType;`.
- Keep static factory `create([ChopperClient? client]) => _$...`.
- Add only required model imports.

5. Regenerate Chopper output

- Use [`buildrunner-code-generation`](../buildrunner-code-generation/SKILL.md) with `chopper`.

## Contract-to-Chopper mapping

| Contract element | Chopper mapping |
|---|---|
| path parameter | `@Path("...") required` |
| query parameter | `@Query("...")` (nullable when optional) |
| header parameter | `@Header("...")` |
| requestBody schema ref | `@Body() required <RequestDto>` |
| response object schema | `Future<Response<Model>>` |
| response array schema | `Future<Response<List<Model>>>` |

## Quality checklist

- Method and path match the resolved contract endpoint.
- Required/optional parameter mapping is correct.
- Request and response DTO types match `api-models` handoff.
- DTO readiness gate passed (`Exists`, `Parsable`, `Registered`, `Generated`) before service edits.
- Existing-vs-new service decision follows contract-based routing.
- Chopper generation completes successfully.