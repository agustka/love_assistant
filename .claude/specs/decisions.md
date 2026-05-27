# Sign-up + email-confirmation — implementation decision record

Supporting spec captured from the `feature/agust/login-stuff` wip commit (`9b01964`)
before it was reverted. Its purpose is to let the pipeline regenerate the feature on top
of `origin/main` **without re-litigating the choices that were already made and validated**.

Read this alongside `bdd.md` (behaviour), `layout.md` (surfaces) and `api.yaml`
(infrastructure contract). Where those files said "left to the implementer", the resolved
choice is recorded here.

---

## 1. Integration baseline — regenerate on top of `origin/main`, not local `main`

The wip branch was built on an **older** auth layer. `origin/main` has since rewritten the
auth boundary. Regeneration MUST target `origin/main`'s current shape:

`origin/main` already provides (do NOT remove or duplicate):
- `IAuthRepository`: `subscribeToAuthEvents(...)` (single-listener), `logout()`,
  `signUp()`, `signIn()`, **`hasActiveSession() -> Payload<bool>`**.
- `IAuthService`: `signUpWithEmailAndPassword`, `signInWithEmailAndPassword`, `signOut`,
  **`hasActiveSession() -> Future<bool>`**, `authStateChanges`.
- `OfflineAuthService`: `stubbedUser`, `throwOnSignUp/SignIn/SignOut`,
  **`hasSession` / `throwOnHasActiveSession`**, `emitAuthEvent`, `lastSignUp/SignInCredentials`,
  `didSignOut`. Its `authStateChanges` is already a broadcast `StreamController`.
- `AuthUserModel`: `id`, `email`, `createdAt` only (no `emailConfirmed`, no `isNewUser`).
- `AuthEventType`: `loginStart`, `login`, `logout`, `unlock`, `invalid`.

This feature ADDS the following on top of that baseline (all additive — preserve everything above):
- Repository: `observeAuthEvents() -> Stream<AuthEventType>` (broadcast),
  `recheckEmailConfirmation()`, `resendConfirmationEmail()`.
- Service: `recheckEmailConfirmation()`, `resendConfirmationEmail()`.
- `AuthUserModel`: `emailConfirmed` (`email_confirmed`) and `isNewUser` (`is_new_user`).
- `OfflineAuthService`: the extra stub flags listed in §6.
- `AuthFailureReason` enum (new type — see §5).

---

## 2. What was realized vs scaffolded (so regeneration knows where to resume)

| Layer | Status in the reverted wip |
|---|---|
| Domain (`PasswordStrengthEvaluator` + `PasswordStrength` enum, 4 use cases, `IAuthRepository` additions) | **Real, complete** |
| Application (`SignUpCubit`/state, `EmailConfirmationCubit`/state) | **Real, complete** |
| Infrastructure (`AuthRepository`, `AuthService`, `OfflineAuthService`, `AuthUserModel`, `AuthFailureReason`) | **Real, complete** |
| Presentation (pages, password-strength meter molecule, under-construction organism, routes, landing wiring) | **Not built at all** |
| Localization (new resend strings) | **Not added** — only pre-existing strings were assumed |
| UAT tests, drivers, `AuthBuilder` | **Scaffold only** (`markTestSkipped`, getIt wiring commented out) |
| `password_strength_test.dart` (domain unit test) | **Scaffold only** (real test not written, though the evaluator exists) |
| Golden tests | **Not created** |

So the highest-value preserved work is the domain/app/infra contract below. The UI's genuinely
open visual questions in `layout.md` were never resolved and remain open.

---

## 3. Resolved: password-strength tiering (was an open question in bdd.md)

Lives in the **domain** layer: `lib/domain/core/auth/value_objects/password_strength_evaluator.dart`.
It is a plain `const` evaluator class (NOT a `ValueObject` subclass — it derives an advisory
tier, it does not parse/validate input) with a co-located enum.

```
enum PasswordStrength { tooShort, weak, fair, strong }
```

