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
import "../../_core/test_setup/builders/wizard/partner_profile_builder.dart";
import "../../_core/test_setup/driver/app_driver.dart";
import "../wizard/driver/wizard_driver.dart";
import "driver/main_driver.dart";

UserPartnerProfile _savedProfile({
  bool detailedProfileCompleted = false,
  DateTime? birthday,
}) {
  return UserPartnerProfile(
    partnerName: "Alex",
    partnerPronoun: Pronoun.theyThem,
    customPronoun: "",
    partnerBirthday: birthday ?? DateTime.utc(1990, 5, 14),
    partnerLoveLanguages: const [LoveLanguage.qualityTime, LoveLanguage.physicalTouch],
    partnerToneOfVoice: ToneOfVoice.playful,
    partnerFavoriteFoods: const [FavoriteFood.pizza],
    partnerGiftCategories: const [GiftCategory.experience],
    partnerHobbies: const [Hobby.gaming],
    relationshipType: RelationshipType.lifePartners,
    detailedProfileCompleted: detailedProfileCompleted,
  );
}

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Main CTA tile", () {
    testWidgets("Reusable CTA tile renders action and dismiss controls", (WidgetTester tester) async {
      // Given a screen needs to prompt the user toward one concrete next step.
      final MainDriver driver = MainDriver(tester: tester);

      // When the screen renders a CTA tile with a title, message, one action, and a dismiss callback.
      await driver.openReusableCtaTileHarness();

      // Then the tile shows the title, message, primary action, and an x dismiss control in the top corner.
      driver.assertProfileCompletionCtaVisible();
      driver.assertProfileCompletionCtaCopy();

      // Then tapping each control invokes its supplied callback exactly once.
      await driver.tapProfileCompletionCtaAction();
      await driver.tapProfileCompletionCtaDismiss();
      driver.assertProfileCompletionCtaCallbacksWereCalledOnce();
    });

    testWidgets("Incomplete detailed profile shows profile CTA first", (WidgetTester tester) async {
      // Given the signed-in user lands on the main home screen with an initial partner profile.
      final AppDriver appDriver = AppDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );

      // Given their detailed partner profile has not been completed.
      // When the home screen finishes loading the local partner profile state.
      await driver.openPage();

      // Then the first content item at the top of the page is the profile CTA tile.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertProfileCompletionCtaVisible();
      driver.assertProfileCompletionCtaIsNearTop();

      // Then the tile title, message, and action match the profile-completion copy.
      driver.assertProfileCompletionCtaCopy();
    });

    testWidgets("Profile CTA action opens detailed profile flow", (WidgetTester tester) async {
      // Given the profile CTA tile is visible at the top of the home screen.
      final AppDriver appDriver = AppDriver(tester: tester);
      final WizardDriver wizardDriver = WizardDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );
      await driver.openPage();
      driver.assertProfileCompletionCtaVisible();

      // When the user taps Finish profile.
      await driver.tapProfileCompletionCtaAction();

      // Then the app opens the existing detailed wizard flow for the partner profile.
      appDriver.assertIsOnPage(PageName.wizard);
      driver.assertDetailedWizardOpenedOnce();

      // Then the wizard is hydrated with the partner profile values saved during initial setup.
      wizardDriver.assertOnHobbiesStep();
    });

    testWidgets("Completing detailed profile removes profile CTA", (WidgetTester tester) async {
      // Given the user completes the detailed partner profile flow.
      final AppDriver appDriver = AppDriver(tester: tester);
      final WizardDriver wizardDriver = WizardDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );
      await driver.openPage();
      await driver.tapProfileCompletionCtaAction();
      wizardDriver.assertOnHobbiesStep();

      // When they return to the home screen.
      await wizardDriver.tapNext();

      // Then the profile CTA tile is no longer shown.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertProfileCompletionCtaHidden();

      // Then the main home content remains available.
      appDriver.assertIsOnPage(PageName.main);
    });

    testWidgets("Dismissing profile CTA leaves current home view usable", (WidgetTester tester) async {
      // Given the profile CTA tile is visible at the top of the home screen.
      final AppDriver appDriver = AppDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );
      await driver.openPage();
      driver.assertProfileCompletionCtaVisible();

      // When the user taps the x dismiss control.
      await driver.tapProfileCompletionCtaDismiss();

      // Then the tile is removed from the current home view.
      driver.assertProfileCompletionCtaHidden();

      // Then the rest of the home screen stays visible and usable.
      appDriver.assertIsOnPage(PageName.main);

      // Then dismissal is not persisted across app launches.
      await driver.restartPage();
      driver.assertProfileCompletionCtaVisible();
    });

    testWidgets("Completed detailed profile suppresses profile CTA", (WidgetTester tester) async {
      // Given the signed-in user lands on the main home screen.
      final AppDriver appDriver = AppDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(
            _savedProfile(detailedProfileCompleted: true),
          ),
        ],
      );

      // Given their detailed partner profile has already been completed.
      // When the home screen finishes loading the local partner profile state.
      await driver.openPage();

      // Then the profile CTA tile is not shown.
      appDriver.assertIsOnPage(PageName.main);
      driver.assertProfileCompletionCtaHidden();
    });

    testWidgets("Profile state load failure keeps home usable without CTA", (WidgetTester tester) async {
      // Given the signed-in user lands on the main home screen.
      final AppDriver appDriver = AppDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()).failOnLoad(),
        ],
      );

      // Given the local partner profile store fails to load profile completion state.
      // When the home screen handles the failure.
      await driver.openPage();

      // Then the home screen remains usable.
      appDriver.assertIsOnPage(PageName.main);

      // Then the profile CTA tile is not shown until completion state can be read successfully.
      driver.assertProfileCompletionCtaHidden();
    });

    testWidgets("Detailed wizard validation keeps profile incomplete", (WidgetTester tester) async {
      // Given the user opens the detailed profile flow from the profile CTA.
      final AppDriver appDriver = AppDriver(tester: tester);
      final WizardDriver wizardDriver = WizardDriver(tester: tester);
      final MainDriver driver = MainDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile(birthday: DateTime(1800))),
        ],
      );
      await driver.openPage();
      await driver.tapProfileCompletionCtaAction();
      wizardDriver.assertOnHobbiesStep();

      // When they try to continue past a required detailed-profile field without entering a valid value.
      await wizardDriver.tapNext();

      // Then the existing inline wizard validation appears.
      appDriver.assertIsOnPage(PageName.wizard);

      // Then the detailed profile is not marked complete.
      // Then the home screen CTA remains eligible to appear.
      await appDriver.popRoute();
      driver.assertProfileCompletionCtaVisible();
    });
  });
}
