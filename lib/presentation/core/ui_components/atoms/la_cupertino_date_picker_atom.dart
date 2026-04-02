import 'package:flutter/cupertino.dart';

class LaCupertinoDatePickerAtom extends CupertinoDatePicker {
  LaCupertinoDatePickerAtom({
    super.key,
    super.backgroundColor,
    super.minimumDate,
    super.maximumDate,
    super.minimumYear,
    super.maximumYear,
    super.initialDateTime,
    super.use24hFormat,
    super.minuteInterval,
    super.dateOrder,
    super.selectionOverlayBuilder,
    super.showDayOfWeek,
    required super.mode,
    required super.onDateTimeChanged,
  });
}
