import "package:equatable/equatable.dart";
import "package:flutter/foundation.dart";
import "package:la/domain/core/value_objects/email_value_object.dart";
import "package:la/domain/core/value_objects/password_value_object.dart";

@immutable
class EmailPasswordCredentials extends Equatable {
  final EmailValueObject email;
  final PasswordValueObject password;

  bool get valid => email.valid && password.valid;
  bool get isInvalid => !valid;

  const EmailPasswordCredentials({
    required this.email,
    required this.password,
  });

  factory EmailPasswordCredentials.fromInput({required String? email, required String? password}) =>
      EmailPasswordCredentials(
        email: EmailValueObject(email),
        password: PasswordValueObject(password),
      );

  factory EmailPasswordCredentials.empty() => EmailPasswordCredentials.fromInput(
    email: null,
    password: null,
  );

  @override
  List<Object?> get props => [email, password];
}
