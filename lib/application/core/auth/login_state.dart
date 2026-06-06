part of "login_cubit.dart";

@immutable
class LoginNavigateToMainEvent {
  const LoginNavigateToMainEvent();
}

@immutable
class LoginNavigateToEmailConfirmationEvent {
  final EmailPasswordCredentials credentials;

  const LoginNavigateToEmailConfirmationEvent({required this.credentials});
}

enum LoginEvent {
  ensureEmailVisible,
  ensurePasswordVisible,
}

enum LoginStatus {
  idle,
  submitting,
  success,
}

enum LoginFormError {
  none,
  invalidCredentials,
  network,
  unexpected,
}

@immutable
class LoginState extends Equatable {
  final LoginStatus status;
  final String email;
  final String password;
  final bool emailError;
  final bool passwordError;
  final LoginFormError formError;
  final EmailPasswordCredentials credentials;

  bool get isSubmitting => status == LoginStatus.submitting;

  const LoginState({
    required this.status,
    required this.email,
    required this.password,
    required this.emailError,
    required this.passwordError,
    required this.formError,
    required this.credentials,
  });

  LoginState.initial()
    : this(
        status: LoginStatus.idle,
        email: "",
        password: "",
        emailError: false,
        passwordError: false,
        formError: LoginFormError.none,
        credentials: EmailPasswordCredentials.empty(),
      );

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    bool? emailError,
    bool? passwordError,
    LoginFormError? formError,
    EmailPasswordCredentials? credentials,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      formError: formError ?? this.formError,
      credentials: credentials ?? this.credentials,
    );
  }

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    emailError,
    passwordError,
    formError,
    credentials,
  ];
}
