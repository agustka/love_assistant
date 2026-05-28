part of 'email_confirmation_cubit.dart';

@immutable
class EmailConfirmationNavigateToMainEvent {
  const EmailConfirmationNavigateToMainEvent();
}

@immutable
class EmailConfirmationResendSucceededEvent {
  const EmailConfirmationResendSucceededEvent();
}

@immutable
class EmailConfirmationResendFailedEvent {
  const EmailConfirmationResendFailedEvent();
}

enum EmailConfirmationStatus {
  idle,
  rechecking,
  confirmed,
}

enum RecheckMessage {
  none,
  pending,
  network,
  unexpected,
}

@immutable
class EmailConfirmationState extends Equatable {
  final EmailConfirmationStatus status;
  final RecheckMessage recheckMessage;
  final bool resendEnabled;
  final int cooldownRemaining;
  final EmailPasswordCredentials? credentials;

  bool get isRechecking => status == EmailConfirmationStatus.rechecking;

  const EmailConfirmationState({
    required this.status,
    required this.recheckMessage,
    required this.resendEnabled,
    required this.cooldownRemaining,
    required this.credentials,
  });

  const EmailConfirmationState.initial()
    : this(
        status: EmailConfirmationStatus.idle,
        recheckMessage: RecheckMessage.none,
        resendEnabled: true,
        cooldownRemaining: 0,
        credentials: null,
      );

  EmailConfirmationState copyWith({
    EmailConfirmationStatus? status,
    RecheckMessage? recheckMessage,
    bool? resendEnabled,
    int? cooldownRemaining,
    EmailPasswordCredentials? credentials,
  }) {
    return EmailConfirmationState(
      status: status ?? this.status,
      recheckMessage: recheckMessage ?? this.recheckMessage,
      resendEnabled: resendEnabled ?? this.resendEnabled,
      cooldownRemaining: cooldownRemaining ?? this.cooldownRemaining,
      credentials: credentials ?? this.credentials,
    );
  }

  @override
  List<Object?> get props => [
    status,
    recheckMessage,
    resendEnabled,
    cooldownRemaining,
    credentials,
  ];
}
