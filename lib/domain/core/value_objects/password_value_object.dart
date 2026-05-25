import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/value_object.dart";

class PasswordValueObject extends ValueObject<String> {
  static const int _minLength = 6;

  String get get => getOr("");

  factory PasswordValueObject(String? input) => PasswordValueObject._(_parse(input), _validate(input));
  const PasswordValueObject._(String super.value, Failure<String>? super.failure);
  const factory PasswordValueObject.invalid() = _$InvalidPasswordValueObject;

  static String _parse(String? input) {
    return input ?? "";
  }

  static Failure<String>? _validate(String? input) {
    final String value = _parse(input);
    if (value.isEmpty) {
      return const Failure("Password must not be empty.");
    }
    if (value.length < _minLength) {
      return const Failure("Password must be at least $_minLength characters.");
    }
    return null;
  }
}

class _$InvalidPasswordValueObject extends PasswordValueObject {
  const _$InvalidPasswordValueObject() : super._("", const Failure("Invalid/null instance."));
}
