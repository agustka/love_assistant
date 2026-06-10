import "package:flutter_test/flutter_test.dart";
import "package:la/domain/core/value_objects/favorite_food_value_object.dart";
import "package:la/domain/core/value_objects/gift_ideas_value_object.dart";
import "package:la/domain/core/value_objects/hobby_value_object.dart";
import "package:la/domain/core/value_objects/love_language_value_object.dart";
import "package:la/domain/core/value_objects/pronoun_value_object.dart";
import "package:la/domain/core/value_objects/relationship_type_value_object.dart";
import "package:la/domain/core/value_objects/tone_of_voice_value_object.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/wizard/models/initial_partner_profile_data_model.dart";
import "package:la/infrastructure/wizard/models/user_partner_profile_model.dart";

UserPartnerProfile _initialProfile() {
  return const UserPartnerProfile(
    partnerName: "Alex",
    partnerPronoun: Pronoun.theyThem,
    customPronoun: "",
    partnerBirthday: null,
    partnerLoveLanguages: [LoveLanguage.qualityTime],
    partnerToneOfVoice: ToneOfVoice.playful,
    partnerFavoriteFoods: [FavoriteFood.pizza],
    partnerGiftCategories: [GiftCategory.experience],
  );
}

UserPartnerProfile _detailedRemoteProfile() {
  return const UserPartnerProfile(
    partnerName: "OldName",
    partnerPronoun: Pronoun.sheHer,
    customPronoun: "",
    partnerBirthday: null,
    partnerLoveLanguages: [LoveLanguage.actsOfService],
    partnerToneOfVoice: ToneOfVoice.romantic,
    partnerFavoriteFoods: [FavoriteFood.seafood],
    partnerGiftCategories: [GiftCategory.experience],
    partnerHobbies: [Hobby.gaming, Hobby.cooking],
    relationshipType: RelationshipType.lifePartners,
    detailedProfileCompleted: true,
  );
}

Map<String, dynamic> _mergeInitialIntoExisting(UserPartnerProfile existing, UserPartnerProfile initial) {
  final Map<String, dynamic> existingData = existing.toModel().toJson();
  final Map<String, dynamic> initialData = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
    initial.toModel(),
  ).toJson();
  return {...existingData, ...initialData};
}

