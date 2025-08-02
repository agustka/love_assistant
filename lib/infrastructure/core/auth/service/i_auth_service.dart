import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  Stream<User?> get onAuthStateChanged;

  User? get currentUser;

  Future<bool> signInWithGoogle();

  Future<bool> signInWithApple();

  Future<bool> signInWithEmailAndPassword(String email, String password);

  Future<bool> signupWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}
