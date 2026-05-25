import "dart:async";

import "package:injectable/injectable.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/models/email_password_credentials_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/setup.dart";

/// In-memory auth service for the offline (test) environment.
///
/// Returns a configurable [stubbedUser] so test builders can inspect
/// the authenticated user returned by sign-up and sign-in operations.
/// Set [throwOnSignUp] or [throwOnSignIn] to exercise failure paths.
/// Use [emitAuthEvent] to push events onto [authStateChanges] in tests.
@InjectableEnv.offline
@LazySingleton(as: IAuthService)
class OfflineAuthService implements IAuthService {
  AuthUserModel stubbedUser = const AuthUserModel(
    id: "offline-user-id",
    email: "offline@example.com",
  );

  bool throwOnSignUp = false;
  bool throwOnSignIn = false;

  final StreamController<AuthEventType> _authStateController =
      StreamController<AuthEventType>.broadcast();

  OfflineAuthService();

  @override
  Stream<AuthEventType> get authStateChanges => _authStateController.stream;

  void emitAuthEvent(AuthEventType event) => _authStateController.add(event);

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    if (throwOnSignUp) {
      throw Exception("OfflineAuthService forced signUp failure");
    }
    return stubbedUser;
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    if (throwOnSignIn) {
      throw Exception("OfflineAuthService forced signIn failure");
    }
    return stubbedUser;
  }

  @override
  Future<void> signOut() async {}
}
