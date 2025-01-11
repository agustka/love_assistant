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

  const factory PronounValueObject.invalid() = _$InvalidPronounValueObject;

  static Failure<String>? _validate(String? input) {
    final Pronoun productType = _parse(input);
    if (input == null) {
      return const Failure("Pronoun must not be null.");
    } else if (productType != Pronoun.invalid) {
      return null;
    }
    return Failure("Unknown pronoun type $input.", reference: input);
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
        errEnum(type: "Pronoun", input: input);
        return Pronoun.invalid;
    }
  }
}

class _$InvalidPronounValueObject extends PronounValueObject {
  const _$InvalidPronounValueObject()
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

extension PronounExtension on Pronoun {
  String getNefnifall(String custom) {
    switch (this) {
      case Pronoun.sheHer:
        return S.current.global_pronoun_she_nefnifall;
      case Pronoun.heHim:
        return S.current.global_pronoun_he_nefnifall;
      case Pronoun.theyThem:
        return S.current.global_pronoun_they_nefnifall;
      case Pronoun.custom:
        return custom;
      case Pronoun.invalid:
        return S.current.global_pronoun_invalid_nefnifall;
    }
  }

  String getTholfall(String custom) {
    switch (this) {
      case Pronoun.sheHer:
        return S.current.global_pronoun_she_tholfall;
      case Pronoun.heHim:
        return S.current.global_pronoun_he_tholfall;
      case Pronoun.theyThem:
        return S.current.global_pronoun_they_tholfall;
      case Pronoun.custom:
        return custom;
      case Pronoun.invalid:
        return S.current.global_pronoun_invalid_tholfall;
    }
  }

  String getThagufall(String custom) {
    switch (this) {
      case Pronoun.sheHer:
        return S.current.global_pronoun_she_thagufall;
      case Pronoun.heHim:
        return S.current.global_pronoun_he_thagufall;
      case Pronoun.theyThem:
        return S.current.global_pronoun_they_thagufall;
      case Pronoun.custom:
        return custom;
      case Pronoun.invalid:
        return S.current.global_pronoun_invalid_thagufall;
    }
  }

  String getEignarfall(String custom) {
    switch (this) {
      case Pronoun.sheHer:
        return S.current.global_pronoun_she_eignarfall;
      case Pronoun.heHim:
        return S.current.global_pronoun_he_eignarfall;
      case Pronoun.theyThem:
        return S.current.global_pronoun_they_eignarfall;
      case Pronoun.custom:
        return custom;
      case Pronoun.invalid:
        return S.current.global_pronoun_invalid_eignarfall;
    }
  }
}
