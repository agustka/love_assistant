import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

/// Stages the offline auth boundary for the sign-up + email-confirmation flows.
///
/// Each fluent method flips one [OfflineAuthService] flag so the real
/// [AuthRepository] / cubits run on top of a known response: a duplicate
/// sign-up, a thrown sign-up failure, a confirmed/pending/failing re-check, or a
/// succeeding/rate-limited/failing resend. Defaults leave the service in its
/// fresh-sign-up, not-yet-confirmed state.
class AuthSignUpBuilder extends BaseBuilder {
  bool _returnsDuplicateUser = false;
  bool _throwOnSignUp = false;
  bool _confirmationSucceeds = false;
  bool _confirmationThrowsNetworkError = false;
  bool _confirmationThrowsUnexpectedError = false;
  bool _resendSucceeds = true;
  bool _rateLimitResend = false;
  bool _resendThrows = false;

  AuthSignUpBuilder();

  AuthSignUpBuilder duplicateEmail() {
    _returnsDuplicateUser = true;
    return this;
  }

  AuthSignUpBuilder signUpFails() {
    _throwOnSignUp = true;
    return this;
  }

  AuthSignUpBuilder confirmationConfirmed() {
    _confirmationSucceeds = true;
    return this;
  }

  AuthSignUpBuilder confirmationNetworkError() {
    _confirmationThrowsNetworkError = true;
    return this;
  }

  AuthSignUpBuilder confirmationUnexpectedError() {
    _confirmationThrowsUnexpectedError = true;
    return this;
  }

  AuthSignUpBuilder resendRateLimited() {
    _resendSucceeds = false;
    _rateLimitResend = true;
    return this;
  }

  AuthSignUpBuilder resendFails() {
    _resendSucceeds = false;
    _resendThrows = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _AuthSignUpConstructor(
      returnsDuplicateUser: _returnsDuplicateUser,
      throwOnSignUp: _throwOnSignUp,
      confirmationSucceeds: _confirmationSucceeds,
      confirmationThrowsNetworkError: _confirmationThrowsNetworkError,
      confirmationThrowsUnexpectedError: _confirmationThrowsUnexpectedError,
      resendSucceeds: _resendSucceeds,
      rateLimitResend: _rateLimitResend,
      resendThrows: _resendThrows,
    );
  }
}

class _AuthSignUpConstructor extends TestSetupConstructor {
  final bool returnsDuplicateUser;
  final bool throwOnSignUp;
  final bool confirmationSucceeds;
  final bool confirmationThrowsNetworkError;
  final bool confirmationThrowsUnexpectedError;
  final bool resendSucceeds;
  final bool rateLimitResend;
  final bool resendThrows;

  const _AuthSignUpConstructor({
    required this.returnsDuplicateUser,
    required this.throwOnSignUp,
    required this.confirmationSucceeds,
    required this.confirmationThrowsNetworkError,
    required this.confirmationThrowsUnexpectedError,
    required this.resendSucceeds,
    required this.rateLimitResend,
    required this.resendThrows,
  });

  @override
  Future<void> setup() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    service.returnsDuplicateUser = returnsDuplicateUser;
    service.throwOnSignUp = throwOnSignUp;
    service.confirmationSucceeds = confirmationSucceeds;
    service.confirmationThrowsNetworkError = confirmationThrowsNetworkError;
    service.confirmationThrowsUnexpectedError = confirmationThrowsUnexpectedError;
    service.resendSucceeds = resendSucceeds;
    service.rateLimitResend = rateLimitResend;
    service.resendThrows = resendThrows;
  }

  @override
  Future<void> tearDown() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    service.returnsDuplicateUser = false;
    service.throwOnSignUp = false;
    service.confirmationSucceeds = false;
    service.confirmationThrowsNetworkError = false;
    service.confirmationThrowsUnexpectedError = false;
    service.resendSucceeds = true;
    service.rateLimitResend = false;
    service.resendThrows = false;
    await super.tearDown();
  }
}
