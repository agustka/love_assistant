---
name: read-api-contract
description: Resolve and extract OpenAPI contract details from the local api_contracts symlink for downstream Infrastructure implementation. Use when given endpoint paths, contract keywords, or when request/response schema details are needed before api-models or chopper-service work.
user-invokable: true
---

# Read API Contract

This skill resolves the correct YAML contract and produces a precise implementation handoff.

## Ownership boundary

- Owns: contract discovery, endpoint resolution, schema extraction, `$ref`/`allOf` expansion.
- Does not own: DTO, converter, or service implementation.

## Repository specifics

- `api_contracts/` is a workspace symlink to sibling repo `../API.Contracts`.
- If either sibling repo `../API.Contracts` or workspace symlink `api_contracts/` is missing, use `ask_questions` once to ask the user whether to run bootstrap script `bash .github/skills/read-api-contract/scripts/bootstrap_api_contracts.sh`; if approved, run it and continue, otherwise stop with a concise blocker.
- Prefer local contract files as source of truth.
- Resolve from contract files on each run; do not read from or reuse `copilot/api_discovery` artifacts.
- If the user explicitly asks for latest contracts, sync sibling repo with:
  `cd ../API.Contracts && git checkout master && git pull && cd -`
- Runtime host/base URL is app-configured (for example via `FlavorConfig.instance.variables.<some_variable>`); do not infer host from `@ChopperApi`.
- Support both service patterns in this repo:
  - full method paths without `@ChopperApi(baseUrl)`
  - segmented methods with `@ChopperApi(baseUrl: "/parties/v1")`

## Input modes

1. Full path mode: preferred `/{domain}/{version}/{endpoint...}`
2. Full URL mode: `https://<environment-host>/{domain}/{version}/{endpoint...}`
3. Host + endpoint mode: host can be any environment base URL or a value from `FlavorConfig.instance.variables.<some_variable>`
4. Keyword mode: feature keyword, endpoint fragment, or contract file hint
5. Optional model name mode: caller may provide a model name override in Dart class format (for example `CreditCardLoyaltyRewardModel`)

Acceptable Examples:
- `FlavorConfig.instance.variables.isbHost/cards/v3/credit-cards-loyalty-rewards`
- `https://api-test.isb.is/cards/v3/credit-cards-loyalty-rewards`
- `https://api.isb.is/cards/v3/credit-cards-loyalty-rewards`

Non acceptable Examples:
- `cards/v3/credit-cards-loyalty-rewards` - missing host


## Workflow

0. Preflight contract availability
- Verify sibling repo exists at `../API.Contracts` and `api_contracts/` exists as a symlink in the workspace root.
- If either is missing, ask once via `ask_questions` whether to run bootstrap script `bash .github/skills/read-api-contract/scripts/bootstrap_api_contracts.sh`.
- If user confirms, run script and continue.
- If user declines, return a concise blocker and do not continue extraction.

1. Normalize the path input
- Accept full path, absolute URL, or host + endpoint input.
- Strip scheme/host when present.
- If host is provided separately (any environment base URL or a value from `FlavorConfig.instance.variables.<some_variable>`), discard host and continue with endpoint path.
- Remove query string and fragment.
- Collapse duplicate slashes.
- Remove trailing slash (except root).
- Enforce leading slash.
- If domain/version/endpoint cannot be determined, use `ask_questions` once before proceeding.

2. Resolve contract file
- Parse normalized path as `/{domain}/{version}/{endpoint...}`.
- Start with `api_contracts/domains/{domain}/*.{version}.yaml` (currently the largest contract area in this repository).
- Match endpoint in `paths` with tie-breakers:
  1) exact literal path key
  2) templated path key (path params)
  3) requested HTTP method when available
  4) deterministic lexical file order
- If still ambiguous, use `ask_questions` to get user confirmation.

Fallback search order:
1) `api_contracts/domains/{domain}/`
2) `api_contracts/presentations/{domain}/`, then `api_contracts/presentations/`
3) `api_contracts/docs/`
4) `api_contracts/channels/`
5) `api_contracts/ai/`
6) `api_contracts/standards/`

3. Resolve model name
- If the caller supplied a model name, pass it through unchanged.
- If omitted, generate a deterministic model name from the resolved endpoint and response/request schema shape, following existing DTO naming conventions.
- Mark model-name provenance in handoff as `provided` or `generated`.

4. Extract endpoint contract
- HTTP method, path, operationId
- path/query/header parameters
- requestBody schema refs
- response schema refs and status codes
- deprecation markers

5. Extract and expand schemas
- fields, required list, nullability, enums
- nested refs
- flattened `allOf` composition
- `example` / `examples` payloads

6. Build downstream handoff package
- resolved contract file path
- endpoint + method
- resolved model name + provenance (`provided` or `generated`)
- request schema refs + flattened fields
- response schema refs + resolved shape (array/object)
- example payloads + deprecation notes

## Related skills
`api-models`, `chopper-service`, `test-data`