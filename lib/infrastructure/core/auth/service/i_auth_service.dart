import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/models/email_password_credentials_model.dart";

abstract class IAuthService {
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials);
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials);
  Future<void> signOut();
  Stream<AuthEventType> get authStateChanges;
}
