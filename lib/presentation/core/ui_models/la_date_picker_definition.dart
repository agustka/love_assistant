import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LaDatePickerDefinition extends Equatable {
  final String fieldId;
  final bool optional;
  final String title;
  final String hint;
  final String explanation;
  final DateTime firstDate;
  final DateTime defaultDate;
  final DateTime lastDate;
  final void Function(DateTime date) onDateSelected;

  const LaDatePickerDefinition({
    required this.fieldId,
    required this.optional,
    required this.title,
    required this.hint,
    required this.explanation,
    required this.firstDate,
    required this.defaultDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  List<Object?> get props => [
    fieldId,
    optional,
    title,
    hint,
    explanation,
    firstDate,
    defaultDate,
    lastDate,
    onDateSelected,
  ];
}
