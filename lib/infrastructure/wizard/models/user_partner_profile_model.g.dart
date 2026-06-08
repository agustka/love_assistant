// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_partner_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPartnerProfileModel _$UserPartnerProfileModelFromJson(
  Map<String, dynamic> json,
) => UserPartnerProfileModel(
  partnerName: json['partnerName'] as String,
  partnerPronoun: json['partnerPronoun'] as String,
  customPronoun: json['customPronoun'] as String,
  partnerBirthday: json['partnerBirthday'] as String?,
  partnerLoveLanguages: (json['partnerLoveLanguages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  partnerToneOfVoice: json['partnerToneOfVoice'] as String,
  partnerFavoriteFoods: (json['partnerFavoriteFoods'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  partnerGiftCategories: (json['partnerGiftCategories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  partnerHobbies:
      (json['partnerHobbies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  partnerAnniversary: json['partnerAnniversary'] as String?,
  relationshipType: json['relationshipType'] as String? ?? '',
  detailedProfileCompleted: json['detailedProfileCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$UserPartnerProfileModelToJson(
  UserPartnerProfileModel instance,
) => <String, dynamic>{
  'partnerName': instance.partnerName,
  'partnerPronoun': instance.partnerPronoun,
  'customPronoun': instance.customPronoun,
  'partnerBirthday': instance.partnerBirthday,
  'partnerLoveLanguages': instance.partnerLoveLanguages,
  'partnerToneOfVoice': instance.partnerToneOfVoice,
  'partnerFavoriteFoods': instance.partnerFavoriteFoods,
  'partnerGiftCategories': instance.partnerGiftCategories,
  'partnerHobbies': instance.partnerHobbies,
  'partnerAnniversary': instance.partnerAnniversary,
  'relationshipType': instance.relationshipType,
  'detailedProfileCompleted': instance.detailedProfileCompleted,
};
