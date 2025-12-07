import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LaMultiSelectPickerDefinition<T> extends Equatable {
  final String fieldId;
  final String title;
  final String explanation;
  final bool optional;
  final List<T> options;
  final void Function(List<T> selectedOptions) onSelectionChanged;

  const LaMultiSelectPickerDefinition({
    required this.fieldId,
    required this.title,
    required this.explanation,
    required this.optional,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  List<Object?> get props => [
    fieldId,
    title,
    explanation,
    optional,
    options,
    onSelectionChanged,
  ];
}
