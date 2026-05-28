part of 'sign_up_cubit.dart';

@immutable
class SignUpNavigateToConfirmationEvent {
  final EmailPasswordCredentials credentials;

  const SignUpNavigateToConfirmationEvent({required this.credentials});
}

enum SignUpStatus {
  idle,
  submitting,
  success,
}

enum SignUpFormError {
  none,
  emailAlreadyRegistered,
  network,
  unexpected,
}

@immutable
class SignUpState extends Equatable {
  final SignUpStatus status;
  final String email;
  final String password;
  final PasswordStrength passwordStrength;
  final bool emailError;
  final bool passwordError;
  final SignUpFormError formError;
  final EmailPasswordCredentials credentials;

  bool get isSubmitting => status == SignUpStatus.submitting;

  const SignUpState({
    required this.status,
    required this.email,
    required this.password,
    required this.passwordStrength,
    required this.emailError,
    required this.passwordError,
    required this.formError,
    required this.credentials,
  });

  SignUpState.initial()
    : this(
        status: SignUpStatus.idle,
        email: "",
        password: "",
        passwordStrength: PasswordStrength.tooShort,
        emailError: false,
        passwordError: false,
        formError: SignUpFormError.none,
        credentials: EmailPasswordCredentials.empty(),
      );

  SignUpState copyWith({
    SignUpStatus? status,
    String? email,
    String? password,
    PasswordStrength? passwordStrength,
    bool? emailError,
    bool? passwordError,
    SignUpFormError? formError,
    EmailPasswordCredentials? credentials,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordStrength: passwordStrength ?? this.passwordStrength,
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
    passwordStrength,
    emailError,
    passwordError,
    formError,
    credentials,
  ];
}
