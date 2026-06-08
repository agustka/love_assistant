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
  final bool profileCtaActionInProgress;

  const MainState({
    required this.status,
    required this.partnerProfile,
    required this.profileCtaActionInProgress,
  });

  const MainState.initial()
    : this(
        status: MainStatus.loading,
        partnerProfile: const UserPartnerProfile.invalid(),
        profileCtaActionInProgress: false,
      );

  MainState copyWith({
    MainStatus? status,
    UserPartnerProfile? partnerProfile,
    bool? profileCtaActionInProgress,
  }) {
    return MainState(
      status: status ?? this.status,
      partnerProfile: partnerProfile ?? this.partnerProfile,
      profileCtaActionInProgress: profileCtaActionInProgress ?? this.profileCtaActionInProgress,
    );
  }

  @override
  List<Object?> get props => [
    status,
    partnerProfile,
    profileCtaActionInProgress,
  ];
}
