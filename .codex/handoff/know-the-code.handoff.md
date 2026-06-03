## Request
Discover conventions for the login affordance / onboarding / landing / auth entry area across required layers. Cover navigation/state patterns, UI page/template/route registration, shared prompt-link affordances, and UAT driver patterns. Note whether domain or infrastructure appears unnecessary for this under-construction login shell feature.

## Summary
- This feature is primarily presentation + UAT. Application changes appear unnecessary unless implementation chooses to add real login state, which is out of scope.
- Routing is centralized in `PageName` and duplicated route maps for both `CupertinoApp` and `MaterialApp`; a `login("/login")` enum entry and `LoginPage` import/route should be added there.
- Existing page navigation uses `Navigator.of(context).pushNamed(PageName.<route>.route)` for ordinary forward navigation and `pushNamedAndRemoveUntil` only for auth completion to main.
- The first wizard page and post-wizard `LandingPage` both put actions in `BottomButtonsDefinition`; the bottom action model already supports `belowButtonsWidget`, which is the right slot for a secondary prompt-link below the primary action.
- A shared prompt-link molecule already exists: `LaLinkPromptMolecule(prompt, actionText, onTap)`. It wraps prompt/action text and avoids a second full-width button.
- Under-construction UI precedent exists as `MainPage` + `MainUnderConstructionOrganism`; the login shell can reuse the shape or create an auth-specific organism with the same atomic style.
- Domain and infrastructure appear unnecessary for the shell: `.codex/specs/api.yaml` says no infrastructure contract changes, and `.codex/specs/bdd.md` excludes real login, validation, session creation, social login, forgot password, and backend/local auth contracts.

## Artifacts
- `lib/presentation/core/app.dart:21` — `PageName` enum holds route strings; current entries include `signUp` and `emailConfirmation`, but no `login`.
- `lib/presentation/core/app.dart:80` and `lib/presentation/core/app.dart:103` — routes are registered in both Cupertino and Material route maps.
- `lib/presentation/wizard/wizard_page.dart:37` — `WizardPage` owns static `Key` constants for UAT finders.
- `lib/presentation/wizard/wizard_page.dart:77` — `WizardPage` provides `BlocProvider<WizardCubit>`, reads state with `BlocBuilder`, and renders `LaWizardTemplate`.
- `lib/presentation/wizard/wizard_page.dart:262` — wizard bottom actions are created through `_getBottomButtons()` returning `BottomButtonsDefinition`.
- `lib/presentation/landing/landing_page.dart:10` — `LandingPage` is a stateless page with `static const Key pageKey`.
- `lib/presentation/landing/landing_page.dart:31` — landing uses `LaDefaultPageTemplate` with `appBar`, `bottomButtons`, and a `LandingActionsOrganism`.
- `lib/presentation/landing/landing_page.dart:66` — landing currently has sign-up as the primary button and a login-labeled secondary button with an empty tap handler.
- `lib/presentation/core/ui_components/molecules/la_bottom_buttons_molecule.dart:17` — `BottomButtonsDefinition` supports `buttons`, `aboveButtonsWidget`, and `belowButtonsWidget`.
- `lib/presentation/core/ui_components/molecules/la_bottom_buttons_molecule.dart:161` — `belowButtonsWidget` renders below primary button rows, matching the layout spec.
- `lib/presentation/core/ui_components/molecules/la_link_prompt_molecule.dart:5` — shared prompt-link molecule shape: `prompt`, `actionText`, `onTap`.
- `lib/presentation/core/ui_components/organisms/la_auth_actions_organism.dart` — precedent for composing `LaLinkPromptMolecule` inside an auth-related organism.
- `lib/presentation/auth/sign_up_page.dart:13` — auth pages expose static `Key`s on the page class for drivers.
- `lib/presentation/auth/sign_up_page.dart:58` — full auth page pattern: inject Cubit with `BlocProvider`, read state with `BlocBuilder`, build template + organism definitions.
- `lib/presentation/auth/sign_up_page.dart:100` — sign-up navigates by named route to email confirmation.
- `lib/presentation/auth/email_confirmation_page.dart:54` — email confirmation uses `LaAuthTemplate` as an auth-shell precedent.
- `lib/presentation/main/main_page.dart:6` and `lib/presentation/main/widgets/main_under_construction_organism.dart:5` — under-construction page + organism precedent.
- `lib/presentation/core/ui_components/organisms/la_app_bar_organism.dart:16` — standard back affordance is `LaAppBarOrganism`, with `showBack` defaulting to true and `Navigator.of(context).pop`.
- `test/AGENTS.md` — UATs must use driver-builder pattern, Given/When/Then comments, and driver-owned finders/actions/assertions.
- `test/user_acceptance_tests/auth/back_navigation_test.dart:6` — UAT file shape: `tearDown(closeApp)`, `group`, `testWidgets`, comments, driver calls.
- `test/user_acceptance_tests/auth/driver/back_navigation_driver.dart:14` — back-navigation driver shape extending `BaseDriver`, using route maps and key-based finders.
- `test/user_acceptance_tests/wizard/driver/wizard_driver.dart` — wizard driver opens `WizardPage` with required `LanguageCubit` provider and asserts by page static keys.
- `test/user_acceptance_tests/auth/login_entry_points_test.dart` — scaffolded acceptance tests already exist for this exact feature and should be filled in, not duplicated.

