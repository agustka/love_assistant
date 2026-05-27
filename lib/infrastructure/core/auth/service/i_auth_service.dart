import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";

abstract class IAuthService {
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials);
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials);
  Future<AuthUserModel> recheckEmailConfirmation(EmailPasswordCredentials credentials);
  Future<void> resendConfirmationEmail(EmailPasswordCredentials credentials);
  Future<void> signOut();
  Stream<AuthEventType> get authStateChanges;
}
