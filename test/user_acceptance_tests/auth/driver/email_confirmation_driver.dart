import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";

import "../../../../_core/test_setup/base_driver.dart";
import "../../../../_core/test_setup/builders/auth_builder.dart";

/// Driver for the email-confirmation page.
///
/// All finders, assertions, and interactions for [EmailConfirmationPage] live
/// here.  Test files must not call [tester.*] directly.
class EmailConfirmationDriver extends BaseDriver {
  final AuthBuilder builders;

  // scaffold — Keys are declared as stubs; the generative phase replaces them
  // with real static Key constants from the presentation layer.
  // ignore: unused_field
  static const Key _confirmButtonKey = Key("email_confirmation_confirm_button");
  // ignore: unused_field
  static const Key _resendButtonKey = Key("email_confirmation_resend_button");
  // ignore: unused_field
  static const Key _pendingErrorKey = Key("email_confirmation_pending_error");
  // ignore: unused_field
  static const Key _networkErrorKey = Key("email_confirmation_network_error");
  // ignore: unused_field
  static const Key _resendSuccessKey = Key("email_confirmation_resend_success");
  // ignore: unused_field
  static const Key _resendErrorKey = Key("email_confirmation_resend_error");
  // ignore: unused_field
  static const Key _confirmButtonLoadingKey = Key("email_confirmation_confirm_loading");

  EmailConfirmationDriver({required super.tester, required this.builders});

  Future<void> tapConfirmed() async {
    // scaffold — tap "I've confirmed my email"
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> tapResend() async {
    // scaffold — tap "Resend email"
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> simulateSignedInAuthEvent() async {
    // scaffold — emit AuthEventType.login to the OfflineAuthService stream
    // so the page auto-routes to main.
    // final service = getIt<IAuthService>() as OfflineAuthService;
    // service.emitAuthEvent(AuthEventType.login);
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertPendingErrorShown() async {
    // scaffold — assert the "not confirmed yet" pending message is visible
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertNetworkErrorShown() async {
    // scaffold — assert the network/server error message is visible
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertResendSuccessShown() async {
    // scaffold — assert the "Confirmation email sent." confirmation is visible
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertResendErrorShown() async {
    // scaffold — assert the resend failure message is visible
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertResendButtonDisabled() async {
    // scaffold — assert "Resend email" is disabled during cooldown
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertConfirmButtonIsLoading() async {
    // scaffold — assert the "I've confirmed my email" button shows loading
    markTestSkipped("scaffold — implement after layers complete");
  }
}
