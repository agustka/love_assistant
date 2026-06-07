import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/email_value_object.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/repository/auth_repository.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart";
import "package:la/setup.dart";

import "../../test_setup.dart";
import "../base_builder.dart";

/// Test-owned spy around [OfflineAuthService] for login UAT boundary assertions.
class AuthLoginServiceSpy implements IAuthService {
  final OfflineAuthService _delegate;
  int signInAttemptCount = 0;

  EmailPasswordCredentials? get lastSignInCredentials => _delegate.lastSignInCredentials;
  EmailPasswordCredentials? get lastRecheckCredentials => _delegate.lastRecheckCredentials;
  EmailPasswordCredentials? get lastResendCredentials => _delegate.lastResendCredentials;

  AuthLoginServiceSpy(this._delegate);

  @override
  Stream<AuthEventType> get authStateChanges => _delegate.authStateChanges;

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    signInAttemptCount += 1;
    await Future<void>.delayed(const Duration(milliseconds: 25));
    return _delegate.signInWithEmailAndPassword(credentials);
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials) {
    return _delegate.signUpWithEmailAndPassword(credentials);
  }

  @override
  Future<AuthUserModel> recheckEmailConfirmation(EmailPasswordCredentials credentials) {
    return _delegate.recheckEmailConfirmation(credentials);
  }

  @override
  Future<void> resendConfirmationEmail(EmailPasswordCredentials credentials) {
    return _delegate.resendConfirmationEmail(credentials);
  }

  @override
  Future<void> resetPasswordForEmail(EmailValueObject email) {
    return _delegate.resetPasswordForEmail(email);
  }

  @override
  Future<void> signOut() {
    return _delegate.signOut();
  }

  @override
  Future<bool> hasActiveSession() {
    return _delegate.hasActiveSession();
  }
}

/// Stages the offline auth boundary for the login and forgot-password flows.
///
/// Each fluent method flips one [OfflineAuthService] flag so the real
/// [AuthRepository] / cubits run on top of a known response: a wrong-password
/// or no-account error, an unconfirmed-email response, a network error, a
/// rate-limit error, or a forced unexpected failure. Defaults leave the service
/// in its happy-path, confirmed-account state.
class AuthLoginBuilder extends BaseBuilder {
  bool _throwOnSignIn = false;
  bool _signInReturnsUnconfirmed = false;
  bool _signInThrowsNetworkError = false;
  bool _signInThrowsRateLimit = false;
  bool _throwOnPasswordReset = false;
  bool _passwordResetThrowsNetworkError = false;
  bool _passwordResetThrowsRateLimit = false;

  AuthLoginBuilder();

  AuthLoginBuilder wrongCredentials() {
    _throwOnSignIn = true;
    return this;
  }

  AuthLoginBuilder unconfirmedEmail() {
    _signInReturnsUnconfirmed = true;
    return this;
  }

  AuthLoginBuilder networkError() {
    _signInThrowsNetworkError = true;
    return this;
  }

  AuthLoginBuilder rateLimited() {
    _signInThrowsRateLimit = true;
    return this;
  }

  AuthLoginBuilder passwordResetFails() {
    _throwOnPasswordReset = true;
    return this;
  }

  AuthLoginBuilder passwordResetNetworkError() {
    _passwordResetThrowsNetworkError = true;
    return this;
  }

  AuthLoginBuilder passwordResetRateLimited() {
    _passwordResetThrowsRateLimit = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _AuthLoginConstructor(
      throwOnSignIn: _throwOnSignIn,
      signInReturnsUnconfirmed: _signInReturnsUnconfirmed,
      signInThrowsNetworkError: _signInThrowsNetworkError,
      signInThrowsRateLimit: _signInThrowsRateLimit,
      throwOnPasswordReset: _throwOnPasswordReset,
      passwordResetThrowsNetworkError: _passwordResetThrowsNetworkError,
      passwordResetThrowsRateLimit: _passwordResetThrowsRateLimit,
    );
  }
}

class _AuthLoginConstructor extends TestSetupConstructor {
  final bool throwOnSignIn;
  final bool signInReturnsUnconfirmed;
  final bool signInThrowsNetworkError;
  final bool signInThrowsRateLimit;
  final bool throwOnPasswordReset;
  final bool passwordResetThrowsNetworkError;
  final bool passwordResetThrowsRateLimit;
  OfflineAuthService? _service;

  _AuthLoginConstructor({
    required this.throwOnSignIn,
    required this.signInReturnsUnconfirmed,
    required this.signInThrowsNetworkError,
    required this.signInThrowsRateLimit,
    required this.throwOnPasswordReset,
    required this.passwordResetThrowsNetworkError,
    required this.passwordResetThrowsRateLimit,
  });

  @override
  Future<void> setup() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    _service = service;
    service.throwOnSignIn = throwOnSignIn;
    service.signInReturnsUnconfirmed = signInReturnsUnconfirmed;
    service.signInThrowsNetworkError = signInThrowsNetworkError;
    service.signInThrowsRateLimit = signInThrowsRateLimit;
    service.throwOnPasswordReset = throwOnPasswordReset;
    service.passwordResetThrowsNetworkError = passwordResetThrowsNetworkError;
    service.passwordResetThrowsRateLimit = passwordResetThrowsRateLimit;
    await getIt.unregister<IAuthService>();
    getIt.registerSingleton<IAuthService>(AuthLoginServiceSpy(service));
    await getIt.unregister<IAuthRepository>();
    getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository(getIt<IAuthService>()));
  }

  @override
  Future<void> tearDown() async {
    final OfflineAuthService? service = _service;
    if (service == null) {
      await super.tearDown();
      return;
    }
    service.throwOnSignIn = false;
    service.signInReturnsUnconfirmed = false;
    service.signInThrowsNetworkError = false;
    service.signInThrowsRateLimit = false;
    service.throwOnPasswordReset = false;
    service.passwordResetThrowsNetworkError = false;
    service.passwordResetThrowsRateLimit = false;
    await super.tearDown();
  }
}
