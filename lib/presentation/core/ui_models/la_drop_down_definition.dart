import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LaDropDownDefinition<T> extends Equatable {
  final String fieldId;
  final String? freeFormFieldId;
  final bool optional;
  final String title;
  final String hint;
  final String? customHint;
  final String? explanation;
  final List<T> options;
  final T? freeFormOption;
  final void Function(T selected, String? customOption) onItemSelected;

  const LaDropDownDefinition({
    required this.fieldId,
    this.freeFormFieldId,
    required this.optional,
    required this.title,
    required this.hint,
    this.customHint,
    this.explanation,
    required this.options,
    this.freeFormOption,
    required this.onItemSelected,
  });

  @override
  List<Object?> get props => [
    fieldId,
    freeFormFieldId,
    optional,
    title,
    hint,
    customHint,
    explanation,
    options,
    freeFormOption,
    onItemSelected,
  ];
}
