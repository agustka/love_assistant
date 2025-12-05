part of 'signup_cubit.dart';

enum SignupMessage {
  errorLoggingIn,
}

enum SignupStatus {
  loading,
  success,
  failure,
}

class SignupState extends Equatable {
  final SignupStatus status;

  const SignupState({required this.status});

  const SignupState.initial() : status = SignupStatus.loading;

  SignupState copyWith({SignupStatus? status}) {
    return SignupState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    status,
  ];
}
