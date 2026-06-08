part of 'main_cubit.dart';

@immutable
class MainOpenDetailedProfileWizardEvent {
  const MainOpenDetailedProfileWizardEvent();
}

enum MainStatus {
  loading,
  loaded,
}

@immutable
class MainState extends Equatable {
  final MainStatus status;
  final UserPartnerProfile partnerProfile;

  const MainState({
    required this.status,
    required this.partnerProfile,
  });

  const MainState.initial()
    : this(
        status: MainStatus.loading,
        partnerProfile: const UserPartnerProfile.invalid(),
      );

  MainState copyWith({
    MainStatus? status,
    UserPartnerProfile? partnerProfile,
  }) {
    return MainState(
      status: status ?? this.status,
      partnerProfile: partnerProfile ?? this.partnerProfile,
    );
  }

  @override
  List<Object?> get props => [
    status,
    partnerProfile,
  ];
}
