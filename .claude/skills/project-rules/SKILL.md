---
name: project-rules
description: >-
  Validate coding standards and conventions for Channels.Flutter.Components
  using repository-defined linting, static analysis rules, and test conventions.
tools: []
---

## Purpose

Use this skill to verify that code changes follow this repository's coding standards and conventions.

This skill is about **how code is written** (style, structure, conventions), not feature behavior correctness.

---

## Canonical Rule Sources

Treat these files as source of truth, in this order:

1. `analysis_options.yaml`
2. `.claude/instructions/effective-dart.instructions.md`
3. `.claude/instructions/*-layer-rules.instructions.md`
4. `.claude/instructions/presentation-and-atomic-design.instructions.md`
5. `.claude/instructions/test-conventions.instructions.md`
6. `scripts/static_code_analysis/static_code_analysis.py`
7. `scripts/static_code_analysis/rules/*.py`

If rules conflict, prefer the **more specific and enforced** rule (usually a static-analysis rule over generic style guidance).

### Repository hard style overrides (must enforce)

Apply these as strict project conventions for all Dart changes:

- **Strings**: use double quotes for all strings in code.
- **Directive exceptions**: single quotes are allowed only in `import`, `part`, and `part of` directives.
- **Typing**: every variable declaration must be explicitly typed. Do not use `var` and do not omit the type.
- **Comments**: keep comments minimal. Do not add explanatory inline comments or method/property/function doc comments.
- **Allowed comment exceptions**: analyzer/lint ignore directives, legal/license headers, and short rationale comments only when logic is non-obvious.
- **Widget file declarations**: do not declare additional classes in widget/feature files. Allowed exceptions: private `State` classes (for `StatefulWidget`) and generated `part` artifacts.

Treat violations of these overrides as `violation` findings, not `risk`.

---

## Quick Standards Survey (Project-Specific)

### Analyzer and formatter baseline

From `analysis_options.yaml`:

- base config includes `package:lint/analysis_options.yaml`
- formatter width is `120`
- explicit typing is strongly preferred (`always_specify_types`, `always_declare_return_types`, `type_annotate_public_apis`)
- all variable declarations must use explicit types (including local variables; no `var` and no omissions of types)
- package imports are required (`always_use_package_imports`)
- avoid relative imports in `lib` (`avoid_relative_lib_imports`)
- generated/build/platform files are excluded from analyzer scope

### Effective Dart conventions

From `.claude/instructions/effective-dart.instructions.md`:

- naming and file/folder casing follow Effective Dart
- use curly braces for flow control
- avoid unnecessary comments and avoid method-level doc comments except narrow exceptions
- prefer double quotes for general strings
- code should be self-documenting; avoid comment-heavy files

### Layer and UI conventions

From `.claude/instructions/*` and static rules:

- presentation follows atomic design constraints
- no direct low-level UI widgets where project wrappers are required (`Text` -> `IsbText`, `Image` -> `IsbImage`, `SvgPicture` wrapper rules)
- design tokens are required in presentation for sizes/padding/radius (no hardcoded values)

### Test conventions

From `.claude/instructions/test-conventions.instructions.md`:

- test folder placement and test type must match layer intent
- UAT uses driver-builder pattern and `Given/When/Then`
- domain value-object/entity-business-logic tests and feature goldens have distinct patterns and expectations
- only these generated test categories are allowed:
  - `test/user_acceptance_tests/<feature>/`
  - `test/presentation/<feature>/`
  - `test/domain/<feature>/value_objects/`
  - `test/domain/<feature>/entities/` (when entity business logic exists)
- forbidden generated test categories:
  - `test/domain/**/use_cases/**`
  - `test/application/**`
  - `test/infrastructure/**`

### Enforced static checks (high signal)

From `scripts/static_code_analysis/static_code_analysis.py` and its rules:

- quote policy is split:
  - normal code strings: double quotes
  - `import`, `part`, and `part of` directives: single quotes
- avoid direct event bus subscription and event bus field injection in cubits (see dependency-injection skill)
- avoid direct `Uuid` usage; use `IsbGuid`
- do not import/use share plugin directly; use `IShareProvider`
- domain entity classes should implement `Equatable`
- `log(...)` calls should be followed by an empty line
- presentation atomic design and hardcoded-size constraints are enforced

---

## Validation Procedure

### 1. Scope and classify changed files

- identify changed files
- classify by area: `lib/`, `test/`, scripts/config/docs
- ignore generated files and excluded paths from `analysis_options.yaml`

Only validate new or modified code in the diff.  
Do not flag pre-existing issues unless they are worsened by the change.

### 2. Validate analyzer/linter conformance

For changed Dart files, verify:

- imports and typing conventions from `analysis_options.yaml`
- formatting assumptions (120 width, formatter-friendly style)
- no newly introduced analyzer errors for enforced error-level rules

Infer analyzer violations based on rules defined in `analysis_options.yaml` and known lint behavior.

Focus on obvious violations introduced in the diff rather than attempting full analyzer parity.

### 3. Validate repository style conventions

Check changed code against:

- `.claude/instructions/effective-dart.instructions.md`
- quoting split rule:
  - double quotes for strings
  - single quotes only for `import`, `part`, and `part of` directives
- explicit typing rule:
  - all variables are explicitly typed
  - do not use `var`, even for initialized locals
- naming and comment discipline
  - do not add method/property/function doc comments (`///`) unless an explicit exception applies
  - avoid section-banner comments and placeholder comments in generated files

### 4. Validate static custom rules

Map changed code to relevant checks in `scripts/static_code_analysis/rules/`.

Especially verify:

- UI wrapper usage (`IsbText`, `IsbImage`, SVG rules)
- no hardcoded presentation sizes/padding/radius where tokens are required
- event bus and share-provider restrictions
- `Equatable` and logging conventions
- atomic design composition constraints in presentation

### 5. Validate layer-specific conventions

Using `.claude/instructions/*_layer_rules.instructions.md` and presentation rules:

- ensure changed code follows conventions expected by its layer
- flag style/convention drift even if code compiles

### 6. Validate test conventions (if tests changed)

Using `.claude/instructions/test-conventions.instructions.md`:

- directory placement and test type (`test`, `testWidgets`, `testGoldens`)
- UAT driver pattern and required structure
- domain value-object/entity-business-logic and feature-golden expectations
- allowed/forbidden test-category paths from `.claude/instructions/test-conventions.instructions.md`

---

## Decision Rules

Classify findings as:

- **violation**
  - breaks an enforced analyzer/static rule
  - breaks an explicit MUST/DO-NOT project convention
- **risk**
  - technically passes but introduces convention drift, readability issues, or brittle patterns
- **note**
  - non-blocking improvement suggestion
- Do not flag issues based on personal preference or stylistic interpretation unless backed by a defined rule source.

Prefer evidence-backed findings. Avoid speculative style opinions.

If a rule is enforced by static analysis or analyzer configuration, it must be treated as a violation.

Guidelines and conventions without enforcement should be treated as risk unless clearly critical.

---

## Output Contract

Return structured findings:

- `violations`: []
- `risks`: []
- `notes`: []

Each finding should include:

- description
- file reference
- rule source reference (exact file/rule)
- suggested remediation

If no issues are found, state:

- `No coding standards or convention violations found in changed scope.`

---

## Optional Execution Hints

When execution is available, these commands provide parity with repository checks:

```bash
python3 scripts/static_code_analysis/static_code_analysis.py
python3 scripts/static_code_analysis/static_code_analysis.py lint
```

Use command output as supporting evidence, not as the only reasoning source.
