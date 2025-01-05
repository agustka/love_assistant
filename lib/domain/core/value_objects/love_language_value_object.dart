import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class LoveLanguageValueObject extends ValueObject<LoveLanguage> {
  LoveLanguage get get => getOr(LoveLanguage.invalid);

  factory LoveLanguageValueObject(String? input) {
    return LoveLanguageValueObject._(_parse(input), _validate(input));
  }

  const LoveLanguageValueObject._(LoveLanguage super.input, Failure<String>? super.failure);

  const factory LoveLanguageValueObject.invalid() = _$InvalidLoveLanguageValueObject;

  static Failure<String>? _validate(String? input) {
    final LoveLanguage productType = _parse(input);
    if (input == null) {
      return const Failure("Love language must not be null.");
    } else if (productType != LoveLanguage.invalid) {
      return null;
    }
    return Failure("Unknown love language type $input.", reference: input);
  }

  static LoveLanguage _parse(String? input) {
    switch (input?.toLowerCase()) {
      case "actsofservice":
        return LoveLanguage.actsOfService;
      case "qualitytime":
        return LoveLanguage.qualityTime;
      case "wordsofaffirmation":
        return LoveLanguage.wordsOfAffirmation;
      case "physicaltouch":
        return LoveLanguage.physicalTouch;
      case "receivinggifts":
        return LoveLanguage.receivingGifts;
      case "invalid":
        return LoveLanguage.invalid;
      default:
        errEnum(type: "LoveLanguage", input: input);
        return LoveLanguage.invalid;
    }
  }
}

class _$InvalidLoveLanguageValueObject extends LoveLanguageValueObject {
  const _$InvalidLoveLanguageValueObject()
      : super._(
    LoveLanguage.invalid,
    const Failure("Invalid/null instance."),
  );
}

enum LoveLanguage {
  actsOfService,
  qualityTime,
  wordsOfAffirmation,
  physicalTouch,
  receivingGifts,
  invalid;

  @override
  String toString() {
    switch (this) {
      case LoveLanguage.actsOfService:
        return S.current.global_love_language_acts_of_service;
      case LoveLanguage.qualityTime:
        return S.current.global_love_language_quality_time;
      case LoveLanguage.wordsOfAffirmation:
        return S.current.global_love_language_words_of_affirmation;
      case LoveLanguage.physicalTouch:
        return S.current.global_love_language_physical_touch;
      case LoveLanguage.receivingGifts:
        return S.current.global_love_language_receiving_gifts;
      case LoveLanguage.invalid:
        return "";
    }
  }
}
