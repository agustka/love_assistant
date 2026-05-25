import "package:injectable/injectable.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/models/email_password_credentials_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/setup.dart";
import "package:supabase_flutter/supabase_flutter.dart";

@InjectableEnv.online
@LazySingleton(as: IAuthService)
class AuthService implements IAuthService {
  const AuthService(this._client);

  final SupabaseClient _client;

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    final AuthResponse response = await _client.auth.signUp(
      email: credentials.email,
      password: credentials.password,
    );
    final User? user = response.user;
    if (user == null) {
      throw const AuthException("Sign up succeeded but no user was returned");
    }
    return AuthUserModel.fromSupabaseUser(user);
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword(EmailPasswordCredentials credentials) async {
    final AuthResponse response = await _client.auth.signInWithPassword(
      email: credentials.email,
      password: credentials.password,
    );
    final User? user = response.user;
    if (user == null) {
      throw const AuthException("Sign in succeeded but no user was returned");
    }
    return AuthUserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Stream<AuthEventType> get authStateChanges => _client.auth.onAuthStateChange
      .map((AuthState state) => _mapEvent(state))
      .where((AuthEventType? event) => event != null)
      .cast<AuthEventType>();

  AuthEventType? _mapEvent(AuthState state) => switch (state.event) {
        AuthChangeEvent.signedIn => AuthEventType.login,
        AuthChangeEvent.signedOut => AuthEventType.logout,
        AuthChangeEvent.initialSession => state.session != null ? AuthEventType.login : null,
        _ => null,
      };
}
