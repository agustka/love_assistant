import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

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

  const _AuthLoginConstructor({
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
    service.throwOnSignIn = throwOnSignIn;
    service.signInReturnsUnconfirmed = signInReturnsUnconfirmed;
    service.signInThrowsNetworkError = signInThrowsNetworkError;
    service.signInThrowsRateLimit = signInThrowsRateLimit;
    service.throwOnPasswordReset = throwOnPasswordReset;
    service.passwordResetThrowsNetworkError = passwordResetThrowsNetworkError;
    service.passwordResetThrowsRateLimit = passwordResetThrowsRateLimit;
  }

  @override
  Future<void> tearDown() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
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
