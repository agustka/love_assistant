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
