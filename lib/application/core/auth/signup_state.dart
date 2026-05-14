part of 'signup_cubit.dart';

enum SignupStatus {
  idle,
  loading,
  emailConfirmationRequired,
  sessionEstablished,
  failure,
}

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;
  final bool isCheckingEmailConfirmation;

  const SignupState({
    required this.status,
    this.errorMessage,
    required this.isCheckingEmailConfirmation,
  });

  const SignupState.initial() : status = SignupStatus.idle, errorMessage = null, isCheckingEmailConfirmation = false;

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isCheckingEmailConfirmation,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isCheckingEmailConfirmation: isCheckingEmailConfirmation ?? this.isCheckingEmailConfirmation,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    errorMessage,
    isCheckingEmailConfirmation,
  ];
}
