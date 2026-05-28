import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/use_cases/use_case.dart";

@injectable
class CreateConfirmationEmailUseCase implements IUseCaseWith<EmailPasswordCredentials, void> {
  final IAuthRepository _repository;

  const CreateConfirmationEmailUseCase(this._repository);

  @override
  Future<Payload<void>> execute(EmailPasswordCredentials input) {
    return _repository.resendConfirmationEmail(input);
  }
}
