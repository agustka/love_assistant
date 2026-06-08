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
  final bool profileCtaDismissed;
  final bool profileCtaActionInProgress;

  bool get showProfileCompletionCta {
    return status == MainStatus.loaded &&
        partnerProfile.valid &&
        !partnerProfile.detailedProfileCompleted &&
        !profileCtaDismissed;
  }

  const MainState({
    required this.status,
    required this.partnerProfile,
    required this.profileCtaDismissed,
    required this.profileCtaActionInProgress,
  });

  const MainState.initial()
    : this(
        status: MainStatus.loading,
        partnerProfile: const UserPartnerProfile.invalid(),
        profileCtaDismissed: false,
        profileCtaActionInProgress: false,
      );

  MainState copyWith({
    MainStatus? status,
    UserPartnerProfile? partnerProfile,
    bool? profileCtaDismissed,
    bool? profileCtaActionInProgress,
  }) {
    return MainState(
      status: status ?? this.status,
      partnerProfile: partnerProfile ?? this.partnerProfile,
      profileCtaDismissed: profileCtaDismissed ?? this.profileCtaDismissed,
      profileCtaActionInProgress: profileCtaActionInProgress ?? this.profileCtaActionInProgress,
    );
  }

  @override
  List<Object?> get props => [
    status,
    partnerProfile,
    profileCtaDismissed,
    profileCtaActionInProgress,
  ];
}
