import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';

part 'signup_state.dart';

@injectable
class SignupCubit extends Cubit<SignupState> {
  final IAuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupInitial());

  Future<void> signupWithGoogle() async {
    emit(SignupLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> signupWithApple() async {
    emit(SignupLoading());
    try {
      await _authRepository.signInWithApple();
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<void> signupWithEmailAndPassword(String email, String password) async {
    emit(SignupLoading());
    try {
      await _authRepository.signupWithEmailAndPassword(email, password);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
