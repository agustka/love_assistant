import "package:flutter_test/flutter_test.dart";
import "package:la/domain/core/value_objects/favorite_food_value_object.dart";
import "package:la/domain/core/value_objects/gift_ideas_value_object.dart";
import "package:la/domain/core/value_objects/hobby_value_object.dart";
import "package:la/domain/core/value_objects/love_language_value_object.dart";
import "package:la/domain/core/value_objects/pronoun_value_object.dart";
import "package:la/domain/core/value_objects/relationship_type_value_object.dart";
import "package:la/domain/core/value_objects/tone_of_voice_value_object.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/presentation/core/app.dart";

import "../../_core/test_rig.dart";
import "../../_core/test_setup/builders/auth/auth_login_builder.dart";
import "../../_core/test_setup/builders/auth/auth_sign_up_builder.dart";
import "../../_core/test_setup/builders/wizard/partner_profile_builder.dart";
import "../../_core/test_setup/builders/wizard/partner_profile_remote_builder.dart";
import "../../_core/test_setup/driver/app_driver.dart";
import "driver/partner_profile_sync_driver.dart";

const String _email = "user@example.com";
const String _password = "password123";

UserPartnerProfile _completedLocalProfile() {
  return const UserPartnerProfile(
    partnerName: "Alex",
    partnerPronoun: Pronoun.theyThem,
    customPronoun: "",
    partnerBirthday: null,
    partnerLoveLanguages: [LoveLanguage.qualityTime],
    partnerToneOfVoice: ToneOfVoice.playful,
    partnerFavoriteFoods: [FavoriteFood.pizza],
    partnerGiftCategories: [GiftCategory.experience],
  );
}

UserPartnerProfile _detailedRemoteProfile() {
  return const UserPartnerProfile(
    partnerName: "OldName",
    partnerPronoun: Pronoun.sheHer,
    customPronoun: "",
    partnerBirthday: null,
    partnerLoveLanguages: [LoveLanguage.actsOfService],
    partnerToneOfVoice: ToneOfVoice.romantic,
    partnerFavoriteFoods: [FavoriteFood.seafood],
    partnerGiftCategories: [GiftCategory.experience],
    partnerHobbies: [Hobby.gaming],
    relationshipType: RelationshipType.lifePartners,
    detailedProfileCompleted: true,
  );
}

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Partner profile authenticated sync", () {
    testWidgets("Email-confirmed sign-up syncs local profile before home", (WidgetTester tester) async {
      // Given a customer completed the initial partner profile locally and then signed up.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedLocalProfile()),
          PartnerProfileRemoteBuilder(),
          AuthSignUpBuilder().confirmationConfirmed(),
        ],
      );
      await driver.openSignUpPage();
      await driver.signUpWithCredentials(_email, _password);

      // When email confirmation establishes an authenticated session before entering the home screen.
      await driver.confirmEmailViaRecheck();

      // Then the local partner profile is saved remotely, loaded as canonical, and removed locally after success.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileSaved();
      driver.assertLocalProfileRemoved();
    });

    testWidgets("Email-confirmed sign-up syncs via observed auth event", (WidgetTester tester) async {
      // Given a customer completed the initial partner profile locally and then signed up.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedLocalProfile()),
          PartnerProfileRemoteBuilder(),
          AuthSignUpBuilder(),
        ],
      );
      await driver.openSignUpPage();
      await driver.signUpWithCredentials(_email, _password);

      // When a signed-in auth event is observed (e.g. from the email link) before entering the home screen.
      await driver.confirmEmailViaAuthEvent();

      // Then the local partner profile is saved remotely and removed locally after success.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileSaved();
      driver.assertLocalProfileRemoved();
    });

    testWidgets("Login syncs local profile before home", (WidgetTester tester) async {
      // Given a customer completed the initial partner profile locally and then logs in.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedLocalProfile()),
          PartnerProfileRemoteBuilder(),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When login succeeds before entering the home screen.
      await driver.loginWithCredentials(_email, _password);

      // Then the local partner profile is saved remotely, loaded as canonical, and removed locally after success.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileSaved();
      driver.assertLocalProfileRemoved();
    });

    testWidgets("Existing remote profile is partially updated", (WidgetTester tester) async {
      // Given the customer already has a remote partner profile with extended answers
      // and the same customer installs the app again, completes the initial setup locally, and logs in.
      final AppDriver appDriver = AppDriver(tester: tester);
      final UserPartnerProfile preExistingRemote = _detailedRemoteProfile();
      final UserPartnerProfile newLocal = _completedLocalProfile();
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(newLocal),
          PartnerProfileRemoteBuilder().withSavedProfile(preExistingRemote),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When the local initial profile is synced to Supabase.
      await driver.loginWithCredentials(_email, _password);

      // Then only the initial profile fields update while remote extended answers remain unchanged.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileMatchesInitialFields(newLocal);
      driver.assertRemoteProfilePreservesExtendedFields(preExistingRemote);
    });

    testWidgets("No local profile on authenticated entry loads remote without overwrite", (WidgetTester tester) async {
      // Given the customer authenticates and there is no valid local partner profile.
      final AppDriver appDriver = AppDriver(tester: tester);
      final UserPartnerProfile existingRemote = _detailedRemoteProfile();
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder(),
          PartnerProfileRemoteBuilder().withSavedProfile(existingRemote),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When the app prepares to enter the home screen.
      await driver.loginWithCredentials(_email, _password);

      // Then it loads an existing remote profile without creating or overwriting remote data from local state.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileUnchanged(existingRemote);
    });

    testWidgets("Remote save or load failure keeps local fallback", (WidgetTester tester) async {
      // Given the customer has a valid local partner profile and authentication succeeds.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedLocalProfile()),
          PartnerProfileRemoteBuilder().failOnSave(),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When remote saving or loading fails, is unavailable, or returns an error.
      await driver.loginWithCredentials(_email, _password);

      // Then home opens with the local fallback and the local profile remains stored for a later retry.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertLocalProfileRetained();
    });

    testWidgets("Remote load failure after save keeps local fallback", (WidgetTester tester) async {
      // Given the customer has a valid local partner profile and authentication succeeds.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedLocalProfile()),
          PartnerProfileRemoteBuilder().failOnLoad(),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When remote save succeeds but the subsequent remote load fails.
      await driver.loginWithCredentials(_email, _password);

      // Then home opens with the local fallback and the local profile remains stored for a later retry.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertLocalProfileRetained();
    });

    testWidgets("Invalid local profile is not synced", (WidgetTester tester) async {
      // Given the local partner profile is invalid or cannot be read.
      final AppDriver appDriver = AppDriver(tester: tester);
      final PartnerProfileSyncDriver driver = PartnerProfileSyncDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder(),
          PartnerProfileRemoteBuilder(),
          AuthLoginBuilder(),
        ],
      );
      await driver.openLoginPage();

      // When the customer authenticates.
      await driver.loginWithCredentials(_email, _password);

      // Then invalid data is not written remotely and navigation follows the existing profile fallback rules.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertRemoteProfileNotSaved();
    });

  });
}
