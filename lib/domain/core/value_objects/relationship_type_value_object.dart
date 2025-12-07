import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/presentation/core/localization/l10n.dart';

class RelationshipTypeValueObject extends ValueObject<RelationshipType> {
  RelationshipType get get => getOr(RelationshipType.invalid);

  factory RelationshipTypeValueObject(String? input) {
    return RelationshipTypeValueObject._(_parse(input), _validate(input));
  }

  const RelationshipTypeValueObject._(RelationshipType super.input, Failure<String>? super.failure);

  const factory RelationshipTypeValueObject.invalid() = _$InvalidRelationshipTypeValueObject;

  static Failure<String>? _validate(String? input) {
    final RelationshipType productType = _parse(input);
    if (input == null) {
      return const Failure("Relationship type must not be null.");
    } else if (productType != RelationshipType.invalid) {
      return null;
    }
    return Failure("Unknown relationship type $input.", reference: input);
  }

  static RelationshipType _parse(String? input) {
    try {
      return RelationshipType.values.byName(input ?? "");
    } catch (ex) {
      errEnum(type: "RelationshipType", input: input);
      return RelationshipType.invalid;
    }
  }
}

class _$InvalidRelationshipTypeValueObject extends RelationshipTypeValueObject {
  const _$InvalidRelationshipTypeValueObject()
    : super._(
        RelationshipType.invalid,
        const Failure("Invalid/null instance."),
      );
}

enum RelationshipType {
  dating,
  engaged,
  married,
  lifePartners,
  other,
  invalid
  ;

  @override
  String toString() {
    return switch (this) {
      RelationshipType.dating => S.current.global_relationship_type_dating,
      RelationshipType.engaged => S.current.global_relationship_type_engaged,
      RelationshipType.married => S.current.global_relationship_type_married,
      RelationshipType.lifePartners => S.current.global_relationship_type_life_partners,
      RelationshipType.other => S.current.global_relationship_type_other,
      RelationshipType.invalid => "",
    };
  }
}
