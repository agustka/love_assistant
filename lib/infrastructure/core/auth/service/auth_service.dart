import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: IAuthService)
class AuthService implements IAuthService {
  final SupabaseClient _client;

  AuthService(this._client);
}
