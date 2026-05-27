import "dart:async";

import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/setup.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// In-memory auth service for the offline (test) environment.
///
/// This is the only auth boundary that is faked offline — the real
/// [AuthRepository] runs unchanged on top of it, so its validation, error
/// mapping, and payload handling are exercised against stubbed responses.
///
/// Sign-up / sign-in return a configurable [stubbedUser]. Re-check and resend
/// each have success and failure toggles. Use [emitAuthEvent] to push events
/// onto the broadcast [authStateChanges] stream (e.g. to drive the auto-detect
/// confirmation path). Inspect the `last*Credentials` / `did*` spies to assert
/// what the repository forwarded.
@InjectableEnv.offline
@LazySingleton(as: IAuthService)
class OfflineAuthService implements IAuthService {
  AuthUserModel stubbedUser = const AuthUserModel(
    id: "offline-user-id",
    email: "offline@example.com",
  );
  bool throwOnSignUp = false;
  bool throwOnSignIn = false;
  bool throwOnSignOut = false;
  bool returnsDuplicateUser = false;
  bool confirmationSucceeds = false;
  bool confirmationThrowsNetworkError = false;
  bool confirmationThrowsUnexpectedError = false;
  bool resendSucceeds = true;
  bool resendThrows = false;
  bool rateLimitResend = false;
  EmailPasswordCredentials? lastSignUpCredentials;
  EmailPasswordCredentials? lastSignInCredentials;
  EmailPasswordCredentials? lastRecheckCredentials;
  EmailPasswordCredentials? lastResendCredentials;
  bool didSignOut = false;
  final StreamController<AuthEventType> _authStateController = StreamController<AuthEventType>.broadcast();

  @override
  Stream<AuthEventType> get authStateChanges => _authStateController.stream;

  OfflineAuthService();

  void emitAuthEvent(AuthEventType event) {
    _authStateController.add(event);
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    lastSignUpCredentials = credentials;
    if (throwOnSignUp) {
      throw Exception("OfflineAuthService forced signUp failure");
    }
    return _signUpResult();
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    lastSignInCredentials = credentials;
    if (throwOnSignIn) {
      throw Exception("OfflineAuthService forced signIn failure");
    }
    return stubbedUser;
  }

  @override
  Future<AuthUserModel> recheckEmailConfirmation(EmailPasswordCredentials credentials) async {
    lastRecheckCredentials = credentials;
    if (confirmationThrowsNetworkError) {
      throw const AuthException("network error reaching the server", statusCode: "0");
    }
    if (confirmationThrowsUnexpectedError) {
      throw Exception("OfflineAuthService forced recheck failure");
    }
    if (confirmationSucceeds) {
      emitAuthEvent(AuthEventType.login);
      return _confirmedUser(emailConfirmed: true);
    }
    return _confirmedUser(emailConfirmed: false);
  }

  @override
  Future<void> resendConfirmationEmail(EmailPasswordCredentials credentials) async {
    lastResendCredentials = credentials;
    if (rateLimitResend) {
      throw const AuthException("email rate limit exceeded", statusCode: "429");
    }
    if (resendThrows || !resendSucceeds) {
      throw Exception("OfflineAuthService forced resend failure");
    }
  }

  @override
  Future<void> signOut() async {
    if (throwOnSignOut) {
      throw Exception("OfflineAuthService forced signOut failure");
    }
    didSignOut = true;
  }

  AuthUserModel _signUpResult() {
    return AuthUserModel(
      id: stubbedUser.id,
      email: stubbedUser.email,
      createdAt: stubbedUser.createdAt,
      emailConfirmed: stubbedUser.emailConfirmed,
      isNewUser: !returnsDuplicateUser,
    );
  }

  AuthUserModel _confirmedUser({required bool emailConfirmed}) {
    return AuthUserModel(
      id: stubbedUser.id,
      email: stubbedUser.email,
      createdAt: stubbedUser.createdAt,
      emailConfirmed: emailConfirmed,
      isNewUser: stubbedUser.isNewUser,
    );
  }
}
