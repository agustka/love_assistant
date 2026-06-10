// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_partner_profile_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitialPartnerProfileDataModel _$InitialPartnerProfileDataModelFromJson(
  Map<String, dynamic> json,
) => InitialPartnerProfileDataModel(
  partnerName: json['partnerName'] as String?,
  partnerPronoun: json['partnerPronoun'] as String?,
  customPronoun: json['customPronoun'] as String?,
  partnerBirthday: json['partnerBirthday'] as String?,
  partnerLoveLanguages: (json['partnerLoveLanguages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  partnerToneOfVoice: json['partnerToneOfVoice'] as String?,
  partnerFavoriteFoods: (json['partnerFavoriteFoods'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  partnerGiftCategories: (json['partnerGiftCategories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  partnerAnniversary: json['partnerAnniversary'] as String?,
);

Map<String, dynamic> _$InitialPartnerProfileDataModelToJson(
  InitialPartnerProfileDataModel instance,
) => <String, dynamic>{
  'partnerName': ?instance.partnerName,
  'partnerPronoun': ?instance.partnerPronoun,
  'customPronoun': ?instance.customPronoun,
  'partnerBirthday': ?instance.partnerBirthday,
  'partnerLoveLanguages': ?instance.partnerLoveLanguages,
  'partnerToneOfVoice': ?instance.partnerToneOfVoice,
  'partnerFavoriteFoods': ?instance.partnerFavoriteFoods,
  'partnerGiftCategories': ?instance.partnerGiftCategories,
  'partnerAnniversary': ?instance.partnerAnniversary,
};
