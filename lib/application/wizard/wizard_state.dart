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
  final String partnerName;
  final bool missingName;
  final Pronoun partnerPronoun;
  final bool missingPronoun;
  final DateTime partnerBirthday;
  final bool missingBirthday;
  final DateTime partnerAnniversary;

  const WizardState({
    required this.status,
    required this.partnerName,
    required this.missingName,
    required this.partnerPronoun,
    required this.missingPronoun,
    required this.partnerBirthday,
    required this.missingBirthday,
    required this.partnerAnniversary,
  });

  WizardState.initial()
      : this(
          status: WizardStatus.loading,
          partnerName: "",
          missingName: false,
          partnerPronoun: Pronoun.invalid,
          missingPronoun: false,
          partnerBirthday: DateTime(1800),
          missingBirthday: false,
          partnerAnniversary: DateTime(1800),
        );

  WizardState copyWith({
    WizardStatus? status,
    String? partnerName,
    bool? missingName,
    Pronoun? partnerPronoun,
    bool? missingPronoun,
    DateTime? partnerBirthday,
    bool? missingBirthday,
    DateTime? partnerAnniversary,
  }) {
    return WizardState(
      status: status ?? this.status,
      partnerName: partnerName ?? this.partnerName,
      missingName: missingName ?? this.missingName,
      partnerPronoun: partnerPronoun ?? this.partnerPronoun,
      missingPronoun: missingPronoun ?? this.missingPronoun,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      missingBirthday: missingBirthday ?? this.missingBirthday,
      partnerAnniversary: partnerAnniversary ?? this.partnerAnniversary,
    );
  }

  @override
  List<Object?> get props => [
        status,
        partnerName,
        missingName,
        partnerPronoun,
        missingPronoun,
        partnerBirthday,
        missingBirthday,
        partnerAnniversary,
      ];
}
