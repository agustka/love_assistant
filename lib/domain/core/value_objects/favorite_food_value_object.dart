import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class FavoriteFoodValueObject extends ValueObject<FavoriteFood> {
  FavoriteFood get get => getOr(FavoriteFood.invalid);

  factory FavoriteFoodValueObject(String? input) {
    return FavoriteFoodValueObject._(_parse(input), _validate(input));
  }

  const FavoriteFoodValueObject._(FavoriteFood super.input, Failure<String>? super.failure);

  const factory FavoriteFoodValueObject.invalid() = _$InvalidFavoriteFoodValueObject;

  static Failure<String>? _validate(String? input) {
    final FavoriteFood productType = _parse(input);
    if (input == null) {
      return const Failure("Favorite food must not be null.");
    } else if (productType != FavoriteFood.invalid) {
      return null;
    }
    return Failure("Unknown favorite food type $input.", reference: input);
  }

  static FavoriteFood _parse(String? input) {
    try {
      return FavoriteFood.values.byName(input ?? "");
    } catch (ex) {
      errEnum(type: "FavoriteFood", input: input);
      return FavoriteFood.invalid;
    }
  }
}

class _$InvalidFavoriteFoodValueObject extends FavoriteFoodValueObject {
  const _$InvalidFavoriteFoodValueObject()
    : super._(
        FavoriteFood.invalid,
        const Failure("Invalid/null instance."),
      );
}

enum FavoriteFood {
  chocolate,
  coffee,
  pizza,
  pasta,
  noodleDishes,
  seafood,
  salads,
  spicyFood,
  streetFood,
  homeMade,
  wine,
  desserts,
  invalid
  ;

  @override
  String toString() {
    return switch (this) {
      FavoriteFood.chocolate => S.current.global_food_chocolate,
      FavoriteFood.coffee => S.current.global_food_coffee,
      FavoriteFood.pizza => S.current.global_food_pizza,
      FavoriteFood.pasta => S.current.global_food_pasta,
      FavoriteFood.noodleDishes => S.current.global_food_noodle_dishes,
      FavoriteFood.seafood => S.current.global_food_seafood,
      FavoriteFood.salads => S.current.global_food_salads,
      FavoriteFood.spicyFood => S.current.global_food_spicy_food,
      FavoriteFood.streetFood => S.current.global_food_street_food,
      FavoriteFood.homeMade => S.current.global_food_home_made,
      FavoriteFood.wine => S.current.global_food_wine,
      FavoriteFood.desserts => S.current.global_food_desserts,
      FavoriteFood.invalid => "",
    };
  }
}
