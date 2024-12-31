part of 'wizard_cubit.dart';

enum WizardStatus {
  loading,
  loaded,
  error;
}

@immutable
class WizardState extends Equatable {
  final WizardStatus status;

  const WizardState({
    required this.status,
  });

  const WizardState.initial()
      : this(
          status: WizardStatus.loading,
        );

  WizardState copyWith({
    WizardStatus? status,
  }) {
    return WizardState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
