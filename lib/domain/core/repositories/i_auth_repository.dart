import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository {
  ValueStream<User?> get user$;

  @experimental
  Future<void> signInWithGoogle();

  @experimental
  Future<void> signInWithApple();

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> signupWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}
