---
name: application-input-handling
description: >-
  Enforce the project policy for form input handling in cubits: accept input
  on every keystroke but defer validation until the user expresses a
  "continue" intent (e.g. tapping Submit, Continue, or Save).
tools: []
---

## Purpose

Use this skill to implement input handling in cubits. The core policy is:

> **Field validation happens when the user expresses the "continue" intent — not while typing.**

This prevents premature error messages that frustrate users who are still composing their input.

This skill covers *when* to validate. The product doctrine in `.claude/instructions/product-decision.md` constrains *what shape* input is allowed to take: every fact about the partner enters through one of four input shapes — a chip selection, a date/number picker, a scoped text field bound to one question and hard-capped around 120 characters, or a confirmation on a system-suggested fact. When a cubit accepts a free-text field, enforce that ~120-character cap; it is an architectural defense against the field becoming a chat, not a styling preference.

---

## The Policy

1. **On every keystroke** — store the raw input value in state and clear the error flag for that field. Do **not** validate. Do **not** show errors.
2. **On continue/submit** — validate fields sequentially. Stop at the first invalid field, set its error flag, and fire an EventBus message to scroll/focus that field.
3. **Errors clear immediately** — when the user types in a field that has an error, the input handler resets that field's error flag to `false`.

---

## Implementation

### State

Each input field has a value object and a companion `bool` error flag. All error flags start as `false`.

```dart
@immutable
class <CubitName>State extends Equatable {
  final PartyNameValueObject name;
  final bool nameError;
  final EmailValueObject email;
  final bool emailError;
  final StreetNameValueObject street;
  final bool streetError;
  final TextValueObject streetNumber;
  final bool streetNumberError;
  final PostNumberValueObject postNumber;
  final bool postNumberError;
  final CityNameValueObject city;
  final bool cityError;
  final Country country;
  final bool countryError;
  final bool busy;
  // ...
}
```

Initial state: all error flags are `false`, all value objects are `.invalid()`.

### Cubit — Input Handler

Store the value and **clear the error flag for that field**:

```dart
void nameChanged(String nameRaw) {
  final PartyNameValueObject name = PartyNameValueObject(nameRaw);
  emit(state.copyWith(name: name, nameError: false));
}

void emailChanged(String email) {
  final EmailValueObject emailValue = EmailValueObject(email);
  emit(state.copyWith(email: emailValue, emailError: false));
}

void streetChanged(String street) {
  final StreetNameValueObject streetValue = StreetNameValueObject(street);
  emit(state.copyWith(street: streetValue, streetError: false));
}
```

**Key rules:**
- Always wrap raw input in its value object
- Always clear the error flag (`xxxError: false`) in the same emit
- Never validate here — just store and clear

### Cubit — Submit/Continue Handler

Validate **sequentially**, stop at the first invalid field, set its error flag, and fire an EventBus message to scroll/focus that field:

```dart
void validateForm() {
  if (state.busy) {
    return;
  }

  if (state.name.isInvalid) {
    emit(state.copyWith(nameError: true));
    getIt<EventBus>().fire(<CubitName>Message.ensureNameVisible);
    return;
  }
  if (state.email.isInvalid) {
    emit(state.copyWith(emailError: true));
    getIt<EventBus>().fire(<CubitName>Message.ensureEmailVisible);
    return;
  }
  if (state.street.isInvalid) {
    emit(state.copyWith(streetError: true));
    getIt<EventBus>().fire(<CubitName>Message.ensureStreetVisible);
    return;
  }
  if (state.country.isInvalid) {
    emit(state.copyWith(countryError: true));
    getIt<EventBus>().fire(<CubitName>Message.ensureCountryVisible);
    return;
  }

  _proceed();
}
```

**Key rules:**
- Guard against double-submit with `if (state.busy) return;`
- Check fields in visual top-to-bottom order
- Set **only** the first invalid field's error flag
- Fire an `ensure<Field>Visible` message so the UI scrolls to it
- `return` immediately — do not continue checking further fields
- If all fields pass, call the proceed/submit method

