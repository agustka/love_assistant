// scaffold — these imports will be uncommented in the generative phase when
// setup() is wired to the real OfflineAuthService via getIt.
// import "package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart";
// import "package:la/setup.dart";

import "base_builder.dart";

/// Fluent builder for auth offline-service configuration.
///
/// Wire the desired stub behaviour before each test, and call [tearDown] to
/// reset all flags so subsequent tests start from a clean state.
///
/// Access is via [getIt<IAuthService>() as OfflineAuthService] so the real
/// [AuthRepository] runs on top of the stub, exercising its validation and
/// error-mapping logic.
class AuthBuilder extends BaseBuilder {
  // scaffold — wire properties through to OfflineAuthService
  bool throwOnSignUp = false;
  bool throwOnSignIn = false;

  // scaffold — when true the offline service simulates a confirmed user
  // (the confirmation re-check use case / service method resolves successfully)
  bool confirmationSucceeds = false;

  // scaffold — when true the re-check throws a network error
  bool confirmationThrowsNetworkError = false;

  // scaffold — when true the re-check throws an unexpected error
  bool confirmationThrowsUnexpectedError = false;

  // scaffold — when true resend succeeds; false simulates rate-limit / failure
  bool resendSucceeds = true;
  bool resendThrows = false;

  // scaffold — whether sign-up returns a user with empty identities (duplicate)
  bool returnsDuplicateUser = false;

  void setup() {
    // scaffold — apply configured flags to the offline service
    // final service = getIt<IAuthService>() as OfflineAuthService;
    // service.throwOnSignUp = throwOnSignUp;
    // … etc.
  }

  @override
  void tearDown() {
    throwOnSignUp = false;
    throwOnSignIn = false;
    confirmationSucceeds = false;
    confirmationThrowsNetworkError = false;
    confirmationThrowsUnexpectedError = false;
    resendSucceeds = true;
    resendThrows = false;
    returnsDuplicateUser = false;
  }
}
