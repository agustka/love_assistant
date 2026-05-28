import "package:injectable/injectable.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/stream_payload.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/use_cases/use_case.dart";

@injectable
class WatchAuthEventsUseCase implements IStreamUseCase<AuthEventType> {
  final IAuthRepository _repository;

  const WatchAuthEventsUseCase(this._repository);

  @override
  Stream<StreamPayload<AuthEventType>> subscribe() {
    return _repository.observeAuthEvents().map(StreamPayload<AuthEventType>.success);
  }

  @override
  Future<void> reload() async {}

  @override
  Future<void> refresh({required bool forceGet}) async {}
}
