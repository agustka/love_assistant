import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/models/email_password_credentials_model.dart";

abstract class IAuthRepository {
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener});

  Future<void> logout();

  Future<Payload<AuthUserModel>> signUp(EmailPasswordCredentials credentials);

  Future<Payload<AuthUserModel>> signIn(EmailPasswordCredentials credentials);
}
