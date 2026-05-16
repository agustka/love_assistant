# UAC Generation Specification (`uac.yaml`)

Use `.claude/specs/uac.yaml` to provide the UAC Creator agent with feature context and design reference.

---

## Purpose

`uac.yaml` supplies the UAC Creator with the information needed to generate comprehensive acceptance criteria. It feeds into the UAC Creator agent, which produces `.claude/specs/bdd.md` (structure: Work Type, User Story, Acceptance Criteria) for downstream pipeline execution.

---

## Required Structure

```yaml
feature_name: string
  # Name of the feature (e.g., "Foreign Recipient Currency Selection")

description: string (multi-line)
  # User story and feature context
  # Format: As a <type of user>, I want <some goal>, so that <some reason>

design_reference: string
  # URL (Figma, screenshot link, etc.) or relative path to design asset

scope: array of strings
  # Feature directory/directories this UAC applies to
  # Example: ["lib/presentation/transfers/", "lib/domain/transfers/"]
```

Minimal example:

```yaml
feature_name: "Foreign Recipient Currency Selection"

description: |
  As a user creating or editing a foreign recipient,
  I want to select the currency when entering the recipient's bank details,
  so that I can ensure the correct currency is associated with the recipient.

design_reference: "https://figma.com/..."

scope:
  - "lib/presentation/transfers/foreign_recipient/"
  - "lib/domain/transfers/"
```

---

## Coverage Checklist

The UAC Creator will automatically generate acceptance criteria covering:

For data-loading features:
- Loading
- Success (with data)
- Success (empty/no content)
- Error
- Refreshing
- Refresh error

For user-triggered operations (submit/update/delete/etc.):
- Operation error (recoverable or blocking, based on severity)

---

## Rules

- `feature_name`: concise, descriptive
- `description`: clear user story in As/I/so format
- `design_reference`: must point to valid design or screenshot
- `scope`: list the feature directories affected by this UAC
- The UAC Creator reads this file and produces `.claude/specs/bdd.md`
- Do not edit `.claude/specs/bdd.md` directly for new UACs; always use `uac.yaml` as input
