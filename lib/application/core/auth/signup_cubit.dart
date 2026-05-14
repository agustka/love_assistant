import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';

part 'signup_state.dart';

@injectable
class SignupCubit extends BaseCubit<SignupState> {
  static const String emailConfirmationPendingErrorCode = "email_confirmation_pending";

  final IAuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupState.initial());

  Future<void> signupWithGoogle() async {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        clearErrorMessage: true,
        isCheckingEmailConfirmation: false,
      ),
    );

    try {
      await _authRepository.signInWithGoogle();
      emit(
        state.copyWith(
          status: SignupStatus.sessionEstablished,
          clearErrorMessage: true,
          isCheckingEmailConfirmation: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
          isCheckingEmailConfirmation: false,
        ),
      );
    }
  }

  Future<void> signupWithApple() async {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        clearErrorMessage: true,
        isCheckingEmailConfirmation: false,
      ),
    );

    try {
      await _authRepository.signInWithApple();
      emit(
        state.copyWith(
          status: SignupStatus.sessionEstablished,
          clearErrorMessage: true,
          isCheckingEmailConfirmation: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
          isCheckingEmailConfirmation: false,
        ),
      );
    }
  }

  Future<void> signupWithEmailAndPassword(String email, String password) async {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        clearErrorMessage: true,
        isCheckingEmailConfirmation: false,
      ),
    );

    try {
      final bool hasActiveSession = await _authRepository.signupWithEmailAndPassword(email, password);

      if (hasActiveSession) {
        emit(
          state.copyWith(
            status: SignupStatus.sessionEstablished,
            clearErrorMessage: true,
            isCheckingEmailConfirmation: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: SignupStatus.emailConfirmationRequired,
          clearErrorMessage: true,
          isCheckingEmailConfirmation: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: e.toString(),
          isCheckingEmailConfirmation: false,
        ),
      );
    }
  }

  Future<void> checkEmailConfirmed() async {
    emit(
      state.copyWith(
        status: SignupStatus.emailConfirmationRequired,
        clearErrorMessage: true,
        isCheckingEmailConfirmation: true,
      ),
    );

    final user = _authRepository.user$.valueOrNull;
    if (user != null) {
      emit(
        state.copyWith(
          status: SignupStatus.sessionEstablished,
          clearErrorMessage: true,
          isCheckingEmailConfirmation: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SignupStatus.emailConfirmationRequired,
        errorMessage: emailConfirmationPendingErrorCode,
        isCheckingEmailConfirmation: false,
      ),
    );
  }

  void cancelConfirmation() {
    emit(const SignupState.initial());
  }
}
