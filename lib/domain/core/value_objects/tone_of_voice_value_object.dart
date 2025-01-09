import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class ToneOfVoiceValueObject extends ValueObject<ToneOfVoice> {
  ToneOfVoice get get => getOr(ToneOfVoice.invalid);

  factory ToneOfVoiceValueObject(String? input) {
    return ToneOfVoiceValueObject._(_parse(input), _validate(input));
  }

  const ToneOfVoiceValueObject._(ToneOfVoice super.input, Failure<String>? super.failure);

  const factory ToneOfVoiceValueObject.invalid() = _$InvalidToneOfVoiceValueObject;

  static Failure<String>? _validate(String? input) {
    final ToneOfVoice productType = _parse(input);
    if (input == null) {
      return const Failure("Tone of voice must not be null.");
    } else if (productType != ToneOfVoice.invalid) {
      return null;
    }
    return Failure("Unknown tone of voice type $input.", reference: input);
  }

  static ToneOfVoice _parse(String? input) {
    switch (input?.toLowerCase()) {
      case "playful":
        return ToneOfVoice.playful;
      case "romantic":
        return ToneOfVoice.romantic;
      case "casual":
        return ToneOfVoice.casual;
      case "formal":
        return ToneOfVoice.formal;
      case "invalid":
        return ToneOfVoice.invalid;
      default:
        errEnum(type: "ToneOfVoice", input: input);
        return ToneOfVoice.invalid;
    }
  }
}

class _$InvalidToneOfVoiceValueObject extends ToneOfVoiceValueObject {
  const _$InvalidToneOfVoiceValueObject()
      : super._(
    ToneOfVoice.invalid,
    const Failure("Invalid/null instance."),
  );
}

enum ToneOfVoice {
  playful,
  romantic,
  casual,
  formal,
  invalid;

  @override
  String toString() {
    switch (this) {
      case ToneOfVoice.playful:
        return S.current.global_tone_of_voice_playful;
      case ToneOfVoice.romantic:
        return S.current.global_tone_of_voice_romantic;
      case ToneOfVoice.casual:
        return S.current.global_tone_of_voice_casual;
      case ToneOfVoice.formal:
        return S.current.global_tone_of_voice_formal;
      case ToneOfVoice.invalid:
        return "";
    }
  }
}
