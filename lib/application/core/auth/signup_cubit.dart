import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:la/setup.dart';

part 'signup_state.dart';

@injectable
class SignupCubit extends Cubit<SignupState> {
  final IAuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupState.initial());

  Future<void> signupWithGoogle() async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      getIt<EventBus>().fire(SignupMessage.errorLoggingIn);
    }
  }

  Future<void> signupWithApple() async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      await _authRepository.signInWithApple();
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure));
    }
  }

  Future<void> signupWithEmailAndPassword(String email, String password) async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      await _authRepository.signupWithEmailAndPassword(email, password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure));
    }
  }
}
