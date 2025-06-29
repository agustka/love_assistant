part of 'wizard_cubit.dart';

@immutable
class WizardEventGoToPage {
  final int page;

  const WizardEventGoToPage({required this.page});
}

enum WizardEvent {
  missingName,
  missingPronoun,
  missingBirthday,
  confirmNoAnniversary,
}

enum WizardStatus {
  loading,
  loaded,
  error;
}

@immutable
class WizardState extends Equatable {
  final WizardStatus status;
  final bool isInitial;
  final WizardConfig config;
  final String partnerName;
  final Pronoun partnerPronoun;
  final String customPronoun;
  final DateTime partnerBirthday;
  final DateTime partnerAnniversary;
  final List<LoveLanguage> partnerLoveLanguages;
  final ToneOfVoice partnerToneOfVoice;
  final List<Hobby> partnerHobbies;

  const WizardState({
    required this.status,
    required this.isInitial,
    required this.config,
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
    required this.partnerBirthday,
    required this.partnerAnniversary,
    required this.partnerLoveLanguages,
    required this.partnerToneOfVoice,
    required this.partnerHobbies,
  });

  WizardState.initial()
      : this(
          status: WizardStatus.loading,
          isInitial: true,
          config: WizardConfig.initial,
          partnerName: "",
          partnerPronoun: Pronoun.invalid,
          customPronoun: "",
          partnerBirthday: DateTime(1800),
          partnerAnniversary: DateTime(1800),
          partnerLoveLanguages: [],
          partnerToneOfVoice: ToneOfVoice.invalid,
          partnerHobbies: [],
        );

  WizardState copyWith({
    WizardStatus? status,
    bool? isInitial,
    WizardConfig? config,
    String? partnerName,
    bool? missingName,
    Pronoun? partnerPronoun,
    String? customPronoun,
    DateTime? partnerBirthday,
    DateTime? partnerAnniversary,
    List<LoveLanguage>? partnerLoveLanguages,
    ToneOfVoice? partnerToneOfVoice,
    List<Hobby>? partnerHobbies,
  }) {
    return WizardState(
      status: status ?? this.status,
      isInitial: isInitial ?? this.isInitial,
      config: config ?? this.config,
      partnerName: partnerName ?? this.partnerName,
      partnerPronoun: partnerPronoun ?? this.partnerPronoun,
      customPronoun: customPronoun ?? this.customPronoun,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      partnerAnniversary: partnerAnniversary ?? this.partnerAnniversary,
      partnerLoveLanguages: partnerLoveLanguages ?? this.partnerLoveLanguages,
      partnerToneOfVoice: partnerToneOfVoice ?? this.partnerToneOfVoice,
      partnerHobbies: partnerHobbies ?? this.partnerHobbies,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isInitial,
        config,
        partnerName,
        partnerPronoun,
        customPronoun,
        partnerBirthday,
        partnerAnniversary,
        partnerLoveLanguages,
        partnerToneOfVoice,
        partnerHobbies,
      ];
}
