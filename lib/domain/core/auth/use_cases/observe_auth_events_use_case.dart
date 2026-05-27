import "package:injectable/injectable.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";

@injectable
class ObserveAuthEventsUseCase {
  final IAuthRepository _repository;

  const ObserveAuthEventsUseCase(this._repository);

  Stream<AuthEventType> observe() {
    return _repository.observeAuthEvents();
  }
}
