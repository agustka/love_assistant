import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginWithApple() async {
    emit(LoginLoading());
    try {
      await _authRepository.signInWithApple();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
} 