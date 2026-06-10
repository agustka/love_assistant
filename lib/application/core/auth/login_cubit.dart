import "package:equatable/equatable.dart";
import "package:event_bus/event_bus.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";
import "package:la/application/core/base_cubit.dart";
import "package:la/domain/core/auth/use_cases/sign_in_use_case.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/value_objects/email_value_object.dart";
import "package:la/domain/core/value_objects/password_value_object.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/use_cases/sync_authenticated_partner_profile_use_case.dart";
import "package:la/infrastructure/core/auth/auth_failure_reason.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/setup.dart";

part "login_state.dart";

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  final SignInUseCase _signInUseCase;
  final SyncAuthenticatedPartnerProfileUseCase _syncAuthenticatedPartnerProfileUseCase;

  LoginCubit(
    this._signInUseCase,
    this._syncAuthenticatedPartnerProfileUseCase,
  ) : super(LoginState.initial());

  void onEmailChanged(String input) {
    emit(state.copyWith(email: input, emailError: false, formError: LoginFormError.none));
  }

  void onPasswordChanged(String input) {
    emit(state.copyWith(password: input, passwordError: false, formError: LoginFormError.none));
  }

  Future<void> login() async {
    if (state.status == LoginStatus.submitting) {
      return;
    }

    final EmailValueObject email = EmailValueObject(state.email);
    if (email.isInvalid) {
      emit(state.copyWith(emailError: true));
      getIt<EventBus>().fire(LoginEvent.ensureEmailVisible);
      return;
    }

    final PasswordValueObject password = PasswordValueObject(state.password);
    if (password.isInvalid) {
      emit(state.copyWith(passwordError: true));
      getIt<EventBus>().fire(LoginEvent.ensurePasswordVisible);
      return;
    }

    final EmailPasswordCredentials credentials = EmailPasswordCredentials(email: email, password: password);
    emit(
      state.copyWith(
        status: LoginStatus.submitting,
        formError: LoginFormError.none,
        credentials: credentials,
      ),
    );

    final Payload<AuthUserModel> result = await _signInUseCase.execute(credentials);

    if (result.succeeded) {
      emit(state.copyWith(status: LoginStatus.success));
      await _syncAuthenticatedPartnerProfileUseCase.execute();
      getIt<EventBus>().fire(const LoginNavigateToMainEvent());
      return;
    }

    _handleFailure(result.failure?.reference, credentials);
  }

  void _handleFailure(Object? reference, EmailPasswordCredentials credentials) {
    final AuthFailureReason reason = reference is AuthFailureReason ? reference : AuthFailureReason.unexpectedError;
    switch (reason) {
      case AuthFailureReason.invalidCredentials:
        emit(state.copyWith(status: LoginStatus.idle, formError: LoginFormError.invalidCredentials));
      case AuthFailureReason.notYetConfirmed:
        emit(state.copyWith(status: LoginStatus.idle));
        getIt<EventBus>().fire(LoginNavigateToEmailConfirmationEvent(credentials: credentials));
      case AuthFailureReason.networkError:
        emit(state.copyWith(status: LoginStatus.idle, formError: LoginFormError.network));
      case AuthFailureReason.invalidEmail:
        emit(state.copyWith(status: LoginStatus.idle, emailError: true));
      case AuthFailureReason.weakOrShortPassword:
        emit(state.copyWith(status: LoginStatus.idle, passwordError: true));
      case AuthFailureReason.emailAlreadyRegistered:
      case AuthFailureReason.rateLimited:
      case AuthFailureReason.unexpectedError:
        emit(state.copyWith(status: LoginStatus.idle, formError: LoginFormError.unexpected));
    }
  }
}
