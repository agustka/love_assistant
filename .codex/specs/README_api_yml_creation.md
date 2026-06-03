# Infrastructure Contract Specification (`api.yaml`)

`api.yaml` is the infrastructure contract source for two modes:

- API/network mode: OpenAPI slice (endpoints and schemas)
- Adapter mode: non-API infrastructure contracts (shared preferences, platform channels, device services, SDK bridges)

Use one `api.yaml` per feature and keep it minimal.

---

## Mode A - API/network (OpenAPI)

Include only:

- Relevant endpoint paths
- Request/response schemas
- Referenced enums/models used by those schemas

Rules:

- Resolve external `$ref` values (no unresolved cross-file references)
- Remove unrelated endpoints/models
- Keep examples short

Minimal example:

```yaml
openapi: 3.0.3
info:
  title: Profile API Slice
  version: 1.0.0
paths:
  /profile:
    get:
      responses:
        "200":
          description: ok
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Profile"
components:
  schemas:
    Profile:
      type: object
      required: [id, name]
      properties:
        id: { type: string }
        name: { type: string }
```

---

## Mode B - Non-API adapters

Use concise YAML with explicit adapter contracts.

Recommended sections:

- `adapters`: adapter names and capabilities
- `operations`: inputs/outputs/errors per operation
- `models`: payload/state shapes used by operations

Minimal example:

```yaml
adapters:
  shared_preferences:
    operations:
      get_theme:
        output: ThemePref
      set_theme:
        input: ThemePref
        output: void
models:
  ThemePref:
    type: object
    required: [mode]
    properties:
      mode: { type: string, enum: [light, dark, system] }
```

---

## Opt-out / placeholder

When no infrastructure contract is needed, use either:

- Placeholder message, for example: `No infrastructure contract changes needed.`
- `x-layer-opt-out: [infrastructure]`

Placeholders and opt-outs skip infrastructure generation unless contradicted by diffs, failures, or dependency rules.

---

## Token-efficient authoring

- Include only feature-relevant contracts
- Keep descriptions short; prioritize structure over prose
- Reuse small shared models instead of duplicating large payload blocks
- Avoid large sample payloads unless they clarify behavior