## Invariants
- Do not modify domain or infrastructure for this shell feature unless the scope changes beyond under-construction navigation.
- Do not add mock-based cubit, repository, or service tests; testing directives explicitly forbid them.
- Keep the primary wizard/sign-up action visually dominant; login should not be represented as a second full-width primary/secondary button.
- Use `LaLinkPromptMolecule` for `"Already have an account?"` + `"Log in"` prompt-link affordances.
- Put the prompt-link in the existing bottom action area, likely through `BottomButtonsDefinition.belowButtonsWidget`, so page/template structure remains intact.
- Add stable static `Key` constants on presentation widgets/pages for the login prompt, action, login page shell, under-construction state, and back affordance if needed by drivers.
- Use localization via `S.of(context)` and ARB/l10n entries; widgets should not hardcode user-visible strings.
- Register the new route in `PageName` and in both app route maps, and include the route in UAT driver launch route maps.
- Use `Navigator.of(context).pushNamed(PageName.login.route)` for entry-point navigation and app-bar pop/back for returning to the origin.

## Findings
### Application
- Existing wizard flow completion is application-driven only where real state changes happen: `WizardCubit.next()` validates/saves and fires `WizardInitialSetupCompletedEvent`; `WizardPage` listens and pushes `PageName.landing.route`.
- For tapping a login affordance that only navigates to an under-construction page, there is no precedent requiring a Cubit action or state change. The local pattern supports handling simple navigation in the page callback, as `LandingPage` already does for sign-up.
- If application is touched, follow `lib/application/AGENTS.md`: Cubits extend `BaseCubit`, states extend `Equatable`, dependencies are injected, and transient navigation events use `EventBus`. This feature does not need that machinery.

### Presentation / UI
- Pages bind templates and organisms; they should not inline raw UI. Wizard uses `LaWizardTemplate`; landing/sign-up use `LaDefaultPageTemplate`; email confirmation uses `LaAuthTemplate`.
- First wizard page body is `_WizardStep1`, a part of `wizard_page.dart`, but bottom actions are owned by `WizardPage._getBottomButtons()`. The login prompt belongs in bottom actions, not inside `_WizardStep1`, because the spec says bottom action area and the existing primary `Next` action lives there.
- `LandingPage._bottomButtons()` currently returns two full-width sandwich buttons; replace the second login button with a prompt-link below the primary sign-up button.
- Concrete shape to follow:

```dart
BottomButtonsDefinition(
  buttons: [
    BottomButtonDefinition(
      key: <primaryKey>,
      text: strings.<primaryAction>,
      onTap: <primaryAction>,
    ),
  ],
  belowButtonsWidget: LaLinkPromptMolecule(
    prompt: strings.auth_signup_login_prompt,
    actionText: strings.auth_signup_login_action,
    onTap: () => Navigator.of(context).pushNamed(PageName.login.route),
  ),
)
```

- New login shell shape should be presentation-only:

```dart
class LoginPage extends StatelessWidget {
  static const Key pageKey = Key("LoginPage_page");
  static const Key underConstructionKey = Key("LoginPage_underConstruction");

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LaDefaultPageTemplate(
      key: LoginPage.pageKey,
      appBar: const LaAppBarOrganism(style: AppBarStyle.background),
      centerContent: true,
      scrollable: false,
      child: <under-construction organism/molecule>,
    );
  }
}
```

