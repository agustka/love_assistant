## Summary
- Implemented the presentation-only login affordance feature for the first wizard page and post-wizard landing page.
- Added an under-construction `LoginPage` shell with standard app-bar back navigation.
- Registered `PageName.login` in both Cupertino and Material route maps.
- Replaced the landing page's second full-width login button with the shared prompt-link pattern.
- Added narrow key support to `LaLinkPromptMolecule` for future UAT driver finders.

## Artifacts
- `lib/presentation/auth/login_page.dart`
  - Added `LoginPage.pageKey`.
  - Added `LoginPage.underConstructionKey`.
  - Uses `LaDefaultPageTemplate`, `LaAppBarOrganism`, and existing under-construction organism.
- `lib/presentation/core/app.dart`
  - Added `PageName.login("/login")`.
  - Registered `LoginPage` in Cupertino routes.
  - Registered `LoginPage` in Material routes.
- `lib/presentation/wizard/wizard_page.dart`
  - Added `WizardPage.loginPromptKey`.
  - Added `WizardPage.loginActionKey`.
  - Added `LaLinkPromptMolecule` below the primary first-step action.
  - Navigates to `PageName.login.route` with `pushNamed`.
- `lib/presentation/landing/landing_page.dart`
  - Added `LandingPage.loginPromptKey`.
  - Added `LandingPage.loginActionKey`.
  - Added `LandingPage.signUpButtonKey`.
  - Replaced the secondary full-width login button with `LaLinkPromptMolecule`.
  - Navigates to `PageName.login.route` with `pushNamed`.
- `lib/presentation/core/ui_components/molecules/la_link_prompt_molecule.dart`
  - Added optional `promptKey` and `actionKey` constructor parameters.
  - Existing callers remain compatible.
- `lib/presentation/core/localization/intl_en.arb`
  - Changed `auth_signup_login_action` to "Log in".
  - Added login under-construction title/message.
- `lib/presentation/core/localization/intl_is.arb`
  - Bracketed changed/new values for manual translation.
- `lib/presentation/core/localization/l10n.dart`
- `lib/presentation/core/localization/intl/messages_en.dart`
- `lib/presentation/core/localization/intl/messages_is.dart`
  - Updated generated localization lookups for the new/changed keys.

## Invariants
- All pages use approved templates.
- Templates receive organisms/molecules/definitions through existing template slots.
- No domain, application, infrastructure, or test files were modified.
- No real login form, validation, forgot-password, social login, session creation, backend, or local auth behavior was added.
- All user-facing strings are localized through `S.of(context)`.
- Primary wizard and sign-up actions remain the only full-width primary actions in their bottom action areas.
- Login affordances use `LaLinkPromptMolecule`, not a second full-width button.
- Login entry navigation uses `Navigator.of(context).pushNamed(PageName.login.route)`.
- Returning from login uses the standard `LaAppBarOrganism` back behavior.
- Route registration is complete for `PageName`, Cupertino routes, and Material routes.
- `dart format` was run on changed Dart files.
- `dart analyze` was not run, per task instruction.

## Gaps
- testing-owned gap: update tests for login entry-point UATs — assert wizard prompt/action, landing prompt/action, login page under-construction state, and back navigation to each origin using the new static keys.
- localization-owned gap: replace bracketed Icelandic placeholders for `auth_signup_login_action`, `auth_login_under_construction_title`, and `auth_login_under_construction_message`.

## Status
complete

## Routing Signals
complexity_score: 3
confidence: 0.88
ambiguity_flags: []
failure_signature: null
suggested_tier: cheap
