import "package:flutter_test/flutter_test.dart";

import "../../_core/test_setup/app_driver.dart";
import "../../_core/test_setup/builders/auth_builder.dart";
import "driver/sign_up_driver.dart";

void main() {
  late AuthBuilder authBuilder;
  // ignore: unused_local_variable
  late AppDriver appDriver;
  late SignUpDriver driver;

  tearDown(() async {
    authBuilder.tearDown();
  });

  group("Sign-up screen", () {
    setUp(() {
      authBuilder = AuthBuilder();
    });

    testWidgets("Happy path — account created and confirmation screen shown", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Password strength indicator updates live while typing", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();

      // When
      await driver.enterPassword("abc");

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Strength indicator shows too-short while password is under 6 chars", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();

      // When
      await driver.enterPassword("ab");

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Invalid email — inline validation shown, no request made", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("not-an-email");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Password too short — inline validation shown, no request made", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");
      await driver.enterPassword("abc");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Empty password — inline validation shown, no request made", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Email already registered — existing-account error shown, no confirmation screen", (WidgetTester tester) async {
      // Given
      authBuilder.returnsDuplicateUser = true;
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("existing@example.com");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Network error on sign-up — connection error message shown", (WidgetTester tester) async {
      // Given
      authBuilder.throwOnSignUp = true;
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Unexpected failure — generic error message shown", (WidgetTester tester) async {
      // Given
      authBuilder.throwOnSignUp = true;
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Sign-up request in flight — button shows loading, duplicates prevented", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      driver = SignUpDriver(tester: tester, builders: authBuilder);
      await driver.openPage();
      await driver.enterEmail("user@example.com");
      await driver.enterPassword("validPassword1");

      // When
      await driver.tapSignUp();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });
  });
}
