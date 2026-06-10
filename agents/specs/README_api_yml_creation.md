# Infrastructure Contract Specification (`api.yaml`)

`api.yaml` is the infrastructure contract source for three modes:

- API/network mode: OpenAPI slice (endpoints and schemas)
- Adapter mode: non-API infrastructure contracts (shared preferences, platform channels, device services, SDK bridges)
- Supabase mode: Supabase backend contracts — database tables/columns/RLS, migrations, and Edge Functions — plus the Dart client adapter that talks to them

Use one `api.yaml` per feature and keep it minimal.

The infrastructure layer owns **all** Supabase work (database schema + migrations under `supabase/migrations/`, and Edge Functions under `supabase/functions/`), so any Supabase-backed change must declare it here. A feature that reads or writes a Supabase table must declare that table and whether a migration is required to create or alter it — never assume the table already exists.

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

## Mode C - Supabase backend (database + Edge Functions)

Use when the change reads or writes a Supabase table, needs a schema/migration change, or adds/changes an Edge Function. Declare the backend objects (owned and deployed by the infrastructure layer) alongside the Dart client adapter (Mode B shape) that talks to them.

Rules:

- Declare every table the feature touches: columns, types, key/unique constraints, foreign keys, and the intended Row Level Security policy. Never assume a table already exists.
- Set `migration: required` on any table the feature must create or alter — the infrastructure layer produces the migration under `supabase/migrations/`.
- Declare every Edge Function the feature adds or changes: trigger, behavior, and `verify_jwt`.
- Keep the Dart client adapter under `adapters` (same shape as Mode B), referencing the table it backs.

Minimal example:

```yaml
mode: supabase
info:
  title: Partner Profile Supabase Contract
  version: 1.0.0

supabase:
  tables:
    partner_profiles:
      migration: required
      columns:
        customer_id: { type: uuid, primary_key: true, references: auth.users.id, on_delete: cascade }
        profile_data: { type: jsonb, not_null: true, default: "{}" }
        created_at: { type: timestamptz, not_null: true, default: now() }
        updated_at: { type: timestamptz, not_null: true, default: now() }
      rls:
        - select/insert/update only own row (auth.uid() = customer_id)
  functions: {}   # e.g. agent_chat: { trigger: http, verify_jwt: false, behavior: [...] }

adapters:
  supabase_partner_profile_remote_store:
    backing_store: { table: partner_profiles }
    operations:
      load_partner_profile:
        input: AuthenticatedCustomer
        output: RemotePartnerProfileResult
        errors: [unauthenticated, unavailable, malformed_profile_data]

models:
  AuthenticatedCustomer:
    type: object
    required: [customer_id]
    properties:
      customer_id: { type: string, format: uuid }
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
