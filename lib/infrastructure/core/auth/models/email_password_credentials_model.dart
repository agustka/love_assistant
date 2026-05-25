import "package:flutter/foundation.dart";

@immutable
class EmailPasswordCredentials {
  const EmailPasswordCredentials({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
