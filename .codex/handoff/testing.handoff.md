## Summary
- Replaced the scaffolded login entry-point UATs with executable BDD coverage for the under-construction login shell.
- Added an entry-point-specific auth driver that launches the first wizard page or landing page with the login route registered.
- Covered login affordance visibility, primary-action presence, navigation to `LoginPage`, the under-construction state, and back navigation to both origins.
- Left existing fuller future login/reset-password tests and drivers untouched.

## Artifacts
- `test/user_acceptance_tests/auth/login_entry_points_test.dart`
  - `First wizard page shows secondary login affordance`
  - `First wizard page login action opens login page`
  - `Post-wizard account page shows secondary login affordance`
  - `Post-wizard account page login action opens login page`
  - `Wizard login page shows under-construction state`
  - `Back from wizard login returns to wizard origin`
  - `Back from account login returns to account origin`
- `test/user_acceptance_tests/auth/driver/login_entry_points_driver.dart`
  - Key-based finders for `WizardPage.loginPromptKey`, `WizardPage.loginActionKey`, `LandingPage.loginPromptKey`, `LandingPage.loginActionKey`, `LandingPage.signUpButtonKey`, `LoginPage.pageKey`, `LoginPage.underConstructionKey`, and `LaAppBarOrganism.backButtonKey`.
  - Launch helpers for wizard-origin and landing-origin scenarios.

## Invariants
- All modified/created files are inside allowed paths: `test/**` and `.codex/handoff/testing.handoff.md`.
- No `lib/**` implementation files were modified.
- No `.claude/**` or `CLAUDE.md` files were modified.
- No mock-based cubit, repository, or service tests were added.
- No domain, application, infrastructure, or golden tests were added for this presentation/navigation feature.
- No `file:///` imports were introduced.
- Every `testWidgets` body in `login_entry_points_test.dart` contains `// Given`, `// When`, and `// Then` comments.
- Test-file logic uses the driver-builder pattern; finders, assertions, and interactions are in the driver.
- Driver finders use static presentation keys with `find.byKey()`.
- Existing untracked fuller auth login/reset-password tests and drivers were not deleted, reverted, or rewritten.

## Verification
- `dart format test/user_acceptance_tests/auth/login_entry_points_test.dart test/user_acceptance_tests/auth/driver/login_entry_points_driver.dart`
  - Passed.
- `dart analyze test/user_acceptance_tests/auth/login_entry_points_test.dart test/user_acceptance_tests/auth/driver/login_entry_points_driver.dart`
  - Passed: no issues found.
- `flutter test test/user_acceptance_tests/auth/login_entry_points_test.dart`
  - Passed: 7 tests passed.
- `dart analyze test/user_acceptance_tests/auth/`
  - Failed because of out-of-scope fuller future auth scaffold files, not the entry-point UAT files.
- `flutter test test/user_acceptance_tests/auth/`
  - Failed while loading `test/user_acceptance_tests/auth/login_test.dart` because of the same out-of-scope fuller future auth scaffold files.

## Failures
- scenario: Required auth-directory analyzer/test commands include out-of-scope fuller login/reset-password scaffolds.
  error: Missing `ResetPasswordPage`, missing `PageName.resetPassword`, and missing form-related static keys on the under-construction `LoginPage`.
  actual_issue: `test/user_acceptance_tests/auth/login_test.dart`, `driver/login_driver.dart`, and `driver/reset_password_driver.dart` target a future full login/reset-password implementation that is explicitly out of scope for the current under-construction login entry-point feature.
  evidence:
    - `test/user_acceptance_tests/auth/driver/login_driver.dart:5` imports `package:la/presentation/auth/reset_password_page.dart`, which does not exist.
    - `test/user_acceptance_tests/auth/driver/login_driver.dart:13` expects `LoginPage.emailFieldKey`, but current `LoginPage` only exposes `pageKey` and `underConstructionKey`.
    - `test/user_acceptance_tests/auth/driver/login_driver.dart:32` expects `PageName.resetPassword`, which does not exist.
    - `test/user_acceptance_tests/auth/driver/reset_password_driver.dart:2` imports `package:la/presentation/auth/reset_password_page.dart`, which does not exist.
  expected_fix: Implement or remove from analysis scope the future full login/reset-password feature contracts in a separate ticket. Do not change them as part of this under-construction entry-point feature.
  owning_layer: future UI/testing scope, outside current feature

## Gaps
- `.codex/skills/bdd-ac-testing/SKILL.md` and `.codex/skills/test-driver-generation/SKILL.md` are not present in this repository, so the tests follow `.codex/agents/testing.md`, `.codex/specs/bdd.md`, `test/AGENTS.md`, and local UAT conventions directly.
- Full auth-directory commands remain blocked by unrelated fuller future login/reset-password scaffold files until that future scope is implemented or isolated.
- No golden tests were added; the current request and BDD directives focus on UAT behavior/navigation.
- No domain tests were added; this feature has no domain value object or entity business logic changes.

## Status
complete

## Routing Signals
complexity_score: 3
confidence: 0.86
ambiguity_flags: "[out_of_scope_future_login_reset_scaffold_blocks_auth_directory_commands, missing_bdd_ac_testing_skill, missing_test_driver_generation_skill]"
failure_signature: "auth-directory commands fail loading login_test.dart: missing ResetPasswordPage/PageName.resetPassword and future LoginPage form keys"
suggested_tier: "cheap"
