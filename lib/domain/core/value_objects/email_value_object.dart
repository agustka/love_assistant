import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/value_object.dart";

class EmailValueObject extends ValueObject<String> {
  static final RegExp _pattern = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");

  String get get => getOr("");

  factory EmailValueObject(String? input) => EmailValueObject._(_parse(input), _validate(input));
  const EmailValueObject._(String super.value, Failure<String>? super.failure);
  const factory EmailValueObject.invalid() = _$InvalidEmailValueObject;

  static String _parse(String? input) => (input ?? "").trim();
  static Failure<String>? _validate(String? input) {
    final String value = _parse(input);
    if (value.isEmpty) {
      return const Failure("Email must not be empty.");
    }
    if (!_pattern.hasMatch(value)) {
      return Failure("Enter a valid email address.", reference: value);
    }
    return null;
  }
}

class _$InvalidEmailValueObject extends EmailValueObject {
  const _$InvalidEmailValueObject() : super._("", const Failure("Invalid/null instance."));
}
