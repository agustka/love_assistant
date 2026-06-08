import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/relationship_type_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/wizard/models/user_partner_profile_model.dart';

UserPartnerProfile _profile({
  DateTime? birthday,
  bool detailedProfileCompleted = false,
}) {
  return UserPartnerProfile(
    partnerName: "Alex",
    partnerPronoun: Pronoun.theyThem,
    customPronoun: "",
    partnerBirthday: birthday,
    partnerLoveLanguages: const [LoveLanguage.qualityTime, LoveLanguage.physicalTouch],
    partnerToneOfVoice: ToneOfVoice.playful,
    partnerFavoriteFoods: const [FavoriteFood.pizza],
    partnerGiftCategories: const [GiftCategory.experience],
    partnerHobbies: const [Hobby.gaming],
    partnerAnniversary: DateTime.utc(2020, 7, 1),
    relationshipType: RelationshipType.lifePartners,
    detailedProfileCompleted: detailedProfileCompleted,
  );
}

void main() {
  group("UserPartnerProfile.fromModel", () {
    test("round-trips a profile through its model", () {
      final UserPartnerProfile original = _profile(birthday: DateTime.utc(1990, 5, 14));

      final UserPartnerProfile restored = UserPartnerProfile.fromModel(original.toModel());

      expect(restored, original);
    });

    test("preserves a null birthday", () {
      final UserPartnerProfile original = _profile();

      final UserPartnerProfile restored = UserPartnerProfile.fromModel(original.toModel());

      expect(restored.partnerBirthday, isNull);
    });

    test("preserves detailed profile fields through model conversion", () {
      final UserPartnerProfile original = _profile(
        birthday: DateTime.utc(1990, 5, 14),
        detailedProfileCompleted: true,
      );

      final UserPartnerProfile restored = UserPartnerProfile.fromModel(original.toModel());

      expect(restored.partnerHobbies, [Hobby.gaming]);
      expect(restored.partnerAnniversary, DateTime.utc(2020, 7, 1));
      expect(restored.relationshipType, RelationshipType.lifePartners);
      expect(restored.detailedProfileCompleted, isTrue);
    });

    test("treats legacy model json as incomplete detailed profile", () {
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

      final UserPartnerProfile restored = UserPartnerProfile.fromModel(model);

      expect(restored.partnerHobbies, isEmpty);
      expect(restored.partnerAnniversary, isNull);
      expect(restored.relationshipType, RelationshipType.invalid);
      expect(restored.detailedProfileCompleted, isFalse);
    });

    test("falls back to invalid enum members for unrecognized stored names", () {
      const UserPartnerProfileModel model = UserPartnerProfileModel(
        partnerName: "Alex",
        partnerPronoun: "not-a-pronoun",
        customPronoun: "",
        partnerBirthday: null,
        partnerLoveLanguages: ["not-a-language"],
        partnerToneOfVoice: "not-a-tone",
        partnerFavoriteFoods: ["not-a-food"],
        partnerGiftCategories: ["not-a-category"],
      );

      final UserPartnerProfile restored = UserPartnerProfile.fromModel(model);

      expect(restored.partnerPronoun, Pronoun.invalid);
      expect(restored.partnerLoveLanguages, [LoveLanguage.invalid]);
      expect(restored.partnerToneOfVoice, ToneOfVoice.invalid);
      expect(restored.partnerFavoriteFoods, [FavoriteFood.invalid]);
      expect(restored.partnerGiftCategories, [GiftCategory.invalid]);
    });
  });

  group("validity", () {
    test("a constructed profile is valid", () {
      final UserPartnerProfile profile = _profile();

      expect(profile.valid, isTrue);
      expect(profile.isInvalid, isFalse);
    });

    test("the invalid instance reports itself as invalid", () {
      const UserPartnerProfile profile = UserPartnerProfile.invalid();

      expect(profile.valid, isFalse);
      expect(profile.isInvalid, isTrue);
    });

    test("a model round-trip stays valid", () {
      final UserPartnerProfile restored = UserPartnerProfile.fromModel(_profile().toModel());

      expect(restored.valid, isTrue);
    });
  });
}
