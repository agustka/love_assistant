import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "package:la/infrastructure/wizard/models/user_partner_profile_model.dart";

part "initial_partner_profile_data_model.g.dart";

@immutable
@JsonSerializable(includeIfNull: false)
class InitialPartnerProfileDataModel {
  final String? partnerName;
  final String? partnerPronoun;
  final String? customPronoun;
  final String? partnerBirthday;
  final List<String>? partnerLoveLanguages;
  final String? partnerToneOfVoice;
  final List<String>? partnerFavoriteFoods;
  final List<String>? partnerGiftCategories;
  final String? partnerAnniversary;

  const InitialPartnerProfileDataModel({
    this.partnerName,
    this.partnerPronoun,
    this.customPronoun,
    this.partnerBirthday,
    this.partnerLoveLanguages,
    this.partnerToneOfVoice,
    this.partnerFavoriteFoods,
    this.partnerGiftCategories,
    this.partnerAnniversary,
  });

  factory InitialPartnerProfileDataModel.fromJson(Map<String, dynamic> json) =>
      _$InitialPartnerProfileDataModelFromJson(json);

  factory InitialPartnerProfileDataModel.fromUserPartnerProfileModel(UserPartnerProfileModel model) {
    return InitialPartnerProfileDataModel(
      partnerName: _answeredString(model.partnerName),
      partnerPronoun: _answeredEnumName(model.partnerPronoun),
      customPronoun: _answeredString(model.customPronoun),
      partnerBirthday: model.partnerBirthday,
      partnerLoveLanguages: _answeredList(model.partnerLoveLanguages),
      partnerToneOfVoice: _answeredEnumName(model.partnerToneOfVoice),
      partnerFavoriteFoods: _answeredList(model.partnerFavoriteFoods),
      partnerGiftCategories: _answeredList(model.partnerGiftCategories),
      partnerAnniversary: model.partnerAnniversary,
    );
  }

  static String? _answeredString(String value) {
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  static String? _answeredEnumName(String value) {
    if (value.isEmpty || value == "invalid") {
      return null;
    }
    return value;
  }

  static List<String>? _answeredList(List<String> value) {
    final List<String> answered = value.where((String item) => item.isNotEmpty && item != "invalid").toList();
    if (answered.isEmpty) {
      return null;
    }
    return answered;
  }

  Map<String, dynamic> toJson() => _$InitialPartnerProfileDataModelToJson(this);
}
