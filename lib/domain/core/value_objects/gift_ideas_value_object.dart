import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class GiftCategoryValueObject extends ValueObject<GiftCategory> {
  GiftCategory get get => getOr(GiftCategory.invalid);

  factory GiftCategoryValueObject(String? input) {
    return GiftCategoryValueObject._(_parse(input), _validate(input));
  }

  const GiftCategoryValueObject._(GiftCategory super.input, Failure<String>? super.failure);

  const factory GiftCategoryValueObject.invalid() = _$InvalidGiftCategoryValueObject;

  static Failure<String>? _validate(String? input) {
    final GiftCategory productType = _parse(input);
    if (input == null) {
      return const Failure("Gift category must not be null.");
    } else if (productType != GiftCategory.invalid) {
      return null;
    }
    return Failure("Unknown gift category type $input.", reference: input);
  }

  static GiftCategory _parse(String? input) {
    try {
      return GiftCategory.values.byName(input ?? "");
    } catch (ex) {
      errEnum(type: "GiftCategory", input: input);
      return GiftCategory.invalid;
    }
  }
}

class _$InvalidGiftCategoryValueObject extends GiftCategoryValueObject {
  const _$InvalidGiftCategoryValueObject()
    : super._(
        GiftCategory.invalid,
        const Failure("Invalid/null instance."),
      );
}

enum GiftCategory {
  experience,
  sentimental,
  practicalGifts,
  luxuryItems,
  hobbies,
  foodAndDrinks,
  wellness,
  surpriseMe,
  invalid
  ;

  @override
  String toString() {
    return switch (this) {
      GiftCategory.experience => S.current.global_gift_experience,
      GiftCategory.sentimental => S.current.global_gift_sentimental,
      GiftCategory.practicalGifts => S.current.global_gift_practical_gifts,
      GiftCategory.luxuryItems => S.current.global_gift_luxury_items,
      GiftCategory.hobbies => S.current.global_gift_hobbies,
      GiftCategory.foodAndDrinks => S.current.global_gift_food_and_drinks,
      GiftCategory.wellness => S.current.global_gift_wellness,
      GiftCategory.surpriseMe => S.current.global_gift_surprise_me,
      GiftCategory.invalid => "",
    };
  }
}
