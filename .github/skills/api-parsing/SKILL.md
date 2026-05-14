---
name: api-parsing
description: >-
  Parse OpenAPI (specs/api.yaml) slices to extract endpoints, schemas, and
  parameters needed for infrastructure code generation.
tools: []
---

## Purpose

Use this skill to read and interpret OpenAPI 3.x specification slices provided in `specs/api.yaml`.

The goal is to extract the structural information required to generate models, services, and repositories — nothing more.

---

## Input

A single file: `specs/api.yaml` (OpenAPI 3.0 or 3.1 format).

The file may be a **slice** — a subset of a larger API contract containing only the paths and schemas relevant to the current feature.

---

## Parsing Procedure

### 1. Identify paths

For each entry under `paths`:

| Extract | Location |
|---|---|
| HTTP method | key under the path (`get`, `post`, `put`, `patch`, `delete`) |
| Operation ID | `operationId` |
| Path parameters | `parameters` with `in: path` |
| Query parameters | `parameters` with `in: query` |
| Header parameters | `parameters` with `in: header` |
| Request body | `requestBody.content.application/json.schema` |
| Success response | `responses.2xx.content.application/json.schema` |
| Error responses | `responses.4xx` / `responses.5xx` |

### 2. Resolve schemas

For each `$ref` encountered:

- Follow the reference to `components.schemas.<Name>`
- Record the schema name, type, and properties
- Recursively resolve nested `$ref` values
- Track `required` fields, `enum` values, `nullable`, and `format`

### 3. Classify schemas

| Classification | Criteria |
|---|---|
| Request model | Referenced by a `requestBody` |
| Response model | Referenced by a success response |
| Shared model | Referenced by both or by other schemas |
| Enum | Schema with `type: string` and `enum` list |
| Wrapper / envelope | Schema whose sole purpose is to wrap a `data` or `items` field |

### 4. Extract metadata

From the top-level spec and each operation, note:

- `servers[].url` — base URL per environment
- `security` — authentication scheme(s)
- `tags` — grouping hints for service boundaries
- `x-*` extensions — custom metadata (caching hints, streaming markers)

---

## Output

Produce a structured summary containing:

```yaml
endpoints:
  - path: /example/{id}
    method: GET
    operationId: getExample
    pathParams: [id]
    queryParams: []
    headerParams: []
    requestBody: null
    successResponse: ExampleResponse
    errors: [404, 500]

schemas:
  - name: ExampleResponse
    classification: response
    properties:
      - name: id
        type: string
        required: true
      - name: amount
        type: number
        format: double
        required: false
        nullable: true

enums:
  - name: StatusType
    values: [ACTIVE, INACTIVE, PENDING]

auth:
  scheme: bearer

baseUrls:
  test: https://api.test.example.com
  production: https://api.example.com
```

---

## Decision Rules

- If a `$ref` cannot be resolved within the file → record as a **gap**
- If an endpoint has no `operationId` → derive one from method + path (`get /accounts/{id}` → `getAccountsById`)
- If `requestBody` or response references an `allOf` / `oneOf` / `anyOf` → flatten and note composition strategy
- If a schema uses `additionalProperties: true` → flag as dynamic / map type
- If pagination parameters or response wrappers are present → note pagination pattern

---

## Constraints

- Do not invent endpoints, fields, or types not present in the spec
- Do not infer business behavior from naming conventions
- Do not skip unresolved references — always surface them as gaps
- Treat the spec as the single source of truth for the infrastructure layer

