import 'package:equatable/equatable.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/infrastructure/wizard/models/user_partner_profile_model.dart';

class UserPartnerProfile extends Equatable {
  final String partnerName;
  final Pronoun partnerPronoun;
  final String customPronoun;
  final DateTime? partnerBirthday;
  final List<LoveLanguage> partnerLoveLanguages;
  final ToneOfVoice partnerToneOfVoice;
  final List<FavoriteFood> partnerFavoriteFoods;
  final List<GiftCategory> partnerGiftCategories;

  const UserPartnerProfile({
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
    required this.partnerBirthday,
    required this.partnerLoveLanguages,
    required this.partnerToneOfVoice,
    required this.partnerFavoriteFoods,
    required this.partnerGiftCategories,
  });

  factory UserPartnerProfile.fromModel(UserPartnerProfileModel model) {
    return UserPartnerProfile(
      partnerName: model.partnerName,
      partnerPronoun: _enumByName(Pronoun.values, model.partnerPronoun, Pronoun.invalid),
      customPronoun: model.customPronoun,
      partnerBirthday: _dateOrNull(model.partnerBirthday),
      partnerLoveLanguages: model.partnerLoveLanguages
          .map((String e) => _enumByName(LoveLanguage.values, e, LoveLanguage.invalid))
          .toList(),
      partnerToneOfVoice: _enumByName(ToneOfVoice.values, model.partnerToneOfVoice, ToneOfVoice.invalid),
      partnerFavoriteFoods: model.partnerFavoriteFoods
          .map((String e) => _enumByName(FavoriteFood.values, e, FavoriteFood.invalid))
          .toList(),
      partnerGiftCategories: model.partnerGiftCategories
          .map((String e) => _enumByName(GiftCategory.values, e, GiftCategory.invalid))
          .toList(),
    );
  }

  static T _enumByName<T extends Enum>(List<T> values, String name, T fallback) {
    for (final T value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return fallback;
  }

  static DateTime? _dateOrNull(String? iso) {
    if (iso == null) {
      return null;
    }
    return DateTime.tryParse(iso);
  }

  UserPartnerProfileModel toModel() {
    return UserPartnerProfileModel(
      partnerName: partnerName,
      partnerPronoun: partnerPronoun.name,
      customPronoun: customPronoun,
      partnerBirthday: partnerBirthday?.toIso8601String(),
      partnerLoveLanguages: partnerLoveLanguages.map((LoveLanguage e) => e.name).toList(),
      partnerToneOfVoice: partnerToneOfVoice.name,
      partnerFavoriteFoods: partnerFavoriteFoods.map((FavoriteFood e) => e.name).toList(),
      partnerGiftCategories: partnerGiftCategories.map((GiftCategory e) => e.name).toList(),
    );
  }

  @override
  List<Object?> get props => [
    partnerName,
    partnerPronoun,
    customPronoun,
    partnerBirthday,
    partnerLoveLanguages,
    partnerToneOfVoice,
    partnerFavoriteFoods,
    partnerGiftCategories,
  ];
}