void main() {
  group("InitialPartnerProfileDataModel serialization", () {
    test("extracts only initial profile fields from a full profile model", () {
      final UserPartnerProfile profile = _initialProfile();
      final InitialPartnerProfileDataModel model = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
        profile.toModel(),
      );
      final Map<String, dynamic> json = model.toJson();

      expect(json["partnerName"], "Alex");
      expect(json["partnerPronoun"], "theyThem");
      expect(json["partnerToneOfVoice"], "playful");
      expect(json["partnerLoveLanguages"], ["qualityTime"]);
      expect(json["partnerFavoriteFoods"], ["pizza"]);
      expect(json["partnerGiftCategories"], ["experience"]);
      expect(json.containsKey("partnerHobbies"), isFalse);
      expect(json.containsKey("detailedProfileCompleted"), isFalse);
      expect(json.containsKey("relationshipType"), isFalse);
    });

    test("omits unanswered (empty/invalid) initial fields from the json payload", () {
      const UserPartnerProfile profileWithUnanswered = UserPartnerProfile(
        partnerName: "Alex",
        partnerPronoun: Pronoun.invalid,
        customPronoun: "",
        partnerBirthday: null,
        partnerLoveLanguages: [],
        partnerToneOfVoice: ToneOfVoice.invalid,
        partnerFavoriteFoods: [],
        partnerGiftCategories: [GiftCategory.experience],
      );
      final InitialPartnerProfileDataModel model = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
        profileWithUnanswered.toModel(),
      );
      final Map<String, dynamic> json = model.toJson();

      expect(json["partnerName"], "Alex");
      expect(json["partnerGiftCategories"], ["experience"]);
      expect(json.containsKey("partnerPronoun"), isFalse);
      expect(json.containsKey("partnerLoveLanguages"), isFalse);
      expect(json.containsKey("partnerToneOfVoice"), isFalse);
      expect(json.containsKey("partnerFavoriteFoods"), isFalse);
    });

    test("round-trips an initial profile model through json serialization", () {
      final UserPartnerProfile profile = _initialProfile();
      final InitialPartnerProfileDataModel model = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
        profile.toModel(),
      );
      final Map<String, dynamic> json = model.toJson();
      final InitialPartnerProfileDataModel restored = InitialPartnerProfileDataModel.fromJson(json);

      expect(restored.partnerName, model.partnerName);
      expect(restored.partnerPronoun, model.partnerPronoun);
      expect(restored.partnerLoveLanguages, model.partnerLoveLanguages);
      expect(restored.partnerToneOfVoice, model.partnerToneOfVoice);
      expect(restored.partnerFavoriteFoods, model.partnerFavoriteFoods);
      expect(restored.partnerGiftCategories, model.partnerGiftCategories);
    });
  });

  group("Partial-merge: initial profile fields update, extended fields preserved", () {
    test("initial fields from a new local profile overwrite the corresponding remote fields", () {
      final UserPartnerProfile existing = _detailedRemoteProfile();
      final UserPartnerProfile initial = _initialProfile();

      final Map<String, dynamic> merged = _mergeInitialIntoExisting(existing, initial);
      final UserPartnerProfile result = UserPartnerProfile.fromModel(UserPartnerProfileModel.fromJson(merged));

      expect(result.partnerName, "Alex");
      expect(result.partnerPronoun, Pronoun.theyThem);
      expect(result.partnerToneOfVoice, ToneOfVoice.playful);
      expect(result.partnerLoveLanguages, [LoveLanguage.qualityTime]);
      expect(result.partnerFavoriteFoods, [FavoriteFood.pizza]);
    });

    test("extended (remote-only) answers are preserved after the merge", () {
      final UserPartnerProfile existing = _detailedRemoteProfile();
      final UserPartnerProfile initial = _initialProfile();

      final Map<String, dynamic> merged = _mergeInitialIntoExisting(existing, initial);
      final UserPartnerProfile result = UserPartnerProfile.fromModel(UserPartnerProfileModel.fromJson(merged));

      expect(result.partnerHobbies, [Hobby.gaming, Hobby.cooking]);
      expect(result.relationshipType, RelationshipType.lifePartners);
      expect(result.detailedProfileCompleted, isTrue);
    });

    test("unanswered initial fields do not overwrite existing remote answers", () {
      const UserPartnerProfile initialWithMissingPronoun = UserPartnerProfile(
        partnerName: "Alex",
        partnerPronoun: Pronoun.invalid,
        customPronoun: "",
        partnerBirthday: null,
        partnerLoveLanguages: [LoveLanguage.qualityTime],
        partnerToneOfVoice: ToneOfVoice.playful,
        partnerFavoriteFoods: [FavoriteFood.pizza],
        partnerGiftCategories: [GiftCategory.experience],
      );
      final UserPartnerProfile existing = _detailedRemoteProfile();

      final Map<String, dynamic> merged = _mergeInitialIntoExisting(existing, initialWithMissingPronoun);
      final UserPartnerProfile result = UserPartnerProfile.fromModel(UserPartnerProfileModel.fromJson(merged));

      expect(result.partnerPronoun, Pronoun.sheHer);
    });

    test("merge applied to an absent remote profile uses only initial data", () {
      final UserPartnerProfile initial = _initialProfile();
      final Map<String, dynamic> existingData = {};
      final Map<String, dynamic> initialData = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
        initial.toModel(),
      ).toJson();
      final Map<String, dynamic> merged = {...existingData, ...initialData};

      expect(merged["partnerName"], "Alex");
      expect(merged.containsKey("partnerHobbies"), isFalse);
      expect(merged.containsKey("detailedProfileCompleted"), isFalse);
    });
  });

  group("UserPartnerProfileModel serialization", () {
    test("round-trips all fields including extended ones through json", () {
      const UserPartnerProfileModel model = UserPartnerProfileModel(
        partnerName: "Alex",
        partnerPronoun: "theyThem",
        customPronoun: "",
        partnerBirthday: "1990-05-14T00:00:00.000Z",
        partnerLoveLanguages: ["qualityTime"],
        partnerToneOfVoice: "playful",
        partnerFavoriteFoods: ["pizza"],
        partnerGiftCategories: ["experience"],
        partnerHobbies: ["gaming"],
        partnerAnniversary: "2020-07-01T00:00:00.000Z",
        relationshipType: "lifePartners",
        detailedProfileCompleted: true,
      );
      final Map<String, dynamic> json = model.toJson();
      final UserPartnerProfileModel restored = UserPartnerProfileModel.fromJson(json);

      expect(restored.partnerName, model.partnerName);
      expect(restored.partnerPronoun, model.partnerPronoun);
      expect(restored.partnerHobbies, model.partnerHobbies);
      expect(restored.relationshipType, model.relationshipType);
      expect(restored.detailedProfileCompleted, model.detailedProfileCompleted);
      expect(restored.partnerAnniversary, model.partnerAnniversary);
      expect(restored.partnerBirthday, model.partnerBirthday);
    });

    test("defaults missing extended fields when deserializing legacy json without those fields", () {
      final UserPartnerProfileModel model = UserPartnerProfileModel.fromJson(const {
        "partnerName": "Alex",
        "partnerPronoun": "theyThem",
        "customPronoun": "",
        "partnerBirthday": null,
        "partnerLoveLanguages": ["qualityTime"],
        "partnerToneOfVoice": "playful",
        "partnerFavoriteFoods": ["pizza"],
        "partnerGiftCategories": ["experience"],
      });

      expect(model.partnerHobbies, isEmpty);
      expect(model.relationshipType, "");
      expect(model.detailedProfileCompleted, isFalse);
    });
  });
}
