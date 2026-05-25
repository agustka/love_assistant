import "package:injectable/injectable.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/models/email_password_credentials_model.dart";
import "package:la/setup.dart";

/// In-memory auth repository for the offline (test) environment.
///
/// Exposes [stubbedUser] so test builders can configure the user returned
/// by [signUp] and [signIn]. Set [throwOnSignUp], [throwOnSignIn], or
/// [throwOnLogout] to exercise failure paths at the repository boundary.
@InjectableEnv.offline
@LazySingleton(as: IAuthRepository)
class OfflineAuthRepository implements IAuthRepository {
  AuthUserModel stubbedUser = const AuthUserModel(
    id: "offline-user-id",
    email: "offline@example.com",
  );

  bool throwOnSignUp = false;
  bool throwOnSignIn = false;
  bool throwOnLogout = false;

  EmailPasswordCredentials? lastSignUpCredentials;
  EmailPasswordCredentials? lastSignInCredentials;
  bool didLogout = false;

  OfflineAuthRepository();

  @override
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener}) {}

  @override
  Future<void> logout() async {
    if (throwOnLogout) {
      return;
    }
    didLogout = true;
  }

  @override
  Future<Payload<AuthUserModel>> signUp(EmailPasswordCredentials credentials) async {
    lastSignUpCredentials = credentials;
    if (throwOnSignUp) {
      return Payload.failure(const Failure("OfflineAuthRepository forced signUp failure"));
    }
    return Payload.success(stubbedUser);
  }

  @override
  Future<Payload<AuthUserModel>> signIn(EmailPasswordCredentials credentials) async {
    lastSignInCredentials = credentials;
    if (throwOnSignIn) {
      return Payload.failure(const Failure("OfflineAuthRepository forced signIn failure"));
    }
    return Payload.success(stubbedUser);
  }
}
