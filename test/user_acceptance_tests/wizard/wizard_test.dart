import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';

import '../../_core/test_rig.dart';
import '../../_core/test_setup/builders/wizard/partner_profile_builder.dart';
import 'driver/wizard_driver.dart';

UserPartnerProfile _savedProfile() {
  return UserPartnerProfile(
    partnerName: "Alex",
    partnerPronoun: Pronoun.theyThem,
    customPronoun: "",
    partnerBirthday: DateTime.utc(1990, 5, 14),
    partnerLoveLanguages: const [LoveLanguage.qualityTime, LoveLanguage.physicalTouch],
    partnerToneOfVoice: ToneOfVoice.playful,
    partnerFavoriteFoods: const [FavoriteFood.pizza],
    partnerGiftCategories: const [GiftCategory.experience],
  );
}

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Initial wizard", () {
    testWidgets("Wizard opens on the greetings step", (WidgetTester tester) async {
      // Given a first-time user with no saved partner profile
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );

      // When the wizard opens
      await driver.openPage();

      // Then the greetings step is shown first
      driver.assertOnGreetingsStep();
    });

    testWidgets("Continuing from greetings advances to the partner basics step", (WidgetTester tester) async {
      // Given a first-time user on the greetings step
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );
      await driver.openPage();

      // When they continue past the greeting
      await driver.tapNext();

      // Then the partner basics step is shown
      driver.assertOnBasicInfoStep();
    });
  });

  group("Returning wizard restores the saved partner profile", () {
    testWidgets("Reopening with a saved profile lands past the greetings step", (WidgetTester tester) async {
      // Given a partner profile was already saved before the app was terminated and reopened
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );

      // When the wizard reopens for the returning user
      await driver.openPage();

      // Then it does not drop the user back on the empty greetings step
      driver.assertNotOnGreetingsStep();
    });

    testWidgets("Reopening with a saved profile lands on its last step", (WidgetTester tester) async {
      // Given a partner profile was already saved before the app was terminated and reopened
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().profileAlreadyCreated().withSavedProfile(_savedProfile()),
        ],
      );

      // When the wizard reopens for the returning user
      await driver.openPage();

      // Then it reopens deep in the flow, not on the first (greetings) or second (basics) step
      driver.assertNotOnGreetingsStep();
      driver.assertNotOnBasicInfoStep();
    });

    testWidgets("No saved profile starts a normal session on the greetings step", (WidgetTester tester) async {
      // Given no partner profile was ever saved before reaching the wizard
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );

      // When the wizard opens
      await driver.openPage();

      // Then it starts a normal session at the first step with no restored selections
      driver.assertOnGreetingsStep();
    });
  });
}
