import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/core/value_objects/stream_payload.dart';

abstract interface class IStreamUseCase<Output> {
  Stream<StreamPayload<Output>> subscribe();
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}

abstract interface class IStreamUseCaseWith<Input, Output> {
  Stream<StreamPayload<Output>> subscribe(Input input);
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}

abstract interface class IUseCase<Output> {
  Future<Payload<Output>> execute();
}

abstract interface class IUseCaseWith<Input, Output> {
  Future<Payload<Output>> execute(Input input);
}
