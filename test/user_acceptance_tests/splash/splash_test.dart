import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';

import '../../_core/test_rig.dart';
import '../../_core/test_setup/builders/auth/auth_session_builder.dart';
import '../../_core/test_setup/builders/wizard/partner_profile_builder.dart';
import 'driver/splash_driver.dart';

UserPartnerProfile _completedProfile() {
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

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Cold-start routing", () {
    testWidgets("Setup not completed routes to the wizard", (WidgetTester tester) async {
      // Given no partner profile is persisted on the device
      final SplashDriver driver = SplashDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );

      // When the app opens (cold start)
      await driver.openApp();
      await driver.waitForStartupRouting();

      // Then the splash finishes and routes to the wizard
      driver.assertOnWizard();
    });

    testWidgets("Completed but not signed up routes to landing with wizard in back stack",
        (WidgetTester tester) async {
      // Given a persisted partner profile and no active auth session
      final SplashDriver driver = SplashDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedProfile()),
          AuthSessionBuilder(),
        ],
      );

      // When the app opens (cold start)
      await driver.openApp();
      await driver.waitForStartupRouting();

      // Then it routes to the landing page (wizard kept beneath it)
      driver.assertOnLanding();
    });

    testWidgets("Completed and signed up routes straight to main", (WidgetTester tester) async {
      // Given a persisted partner profile and an active auth session
      final SplashDriver driver = SplashDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedProfile()),
          AuthSessionBuilder().signedIn(),
        ],
      );

      // When the app opens (cold start)
      await driver.openApp();
      await driver.waitForStartupRouting();

      // Then it routes straight to the main page and neither wizard nor landing is shown
      driver.assertOnMain();
      driver.assertNotOnLanding();
      driver.assertNotOnWizard();
    });

    testWidgets("Persisted profile read failure falls back to the wizard", (WidgetTester tester) async {
      // Given a persisted profile exists but reading it from local storage fails
      final SplashDriver driver = SplashDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedProfile()).failOnLoad(),
          AuthSessionBuilder(),
        ],
      );

      // When the app opens (cold start)
      await driver.openApp();
      await driver.waitForStartupRouting();

      // Then the splash routes to the wizard as the safe fallback
      driver.assertOnWizard();
    });

    testWidgets("Back from landing returns to the wizard", (WidgetTester tester) async {
      // Given the user was routed to the landing page after a relaunch
      final SplashDriver driver = SplashDriver(
        tester: tester,
        builders: [
          PartnerProfileBuilder().withSavedProfile(_completedProfile()),
          AuthSessionBuilder(),
        ],
      );
      await driver.openApp();
      await driver.waitForStartupRouting();

      // When they navigate back from the landing page
      await driver.navigateBack();

      // Then they return to the wizard
      driver.assertOnWizard();
    });
  });
}
