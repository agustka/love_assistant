import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService implements IAuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  @override
  Stream<User?> get onAuthStateChanged => _client.auth.onAuthStateChange.map((AuthState event) => event.session?.user);

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Future<bool> signInWithGoogle() async {
    final bool success = await _client.auth.signInWithOAuth(OAuthProvider.google);
    return success;
  }

  @override
  Future<bool> signInWithApple() async {
    final bool success = await _client.auth.signInWithOAuth(OAuthProvider.apple);
    return success;
  }

  @override
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    final AuthResponse res = await _client.auth.signInWithPassword(email: email, password: password);
    return res.user != null && res.session != null;
  }

  @override
  Future<bool> signupWithEmailAndPassword(String email, String password) async {
    final AuthResponse res = await _client.auth.signUp(email: email, password: password);
    return res.user != null && res.session != null;
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
