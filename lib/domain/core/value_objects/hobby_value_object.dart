import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class HobbyValueObject extends ValueObject<Hobby> {
  Hobby get get => getOr(Hobby.invalid);

  factory HobbyValueObject(String? input) {
    return HobbyValueObject._(_parse(input), _validate(input));
  }

  const HobbyValueObject._(Hobby super.input, Failure<String>? super.failure);

  const factory HobbyValueObject.invalid() = _$InvalidLoveLanguageValueObject;

  static Failure<String>? _validate(String? input) {
    final Hobby productType = _parse(input);
    if (input == null) {
      return const Failure("Hobby must not be null.");
    } else if (productType != Hobby.invalid) {
      return null;
    }
    return Failure("Unknown hobby type $input.", reference: input);
  }

  static Hobby _parse(String? input) {
    switch (input?.toLowerCase()) {
      case "reading":
        return Hobby.reading;
      case "cooking":
        return Hobby.cooking;
      case "traveling":
        return Hobby.traveling;
      case "gaming":
        return Hobby.gaming;
      case "fitness":
        return Hobby.fitness;
      case "music":
        return Hobby.music;
      case "crafting":
        return Hobby.crafting;
      case "gardening":
        return Hobby.gardening;
      case "moviesandtv":
        return Hobby.moviesAndTv;
      case "fishingandhunting":
        return Hobby.fishingAndHunting;
      case "sports":
        return Hobby.sports;
      case "invalid":
        return Hobby.invalid;
      default:
        errEnum(type: "LoveLanguage", input: input);
        return Hobby.invalid;
    }
  }
}

class _$InvalidLoveLanguageValueObject extends HobbyValueObject {
  const _$InvalidLoveLanguageValueObject()
      : super._(
          Hobby.invalid,
          const Failure("Invalid/null instance."),
        );
}

enum Hobby {
  reading,
  cooking,
  traveling,
  gaming,
  fitness,
  music,
  crafting,
  gardening,
  moviesAndTv,
  fishingAndHunting,
  sports,
  invalid;

  @override
  String toString() {
    switch (this) {
      case Hobby.reading:
        return S.current.global_hobby_reading;
      case Hobby.cooking:
        return S.current.global_hobby_cooking;
      case Hobby.traveling:
        return S.current.global_hobby_traveling;
      case Hobby.gaming:
        return S.current.global_hobby_gaming;
      case Hobby.fitness:
        return S.current.global_hobby_fitness;
      case Hobby.music:
        return S.current.global_hobby_music;
      case Hobby.crafting:
        return S.current.global_hobby_crafting;
      case Hobby.gardening:
        return S.current.global_hobby_gardening;
      case Hobby.moviesAndTv:
        return S.current.global_hobby_movies_and_tv;
      case Hobby.fishingAndHunting:
        return S.current.global_hobby_fishing_and_hunting;
      case Hobby.sports:
        return S.current.global_hobby_sports;
      case Hobby.invalid:
        return "";
    }
  }
}
