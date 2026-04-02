import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState.initial());

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loginWithApple() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithApple();
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
