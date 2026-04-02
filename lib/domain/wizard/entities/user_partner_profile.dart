import 'package:equatable/equatable.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';

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
