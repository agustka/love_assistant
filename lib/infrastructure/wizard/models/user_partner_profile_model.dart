import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_partner_profile_model.g.dart';

@immutable
@JsonSerializable()
class UserPartnerProfileModel {
  final String partnerName;
  final String partnerPronoun;
  final String customPronoun;
  final String? partnerBirthday;
  final List<String> partnerLoveLanguages;
  final String partnerToneOfVoice;
  final List<String> partnerFavoriteFoods;
  final List<String> partnerGiftCategories;
  @JsonKey(defaultValue: [])
  final List<String> partnerHobbies;
  final String? partnerAnniversary;
  @JsonKey(defaultValue: "")
  final String relationshipType;
  @JsonKey(defaultValue: false)
  final bool detailedProfileCompleted;

  const UserPartnerProfileModel({
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
    required this.partnerBirthday,
    required this.partnerLoveLanguages,
    required this.partnerToneOfVoice,
    required this.partnerFavoriteFoods,
    required this.partnerGiftCategories,
    this.partnerHobbies = const [],
    this.partnerAnniversary,
    this.relationshipType = "",
    this.detailedProfileCompleted = false,
  });

  factory UserPartnerProfileModel.fromJson(Map<String, dynamic> json) => _$UserPartnerProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPartnerProfileModelToJson(this);
}
