import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final IAuthService _authService;
  final BehaviorSubject<User?> _userSubject;

  AuthRepository(this._authService)
      : _userSubject = BehaviorSubject<User?>.seeded(_authService.currentUser) {
    _authService.onAuthStateChanged.listen(_userSubject.add);
  }

  @override
  ValueStream<User?> get user$ => _userSubject.stream;

  @override
  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  @override
  Future<void> signInWithApple() async {
    await _authService.signInWithApple();
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signupWithEmailAndPassword(String email, String password) async {
    await _authService.signupWithEmailAndPassword(email, password);
  }
}