Rule (advisory only — never blocks beyond the existing 6-char `PasswordValueObject` minimum):
- `length < 6`            -> `tooShort`
- variety >= 3            -> `strong`
- variety >= 2 AND len>=12 -> `strong`
- variety == 2            -> `fair`
- otherwise (variety 1)   -> `weak`

`variety` = count of character classes present among: letters `[A-Za-z]`, digits `[0-9]`,
symbols `[^A-Za-z0-9]` (0–3).

Initial `SignUpState.passwordStrength` is `tooShort`. The evaluator is recomputed on every
keystroke in `SignUpCubit.onPasswordChanged`.

Unit test: `test/domain/core/auth/value_objects/password_strength_test.dart` — assert the
too-short boundary at <6, the weak/fair/strong transitions, and that 6+ chars never returns
`tooShort`. (The reverted version of this test was a scaffold; write it for real.)

---

## 4. Resolved: confirmation-flow mechanics (were open questions)

- **Re-check is implemented via re-sign-in** with the entered credentials, NOT session refresh.
  Therefore the entered `EmailPasswordCredentials` must be carried from sign-up into the
  confirmation flow and retained in `EmailConfirmationState.credentials`. `AuthService.recheckEmailConfirmation`
  calls `signInWithPassword`; if Supabase returns a user, `AuthUserModel.emailConfirmed`
  (from `User.emailConfirmedAt != null`) decides confirmed vs `not_yet_confirmed`.
- **Resend cooldown = 45 seconds**, with a live per-second countdown
  (`cooldownRemaining` in state, driven by a 1-second periodic `Timer`). Resend button is
  disabled while `cooldownRemaining > 0` and immediately on tap until the request resolves.
- **Resend call** uses Supabase `auth.resend(email, type: OtpType.signup)` — email only,
  password unused.
- **Auto-detect**: the confirmation cubit subscribes to `observeAuthEvents()` and treats
  `AuthEventType.login` as "confirmed" — routes to main without a tap, guarded so it does
  not double-fire once already `confirmed`.
- **Duplicate email under anti-enumeration**: `AuthUserModel.isNewUser` maps from
  `User.identities?.isNotEmpty`. `AuthRepository.signUp` treats `isNewUser == false` as
  `emailAlreadyRegistered` (no confirmation screen). A thrown "user already registered" /
  status `422` is also mapped to `emailAlreadyRegistered` as a belt-and-suspenders fallback.

---

## 5. Resolved: error taxonomy — `AuthFailureReason`

New enum at `lib/infrastructure/core/auth/auth_failure_reason.dart`, carried as the
`reference` on every `Failure` so cubits branch on the reason rather than message strings:

```
enum AuthFailureReason {
  invalidEmail, weakOrShortPassword, emailAlreadyRegistered, invalidCredentials,
  notYetConfirmed, rateLimited, networkError, unexpectedError,
}
```

`AuthRepository` mapping (Supabase `AuthException` message/`statusCode` inspection):
- network: `statusCode == "0"` or message contains `network`/`connection` -> `networkError`
- `invalid email` / `email address is invalid` -> `invalidEmail`
- sign-up: `password should be at least` / `weak password` -> `weakOrShortPassword`
- sign-up: `user already registered` / `email already` / `422` -> `emailAlreadyRegistered`
- sign-in: `invalid login credentials` / `invalid credentials` / `400` -> `invalidCredentials`
- resend: `rate limit` / `429` -> `rateLimited`
- recheck: a returned-but-unconfirmed user -> `notYetConfirmed` (distinct from network/unexpected)
- anything else -> `unexpectedError`

Cubit → user-facing mapping (see bdd.md for exact copy): `notYetConfirmed` shows the PENDING
message, which must be visually distinct from `networkError`/`unexpectedError`.

---

## 6. Resolved: offline test affordances on `OfflineAuthService`

