import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LaTextFieldDefinition extends Equatable {
  final String fieldId;
  final void Function(String text) onTextChanged;
  final bool optional;
  final String title;
  final String hint;
  final int maxLength;

  const LaTextFieldDefinition({
    required this.fieldId,
    required this.onTextChanged,
    required this.optional,
    required this.title,
    required this.hint,
    required this.maxLength,
  });

  @override
  List<Object?> get props => [
    fieldId,
    onTextChanged,
    optional,
    title,
    hint,
    maxLength,
  ];
}
