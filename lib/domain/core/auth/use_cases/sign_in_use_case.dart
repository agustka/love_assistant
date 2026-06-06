import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/use_cases/use_case.dart";

@injectable
class SignInUseCase implements IUseCaseWith<EmailPasswordCredentials, AuthUserModel> {
  final IAuthRepository _repository;

  const SignInUseCase(this._repository);

  @override
  Future<Payload<AuthUserModel>> execute(EmailPasswordCredentials input) {
    return _repository.signIn(input);
  }
}
