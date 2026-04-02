---
name: api-models
description: Create or update Infrastructure DTO model files and feature model converters from resolved OpenAPI handoff data. Use for *_model.dart, @JsonSerializable mapping, and Chopper BaseConverter registration.
user-invokable: false
---

# Prerequisites
- This skill is setup to work only on macOS
- If the user is on a different platform, the skill should return an error message indicating that it is not supported on their current platform.

# API Models

This skill implements Infrastructure DTOs and converter wiring after contract facts are resolved.

## Ownership boundary

- Owns: DTO model creation/editing and feature converter updates.
- Does not own: contract discovery/path resolution (use `read-api-contract` first).
- Does not own: endpoint method definitions (use `chopper-service`).

## Execution model

- Use subagents for discovery and isolated DTO edits when orchestrating larger workflows.
- Keep converter merge decisions, code generation, and final validation in the main agent.

## Required handoff

Before modeling, require:
- feature name (`<feature>`)
- normalized full path (`/{domain}/{version}/{endpoint...}`)
- source locator form (full path, full URL, or host + endpoint where host can be any environment base URL or a value from `FlavorConfig.instance.variables.<some_variable>`)
- resolved contract file path
- endpoint + method
- resolved model name (`provided` by caller or `generated` by `read-api-contract`)
- request/response schema refs
- flattened field specs (required, enum, nested refs)
- All fields in models should be nullable
- resolved response shape (`array` vs `object`)

If handoff is incomplete, run [`read-api-contract`](../read-api-contract/SKILL.md).

If URL parts are unclear or incomplete, use `ask_questions` once to clarify before implementation.
If model name is missing, request `read-api-contract` handoff refresh so model naming is explicit before editing files.

## Workflow

1. Create or edit DTO model files
- Location: `lib/infrastructure/<feature>/models/`
- Naming: `*_model.dart`; request DTOs typically under `models/requests/`
- Use the resolved model name from handoff (provided or generated) for new DTO class/file naming.
- Use `@JsonSerializable()`, `part '../../../copilot/skills/api-models/<file>.g.dart';`, `fromJson`, `toJson`
- Use `@JsonKey(name: "...")` only when API keys differ from Dart names
- For enum fields, always model them as nullable strings in DTOs
- Keep DTOs free of domain logic

2. Keep model files clean
- Do not add `//` comments
- Do not add `///` doc comments
- Keep content limited to fields, constructors, and JSON mapping

3. Create or update converter
- Prefer updating existing feature converter in `lib/infrastructure/<feature>/models/converter/`
- Converter must extend `JsonConverter` and use the `BaseConverter` mixin
- Register every response model type in `conversions`
- Keep `convertResponse` using `convertToCustomObject`

4. Match response shape exactly
- `type: array` → list response and matching converter mapping
- `type: object` → object DTO response
- Do not invent wrapper DTOs unless the contract defines them

5. Run generation
- Use buildrunner-code-generation skill with json parameter
- Run generation synchronously in the main agent when orchestrating prompt workflows.

## Quality checklist

- DTO fields match contract; enum fields are intentionally represented as nullable strings (`String?`) in DTOs.
- Model name consistency is preserved across DTO file/class and converter mapping.
- Nested referenced models exist and are wired.
- Converter registrations cover all response model types.
- Array/object handling is contract-accurate.