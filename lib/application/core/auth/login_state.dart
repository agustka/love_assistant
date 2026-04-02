part of 'login_cubit.dart';

enum LoginStatus {
  idle,
  loading,
  success,
  failure,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    required this.status,
    this.errorMessage,
  });

  const LoginState.initial()
      : status = LoginStatus.idle,
        errorMessage = null;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, errorMessage];
}