### Navigation / Route Registration
- Add `login("/login")` to `PageName` near auth routes.
- Import `LoginPage` in `lib/presentation/core/app.dart`.
- Add `PageName.login.route: (BuildContext context) => const LoginPage()` to both Cupertino and Material `routes` maps.
- For origin-preserving back navigation, use normal push (`pushNamed`) from wizard and landing; the login page's app bar pop will return to the route underneath.

### Testing
- Fill `test/user_acceptance_tests/auth/login_entry_points_test.dart`; do not create duplicate UAT files for these ACs.
- UAT tests should instantiate `AppDriver` first if needed, then auxiliary feature drivers, then the launching `driver`; test files should pass `tester` to drivers only and not call `tester.*` or `expect` directly.
- Feature drivers should extend `BaseDriver`; finders should be getter helpers using `find.byKey(<PresentationStaticKey>)`.
- Existing driver patterns:
  - `WizardDriver.openPage()` wraps `WizardPage` with `BlocProvider<LanguageCubit>`.
  - `BackNavigationDriver.openPage()` launches `LandingPage` with explicit routes; `goToSignUp()` demonstrates direct route pushing for setup.
  - `SignUpDriver.openPage()` registers the auth routes needed for navigation assertions.
- Add or extend drivers for:
  - opening the first wizard page and asserting the prompt/action/primary `Next` affordance,
  - opening landing and asserting primary sign-up plus prompt-link login,
  - tapping login from each origin and asserting `LoginPage.pageKey` / under-construction key,
  - tapping `LaAppBarOrganism.backButtonKey` and asserting the origin page key is visible.
- The untracked `test/user_acceptance_tests/auth/login_test.dart`, `driver/login_driver.dart`, `driver/reset_password_driver.dart`, and `AuthLoginBuilder` target a fuller future login/reset-password flow and reference missing pages/routes (`LoginPage`, `ResetPasswordPage`, `PageName.login`, `PageName.resetPassword`). Treat those as existing scaffold/colleague work; for this shell feature, only the under-construction entry-point UATs are in scope.

## Confirmed vs Inferred
- Confirmed: route strings live in `PageName`; app routes are plain route maps in both app variants.
- Confirmed: landing already uses named route navigation for sign-up and has an empty login-labeled secondary action.
- Confirmed: wizard first page primary action is in `WizardPage._getBottomButtons()`, not in `_WizardStep1`.
- Confirmed: `LaLinkPromptMolecule` is the reusable prompt-link component.
- Confirmed: `BottomButtonsDefinition.belowButtonsWidget` can place widgets below the main buttons.
- Confirmed: under-construction visual precedent exists in `MainUnderConstructionOrganism`.
- Confirmed: UAT conventions require driver-builder pattern, static keys, and Given/When/Then test bodies.
- Inferred: `belowButtonsWidget` is the best slot for the login prompt because the requested placement is below the primary action and the existing bottom-button molecule renders that slot there.
- Inferred: a new `LoginPage` should use `LaDefaultPageTemplate` with `LaAppBarOrganism`; this matches landing/main shell pages and provides standard back navigation without auth form state.
- Inferred: no application Cubit is needed because there is no login state, validation, or submit workflow in scope.

## Gaps
- No `LoginPage` currently exists in `lib/presentation/auth/`.
- No `PageName.login` route exists.
- No localization keys exist specifically for an under-construction login title/message; existing `main_under_construction_*` keys are generic but may be semantically too broad for auth.
- `LaLinkPromptMolecule` has no `Key` constructor parameter. Drivers may need the molecule wrapped in a keyed widget or the molecule extended with a key if implementation wants direct `find.byKey()` for the prompt/action.
- Existing generated/localization files may require the normal intl generation workflow if new ARB keys are added.
- Some untracked auth login/reset-password scaffold files reference missing future implementation and are broader than this feature.

## Status
complete

## Routing Signals
complexity_score: 3
confidence: 0.86
ambiguity_flags:
  - "login_shell_has_no_existing_page"
  - "prompt_link_keying_needs_ui_decision"
  - "untracked_future_login_scaffold_exists"
failure_signature: null
suggested_tier: "cheap"
