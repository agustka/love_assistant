import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class PronounValueObject extends ValueObject<Pronoun> {
  Pronoun get get => getOr(Pronoun.invalid);

  factory PronounValueObject(String? input) {
    return PronounValueObject._(_parse(input), _validate(input));
  }

  const PronounValueObject._(Pronoun super.input, Failure<String>? super.failure);

  const factory PronounValueObject.invalid() = _$InvalidRegularSavingDayOfWeekValueObject;

  static Failure<String>? _validate(String? input) {
    final Pronoun productType = _parse(input);
    if (input == null) {
      return const Failure("Regular saving day of week must not be null.");
    } else if (productType != Pronoun.invalid) {
      return null;
    }
    return Failure("Unknown regular saving day of week type $input.", reference: input);
  }

  static Pronoun _parse(String? input) {
    switch (input?.toLowerCase()) {
      case "she/her":
        return Pronoun.sheHer;
      case "he/him":
        return Pronoun.heHim;
      case "they/them":
        return Pronoun.theyThem;
      case "custom":
        return Pronoun.custom;
      case "invalid":
        return Pronoun.invalid;
      default:
        errEnum(type: "RegularSavingDayOfWeek", input: input);
        return Pronoun.invalid;
    }
  }
}

class _$InvalidRegularSavingDayOfWeekValueObject extends PronounValueObject {
  const _$InvalidRegularSavingDayOfWeekValueObject()
      : super._(
    Pronoun.invalid,
    const Failure("Invalid/null instance."),
  );
}

enum Pronoun {
  sheHer,
  heHim,
  theyThem,
  custom,
  invalid;

  @override
  String toString() {
    switch (this) {
      case Pronoun.sheHer:
        return S.current.global_pronoun_she_her;
      case Pronoun.heHim:
        return S.current.global_pronoun_he_him;
      case Pronoun.theyThem:
        return S.current.global_pronoun_they_them;
      case Pronoun.custom:
        return S.current.global_pronoun_custom;
      case Pronoun.invalid:
        return "";
    }
  }
}
