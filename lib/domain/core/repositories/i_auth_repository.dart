import 'package:la/infrastructure/core/auth/auth_event_type.dart';

abstract class IAuthRepository {
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener});

  Future<void> logout();
}
