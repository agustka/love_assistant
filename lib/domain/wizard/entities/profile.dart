import 'package:equatable/equatable.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';

class Profile extends Equatable {
  final String partnerName;
  final Pronoun partnerPronoun;
  final String? customPronoun;
  final DateTime partnerBirthday;
  final DateTime? partnerAnniversary;
  final List<LoveLanguage> partnerLoveLanguages;
  final ToneOfVoice partnerToneOfVoice;
  final List<Hobby> partnerHobbies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.partnerName,
    required this.partnerPronoun,
    this.customPronoun,
    required this.partnerBirthday,
    this.partnerAnniversary,
    required this.partnerLoveLanguages,
    required this.partnerToneOfVoice,
    required this.partnerHobbies,
    required this.createdAt,
    required this.updatedAt,
  });

  Profile copyWith({
    String? partnerName,
    Pronoun? partnerPronoun,
    String? customPronoun,
    DateTime? partnerBirthday,
    DateTime? partnerAnniversary,
    List<LoveLanguage>? partnerLoveLanguages,
    ToneOfVoice? partnerToneOfVoice,
    List<Hobby>? partnerHobbies,
    DateTime? updatedAt,
  }) {
    return Profile(
      partnerName: partnerName ?? this.partnerName,
      partnerPronoun: partnerPronoun ?? this.partnerPronoun,
      customPronoun: customPronoun ?? this.customPronoun,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      partnerAnniversary: partnerAnniversary ?? this.partnerAnniversary,
      partnerLoveLanguages: partnerLoveLanguages ?? this.partnerLoveLanguages,
      partnerToneOfVoice: partnerToneOfVoice ?? this.partnerToneOfVoice,
      partnerHobbies: partnerHobbies ?? this.partnerHobbies,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        partnerName,
        partnerPronoun,
        customPronoun,
        partnerBirthday,
        partnerAnniversary,
        partnerLoveLanguages,
        partnerToneOfVoice,
        partnerHobbies,
        createdAt,
        updatedAt,
      ];
}
