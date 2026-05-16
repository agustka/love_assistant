import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:la/infrastructure/core/auth/auth_event_type.dart';
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final IAuthService _authService;

  AuthRepository(this._authService);

  @override
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener}) {
    // TODO: implement subscribeToAuthEvents
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
