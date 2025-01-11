part of 'wizard_cubit.dart';

@immutable
class WizardEventGoToPage {
  final int page;

  const WizardEventGoToPage({required this.page});
}

enum WizardEvent {
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
  final String partnerName;
  final bool missingName;
  final Pronoun partnerPronoun;
  final String customPronoun;
  final bool missingPronoun;
  final bool missingCustomPronoun;
  final DateTime partnerBirthday;
  final bool missingBirthday;
  final DateTime partnerAnniversary;
  final bool loveLanguageMissing;
  final List<LoveLanguage> partnerLoveLanguages;
  final ToneOfVoice partnerToneOfVoice;
  final List<Hobby> partnerHobbies;

  const WizardState({
    required this.status,
    required this.isInitial,
    required this.partnerName,
    required this.missingName,
    required this.partnerPronoun,
    required this.customPronoun,
    required this.missingPronoun,
    required this.missingCustomPronoun,
    required this.partnerBirthday,
    required this.missingBirthday,
    required this.partnerAnniversary,
    required this.loveLanguageMissing,
    required this.partnerLoveLanguages,
    required this.partnerToneOfVoice,
    required this.partnerHobbies,
  });

  WizardState.initial()
      : this(
          status: WizardStatus.loading,
          isInitial: true,
          partnerName: "",
          missingName: false,
          partnerPronoun: Pronoun.invalid,
          customPronoun: "",
          missingPronoun: false,
          missingCustomPronoun: false,
          partnerBirthday: DateTime(1800),
          missingBirthday: false,
          partnerAnniversary: DateTime(1800),
          loveLanguageMissing: false,
          partnerLoveLanguages: [],
          partnerToneOfVoice: ToneOfVoice.invalid,
          partnerHobbies: [],
        );

  WizardState copyWith({
    WizardStatus? status,
    bool? isInitial,
    String? partnerName,
    bool? missingName,
    Pronoun? partnerPronoun,
    String? customPronoun,
    bool? missingPronoun,
    bool? missingCustomPronoun,
    DateTime? partnerBirthday,
    bool? missingBirthday,
    DateTime? partnerAnniversary,
    bool? loveLanguageMissing,
    List<LoveLanguage>? partnerLoveLanguages,
    ToneOfVoice? partnerToneOfVoice,
    List<Hobby>? partnerHobbies,
  }) {
    return WizardState(
      status: status ?? this.status,
      isInitial: isInitial ?? this.isInitial,
      partnerName: partnerName ?? this.partnerName,
      missingName: missingName ?? this.missingName,
      partnerPronoun: partnerPronoun ?? this.partnerPronoun,
      customPronoun: customPronoun ?? this.customPronoun,
      missingPronoun: missingPronoun ?? this.missingPronoun,
      missingCustomPronoun: missingCustomPronoun ?? this.missingCustomPronoun,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      missingBirthday: missingBirthday ?? this.missingBirthday,
      partnerAnniversary: partnerAnniversary ?? this.partnerAnniversary,
      loveLanguageMissing: loveLanguageMissing ?? this.loveLanguageMissing,
      partnerLoveLanguages: partnerLoveLanguages ?? this.partnerLoveLanguages,
      partnerToneOfVoice: partnerToneOfVoice ?? this.partnerToneOfVoice,
      partnerHobbies: partnerHobbies ?? this.partnerHobbies,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isInitial,
        partnerName,
        missingName,
        partnerPronoun,
        customPronoun,
        missingPronoun,
        missingCustomPronoun,
        partnerBirthday,
        missingBirthday,
        partnerAnniversary,
        loveLanguageMissing,
        partnerLoveLanguages,
        partnerToneOfVoice,
        partnerHobbies,
      ];
}
