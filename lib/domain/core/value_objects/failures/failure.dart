import 'package:flutter/foundation.dart';

@immutable
class Failure<T> {
  final T? reference;
  final String message;

  const Failure(this.message, {this.reference});
}
