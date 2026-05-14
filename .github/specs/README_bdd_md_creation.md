# BDD Specification (bdd.md)

## Required Structure

### Work Type

`bug` | `refactor` | `feature`

The work type determines how the pipeline processes this specification.

### User Story
- As a <type of user>, 
- I want <some goal>,
- so that <some reason>.

### Acceptance Criteria
- Given <some context>
- When <some action is taken>
- Then <some observable outcome occurs>

Keep ACs clear and focused. Cover the relevant scenarios (success, errors, edge cases). Include everything that the user should see and experience.

### Supporting Context (optional)
Add anything that helps clarify the feature:

- Services involved (if any)
- How this interacts with existing features
- Constraints or rules
- Anything that would otherwise cause confusion

---

## Work Type Guidelines

### `feature`

Classic BDD. Describe the new or updated behavior from the user's perspective. ACs define what to build.

### `refactor`

No new user-facing behavior. The user story describes the **technical goal** (e.g., "As a developer, I want to consolidate duplicate repository logic, so that maintenance is simpler").

ACs describe **existing behavior that must continue to work** — they serve as the regression baseline. The pipeline will run existing tests against the changed code, not generate new features.

Example:
- Given the user has an active session
- When they navigate to the transfer page
- Then the page loads with their account list (existing behavior — must not break)

### `bug`

Describe the **broken scenario** and the **expected correct behavior**. The user story explains what is failing. ACs describe what should happen after the fix.

Example:
- Given the user submits a transfer with a valid IBAN
- When the backend returns a successful response
- Then the confirmation page should display (currently shows an error instead)

Include the **defect location** in Supporting Context if known (e.g., "The bug is in `TransferFormCubit.submit` — it does not handle the success response correctly").

---

Keep it simple. If something matters for behavior, include it. If it doesn't, leave it out.
