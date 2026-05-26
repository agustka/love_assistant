import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/use_cases/use_case.dart';

@injectable
class HasActiveSessionUseCase implements IUseCase<bool> {
  final IAuthRepository _authRepository;

  const HasActiveSessionUseCase(this._authRepository);

  @override
  Future<Payload<bool>> execute() => _authRepository.hasActiveSession();
}