### Message Enum

Define `ensure<Field>Visible` messages for every validatable field:

```dart
enum <CubitName>Message {
  errorLoadingData,
  errorSubmitting,
  ensureNameVisible,
  ensureEmailVisible,
  ensureStreetVisible,
  ensureStreetNumberVisible,
  ensurePostNumberVisible,
  ensureCityVisible,
  ensureCountryVisible,
}
```

### UI — Error Display

The UI reads the error flag directly — no extra condition needed:

```dart
errorText: state.nameError ? S.of(context).error_invalid_name : null,
```

### UI — Scroll to First Error

The `onMessage` handler focuses/scrolls to the first invalid field:

```dart
case <CubitName>Message.ensureNameVisible:
  _nameFocusNode.requestFocus();
case <CubitName>Message.ensureCountryVisible:
  if (<Keys>.countryInputKey.currentContext != null) {
    Scrollable.ensureVisible(
      <Keys>.countryInputKey.currentContext!,
      curve: Curves.easeInOut,
      duration: 250.milliseconds,
    );
  }
```

Use `requestFocus()` for text fields (which auto-scrolls). Use `Scrollable.ensureVisible()` for non-focusable fields (dropdowns, pickers).

---

## Summary

| Concern | How |
|---|---|
| Store input | Wrap in value object, emit with `xxxError: false` |
| Show errors | Only after submit, only the first invalid field |
| Clear errors | On the next keystroke in that field |
| Scroll to error | Fire `ensure<Field>Visible` via EventBus |
| Validate | Sequential, top-to-bottom, early return |
| Guard double-submit | Check `state.busy` at top of `validateForm()` |

---

## Rules

| Rule | Detail |
|------|--------|
| Never validate on keystroke | The user should not see errors while still composing input |
| Always validate on continue/submit | Every required field must be checked when the user expresses intent to proceed |
| Clear errors on typing | Reset `xxxError: false` in the input handler |
| Sequential validation with early return | Stop at the first invalid field — do not show all errors at once |
| Scroll/focus the first error | Fire an EventBus message; the UI handles scroll |
| Store raw value objects on every keystroke | The cubit always knows the current value for when validation is needed |
| Validation logic lives in the cubit, not the UI | The UI only reads `state.xxxError` to decide whether to show an error string |
| Value objects self-validate | `PartyNameValueObject.isInvalid`, `EmailValueObject.isInvalid` etc. — cubits check these |
| One error flag per field | `bool nameError`, `bool emailError`, etc. — not a global `showValidationMessages` flag |

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Validating on every keystroke from the start | Shows errors while user is still typing — bad UX |
| Validating only in the UI layer | Cubit must own validation to keep logic testable and layer-consistent |
| Showing all errors at once | Overwhelming — validate sequentially and scroll to the first error |
| Using a global `showValidationMessages` flag | Legacy pattern — use per-field error flags instead |
| Using a `didSubmit` flag | Legacy pattern — use per-field error flags instead |
| Using `InputStatus` enum per field | Legacy pattern — use per-field `bool` error flags instead |
| Using `TextEditingController` in the cubit | Controllers are a UI concern; cubit receives `String` values |
| Blocking input based on validation state | Let the user type freely; only gate the continue action |
| Mixing validation patterns in one cubit | Use the per-field error flag pattern consistently |

---

## Reference Implementation

`lib/application/wizard/wizard_cubit.dart` uses a variant of this pattern: it stores raw values on every keystroke, defers validation until the user taps Next, and fires `WizardEvent.missingName` / `WizardEvent.missingPronoun` / `WizardEvent.missingBirthday` to the EventBus so the UI can react. The wizard does not use per-field `bool` error flags on its state class — it surfaces the first error through the EventBus instead. Both patterns are acceptable; pick the one that matches the surrounding feature.
