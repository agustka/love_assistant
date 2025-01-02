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
  final bool missingPronoun;
  final DateTime partnerBirthday;
  final bool missingBirthday;
  final DateTime partnerAnniversary;
  final bool loveLanguageMissing;

  const WizardState({
    required this.status,
    required this.isInitial,
    required this.partnerName,
    required this.missingName,
    required this.partnerPronoun,
    required this.missingPronoun,
    required this.partnerBirthday,
    required this.missingBirthday,
    required this.partnerAnniversary,
    required this.loveLanguageMissing,
  });

  WizardState.initial()
      : this(
          status: WizardStatus.loading,
          isInitial: true,
          partnerName: "",
          missingName: false,
          partnerPronoun: Pronoun.invalid,
          missingPronoun: false,
          partnerBirthday: DateTime(1800),
          missingBirthday: false,
          partnerAnniversary: DateTime(1800),
          loveLanguageMissing: false,
        );

  WizardState copyWith({
    WizardStatus? status,
    bool? isInitial,
    String? partnerName,
    bool? missingName,
    Pronoun? partnerPronoun,
    bool? missingPronoun,
    DateTime? partnerBirthday,
    bool? missingBirthday,
    DateTime? partnerAnniversary,
    bool? loveLanguageMissing,
  }) {
    return WizardState(
      status: status ?? this.status,
      isInitial: isInitial ?? this.isInitial,
      partnerName: partnerName ?? this.partnerName,
      missingName: missingName ?? this.missingName,
      partnerPronoun: partnerPronoun ?? this.partnerPronoun,
      missingPronoun: missingPronoun ?? this.missingPronoun,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      missingBirthday: missingBirthday ?? this.missingBirthday,
      partnerAnniversary: partnerAnniversary ?? this.partnerAnniversary,
      loveLanguageMissing: loveLanguageMissing ?? this.loveLanguageMissing,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isInitial,
        partnerName,
        missingName,
        partnerPronoun,
        missingPronoun,
        partnerBirthday,
        missingBirthday,
        partnerAnniversary,
        loveLanguageMissing,
      ];
}