Add these flags/spies on top of the `origin/main` baseline (which already has
`throwOnSignUp/SignIn/SignOut`, `hasSession`, `throwOnHasActiveSession`, `stubbedUser`,
`emitAuthEvent`, `last*Credentials`, `didSignOut` — keep all of those):

- `returnsDuplicateUser` — sign-up returns a user with `isNewUser == false`.
- `confirmationSucceeds` — re-check returns a confirmed user AND emits `AuthEventType.login`.
- `confirmationThrowsNetworkError` — re-check throws `AuthException(statusCode: "0")`.
- `confirmationThrowsUnexpectedError` — re-check throws a plain `Exception`.
- `resendSucceeds` (default `true`), `resendThrows` — resend success / failure.
- `rateLimitResend` — resend throws `AuthException(statusCode: "429")`.
- `lastRecheckCredentials`, `lastResendCredentials` — call spies.

The real `AuthRepository` runs unchanged on top of this — never fake the repository.

---

## 7. Resolved: application ↔ presentation contract (UI must honour these)

The cubits already encode these decisions; whichever UI the pipeline regenerates must consume
them rather than inventing its own.

`SignUpCubit`:
- `onEmailChanged` / `onPasswordChanged` accept input every keystroke; clear field/form
  errors on edit; recompute `passwordStrength` on password change.
- `signUp()` does submit-time validation (`EmailValueObject` / `PasswordValueObject`),
  guards against double-submit while `status == submitting`, and on success fires
  `SignUpNavigateToConfirmationEvent(credentials)` on the `EventBus`.
- State exposes: `status` (`idle`/`submitting`/`success`), `emailError`, `passwordError`,
  `formError` (`none`/`emailAlreadyRegistered`/`network`/`unexpected`), `passwordStrength`,
  `credentials`, and `isSubmitting`.

`EmailConfirmationCubit`:
- `init(credentials)` must be called on page entry; it stores credentials and subscribes to
  `observeAuthEvents()`. Cancels subscription + cooldown timer in `close()`.
- `recheckEmailConfirmation()` / `resendConfirmationEmail()` are the two actions.
- Fires one-shot `EventBus` events: `EmailConfirmationNavigateToMainEvent`,
  `EmailConfirmationResendSucceededEvent`, `EmailConfirmationResendFailedEvent`.
- State exposes: `status` (`idle`/`rechecking`/`confirmed`), `recheckMessage`
  (`none`/`pending`/`network`/`unexpected`), `resendEnabled`, `cooldownRemaining`, `isRechecking`.

Navigation is fired as `EventBus` events from the cubit (per the application-layer policy that
transient/navigation events go through the `EventBus`), not driven directly by the cubit.

Widget keys assumed by the scaffold UAT drivers (adopt these so tests line up):
`email_confirmation_confirm_button`, `email_confirmation_resend_button`,
`email_confirmation_pending_error`, `email_confirmation_network_error`,
`email_confirmation_resend_success`, `email_confirmation_resend_error`,
`email_confirmation_confirm_loading`. (Sign-up driver keys were not finalized — choose
analogous `sign_up_*` keys.)

---

## 8. Known deviations / things to double-check on regeneration

- **Use-case naming**: the wip named them `SignUpUseCase`, `RecheckEmailConfirmationUseCase`,
  `ResendConfirmationEmailUseCase`, `ObserveAuthEventsUseCase`. The domain CLAUDE.md naming
  table prefers `Get`/`Watch`/`Create`/`Set` prefixes (e.g. a one-shot stream observer would
  be `Watch...`). Regeneration should reconcile these with the convention.
- The 4 use cases are thin pass-throughs to the repository. That is acceptable but confirm it
  still earns its own type per the project's use-case policy.
- `recheckEmailConfirmation` re-signs-in on every tap; confirm that is acceptable vs a session
  refresh given Supabase rate limits.
- Localization strings for resend success/failure ("Confirmation email sent.", "Couldn't
  resend right now. Try again in a moment.") and any new sign-up copy were never added — the
  UI/localization pass must add them.
