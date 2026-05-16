Create or update Infrastructure API models for `$ARGUMENTS` using skill orchestration:
- use `read-api-contract` for deterministic contract discovery and schema extraction
- use `api-models` for DTO/converter implementation
- run JSON code generation

Subagent orchestration policy (recommended):
- Use subagents for discovery and isolated DTO edits.
- Keep code generation and final validation in the main agent.

# Input Requirements

Parse:
1. **Feature name** in snake_case (`savings_goals`, `credit_limits`)
2. **Contract locator**: one of
	- full API path under host (`/{domain}/{version}/{endpoint...}`)
	- full URL (for example `https://<environment-host>/{domain}/{version}/{endpoint...}`)
	- host + endpoint where host may be any environment base URL or a value from `FlavorConfig.instance.variables.<some_variable>`
	- keyword/file hint
3. **Optional model name** in Dart class format (`CreditCardLoyaltyRewardModel`)

If the optional model name is omitted, resolve/generate it via `read-api-contract` and pass it forward to implementation.

If URL/locator details are missing or ambiguous, ask once to clarify before continuing.

# Workflow

## Step 1 — Resolve contract facts first (use subagent)

Invoke `read-api-contract` skill and obtain a handoff package containing at minimum:
- normalized full path (`/{domain}/{version}/{endpoint...}`)
- resolved YAML file path in `api_contracts/`
- endpoint + method
- resolved model name (provided by user or generated deterministically)
- request/response schema refs
- flattened fields (required, nullable, enum, nested refs)
- response body shape (object vs array)
- example payloads and deprecation markers

Always resolve these facts fresh from contracts; do not reuse stale artifacts.

## Step 2 — Implement DTO models + converter (use subagent)

Invoke `api-models` skill with the Step 1 handoff and the feature name.
- Create/update only the required files under `lib/infrastructure/<feature_name>/models/`.
- Update existing converter in `models/converter/` when present.
- When request and response schemas are independent, run those edits in parallel subagents.
- If a subagent creates conflicting edits, keep converter updates in the main agent as the final merge point.

## Step 3 — Run code generation

Use the project script only:
```bash
python3 scripts/build.py json
```
Run synchronously and wait for completion in the main agent (not a subagent).

## Step 4 — Return a compact handoff

Report:
- changed files
- any unresolved schema ambiguities
- model name used (provided vs generated)
- confirmation that array/object response shape matches converter + model mapping
