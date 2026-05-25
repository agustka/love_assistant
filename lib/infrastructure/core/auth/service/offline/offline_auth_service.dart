import "dart:async";

import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/setup.dart";

/// In-memory auth service for the offline (test) environment.
///
/// This is the only auth boundary that is faked offline — the real
/// [AuthRepository] runs unchanged on top of it, so its validation, error
/// mapping, and payload handling are exercised against stubbed responses.
///
/// Returns a configurable [stubbedUser] from sign-up and sign-in. Set
/// [throwOnSignUp], [throwOnSignIn], or [throwOnSignOut] to exercise failure
/// paths. Inspect [lastSignUpCredentials], [lastSignInCredentials], and
/// [didSignOut] to assert what the repository forwarded. Use [emitAuthEvent]
/// to push events onto [authStateChanges].
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
  EmailPasswordCredentials? lastSignUpCredentials;
  EmailPasswordCredentials? lastSignInCredentials;
  bool didSignOut = false;
  final StreamController<AuthEventType> _authStateController = StreamController<AuthEventType>.broadcast();

  @override
  Stream<AuthEventType> get authStateChanges => _authStateController.stream;

  OfflineAuthService();

  void emitAuthEvent(AuthEventType event) => _authStateController.add(event);

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    lastSignUpCredentials = credentials;
    if (throwOnSignUp) {
      throw Exception("OfflineAuthService forced signUp failure");
    }
    return stubbedUser;
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
  Future<void> signOut() async {
    if (throwOnSignOut) {
      throw Exception("OfflineAuthService forced signOut failure");
    }
    didSignOut = true;
  }
}
