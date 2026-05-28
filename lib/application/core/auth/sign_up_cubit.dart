import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/auth/use_cases/create_account_use_case.dart';
import 'package:la/domain/core/auth/value_objects/password_strength_evaluator.dart';
import 'package:la/domain/core/entities/email_password_credentials.dart';
import 'package:la/domain/core/value_objects/email_value_object.dart';
import 'package:la/domain/core/value_objects/password_value_object.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/auth/auth_failure_reason.dart';
import 'package:la/infrastructure/core/auth/models/auth_user_model.dart';
import 'package:la/setup.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends BaseCubit<SignUpState> {
  static const PasswordStrengthEvaluator _strengthEvaluator = PasswordStrengthEvaluator();

  final CreateAccountUseCase _createAccountUseCase;

  SignUpCubit(this._createAccountUseCase) : super(const SignUpState.initial());

  void onEmailChanged(String input) {
    emit(state.copyWith(email: input, emailError: false, formError: SignUpFormError.none));
  }

  void onPasswordChanged(String input) {
    emit(
      state.copyWith(
        password: input,
        passwordError: false,
        passwordStrength: _strengthEvaluator.evaluate(input),
        formError: SignUpFormError.none,
      ),
    );
  }

  Future<void> signUp() async {
    if (state.status == SignUpStatus.submitting) {
      return;
    }

    final EmailValueObject email = EmailValueObject(state.email);
    final PasswordValueObject password = PasswordValueObject(state.password);
    final bool emailInvalid = email.isInvalid;
    final bool passwordInvalid = password.isInvalid;

    if (emailInvalid || passwordInvalid) {
      emit(state.copyWith(emailError: emailInvalid, passwordError: passwordInvalid));
      return;
    }

    emit(state.copyWith(status: SignUpStatus.submitting, formError: SignUpFormError.none));

    final EmailPasswordCredentials credentials = EmailPasswordCredentials(email: email, password: password);
    final Payload<AuthUserModel> result = await _createAccountUseCase.execute(credentials);

    if (result.succeeded) {
      emit(state.copyWith(status: SignUpStatus.success, credentials: credentials));
      getIt<EventBus>().fire(SignUpNavigateToConfirmationEvent(credentials: credentials));
      return;
    }

    _handleFailure(result.failure?.reference);
  }

  void _handleFailure(Object? reference) {
    final AuthFailureReason reason = reference is AuthFailureReason ? reference : AuthFailureReason.unexpectedError;
    switch (reason) {
      case AuthFailureReason.emailAlreadyRegistered:
        emit(state.copyWith(status: SignUpStatus.idle, formError: SignUpFormError.emailAlreadyRegistered));
      case AuthFailureReason.networkError:
        emit(state.copyWith(status: SignUpStatus.idle, formError: SignUpFormError.network));
      case AuthFailureReason.invalidEmail:
        emit(state.copyWith(status: SignUpStatus.idle, emailError: true));
      case AuthFailureReason.weakOrShortPassword:
        emit(state.copyWith(status: SignUpStatus.idle, passwordError: true));
      case AuthFailureReason.invalidCredentials:
      case AuthFailureReason.notYetConfirmed:
      case AuthFailureReason.rateLimited:
      case AuthFailureReason.unexpectedError:
        emit(state.copyWith(status: SignUpStatus.idle, formError: SignUpFormError.unexpected));
    }
  }
}
