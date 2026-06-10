import "package:flutter/material.dart" show BuildContext;
import "package:flutter_test/flutter_test.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_remote_store.dart";
import "package:la/infrastructure/wizard/store/offline/offline_partner_profile_local_store.dart";
import "package:la/infrastructure/wizard/store/offline/offline_partner_profile_remote_store.dart";
import "package:la/presentation/auth/email_confirmation_page.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/auth/sign_up_page.dart";
import "package:la/presentation/core/app.dart";
import "package:la/presentation/main/main_page.dart";
import "package:la/setup.dart";

import "../../../_core/test_setup/driver/i_driver.dart";

/// Drives authentication entry points and asserts partner-profile sync outcomes
/// for the partner_profile_authenticated_sync acceptance test suite.
class PartnerProfileSyncDriver extends BaseDriver {
  Finder get _loginEmailEditableFinder => find.byKey(LoginPage.emailEditableKey);
  Finder get _loginPasswordEditableFinder => find.byKey(LoginPage.passwordEditableKey);
  Finder get _loginSubmitFinder => find.byKey(LoginPage.submitButtonKey);
  Finder get _signUpEmailFinder => find.byKey(SignUpPage.emailEditableKey);
  Finder get _signUpPasswordFinder => find.byKey(SignUpPage.passwordEditableKey);
  Finder get _signUpSubmitFinder => find.byKey(SignUpPage.submitButtonKey);
  Finder get _confirmButtonFinder => find.byKey(EmailConfirmationPage.confirmButtonKey);

  OfflinePartnerProfileLocalStore get _localStore =>
      getIt<IPartnerProfileLocalStore>() as OfflinePartnerProfileLocalStore;
  OfflinePartnerProfileRemoteStore get _remoteStore =>
      getIt<IPartnerProfileRemoteStore>() as OfflinePartnerProfileRemoteStore;
  OfflineAuthService get _authService => getIt<IAuthService>() as OfflineAuthService;

  PartnerProfileSyncDriver({required super.tester, super.builders});

  Future<void> openLoginPage() async {
    await launchApplication(
      home: const LoginPage(),
      routes: {
        PageName.login.route: (BuildContext context) => const LoginPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  Future<void> openSignUpPage() async {
    await launchApplication(
      home: const SignUpPage(),
      routes: {
        PageName.signUp.route: (BuildContext context) => const SignUpPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  Future<void> loginWithCredentials(String email, String password) async {
    await tester.enterText(_loginEmailEditableFinder, email);
    await tester.pump();
    await tester.enterText(_loginPasswordEditableFinder, password);
    await tester.pump();
    await tester.tap(_loginSubmitFinder);
    await tester.pumpAndSettle();
  }

  Future<void> signUpWithCredentials(String email, String password) async {
    await tester.enterText(_signUpEmailFinder, email);
    await tester.pump();
    await tester.enterText(_signUpPasswordFinder, password);
    await tester.pump();
    await tester.tap(_signUpSubmitFinder);
    await tester.pumpAndSettle();
  }

  Future<void> confirmEmailViaRecheck() async {
    await tester.tap(_confirmButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> confirmEmailViaAuthEvent() async {
    _authService.emitAuthEvent(AuthEventType.login);
    await tester.pumpAndSettle();
  }

  void assertIsOnMain() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.main));
  }

  void assertRemoteProfileSaved() {
    expect(_remoteStore.savedProfile, isNotNull);
    expect(_remoteStore.savedProfile!.isInvalid, isFalse);
  }

  void assertRemoteProfileNotSaved() {
    expect(_remoteStore.savedProfile, isNull);
  }

  void assertRemoteProfileUnchanged(UserPartnerProfile expected) {
    expect(_remoteStore.savedProfile, expected);
  }

  void assertLocalProfileRemoved() {
    expect(_localStore.savedProfile, isNull);
  }

  void assertLocalProfileRetained() {
    expect(_localStore.savedProfile, isNotNull);
  }

  void assertRemoteProfileMatchesInitialFields(UserPartnerProfile localProfile) {
    final UserPartnerProfile? remote = _remoteStore.savedProfile;
    expect(remote, isNotNull);
    expect(remote!.partnerName, localProfile.partnerName);
    expect(remote.partnerPronoun, localProfile.partnerPronoun);
    expect(remote.partnerToneOfVoice, localProfile.partnerToneOfVoice);
    expect(remote.partnerLoveLanguages, localProfile.partnerLoveLanguages);
  }

  void assertRemoteProfilePreservesExtendedFields(UserPartnerProfile preExistingRemoteProfile) {
    final UserPartnerProfile? remote = _remoteStore.savedProfile;
    expect(remote, isNotNull);
    expect(remote!.partnerHobbies, preExistingRemoteProfile.partnerHobbies);
    expect(remote.relationshipType, preExistingRemoteProfile.relationshipType);
    expect(remote.detailedProfileCompleted, preExistingRemoteProfile.detailedProfileCompleted);
  }
}
