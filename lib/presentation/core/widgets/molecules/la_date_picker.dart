import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';
import 'package:la/presentation/core/widgets/organisms/import.dart';

class LaDatePicker extends StatefulWidget {
  final String fieldId;
  final String title;
  final String? hint;
  final DateTime? defaultDate;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool optional;
  final String? explanation;
  final void Function(DateTime selectedDate) onDateSelected;

  const LaDatePicker({
    super.key,
    required this.fieldId,
    required this.title,
    required this.onDateSelected,
    this.hint,
    this.defaultDate,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.optional = true,
    this.explanation,
  });

  @override
  _LaDatePickerState createState() => _LaDatePickerState();
}

class _LaDatePickerState extends State<LaDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return LaCard(
      child: Padding(
        padding: const EdgeInsets.all(LaPaddings.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: LaPaddings.small,
          children: [
            Row(
              children: [
                Expanded(
                  child: LaTapVisual(
                    onTap: () => LaConfirmationDialog.show(
                      context: context,
                      title: widget.title,
                      message: widget.explanation ?? "",
                    ),
                    enabled: widget.explanation != null,
                    child: Row(
                      spacing: LaPaddings.extraSmall,
                      children: [
                        LaText(widget.title, style: LaTheme.font.body14.light),
                        if (widget.explanation != null) Icon(LaIcons.information, size: LaSizes.medium, color: LaTheme.hintText()),
                      ],
                    ),
                  ),
                ),
                if (!widget.optional)
                  LaText(
                    "*${S.of(context).global_required}",
                    style: LaTheme.font.body12.light.primary,
                  ),
              ],
            ),
            LaTapVisual(
              onTap: () {
                if (PlatformDetector.isIOS) {
                  _showCupertinoDatePicker(context);
                } else {
                  _showMaterialDatePicker(context);
                }
              },
              child: LaTextField(
                fieldId: widget.fieldId,
                enabled: false,
                showCard: false,
                actionIcon: LaIcons.calendar,
                hintColor: _selectedDate == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                hint: _selectedDate != null ? DateFormat.yMMMMd().format(_selectedDate!) : widget.hint ?? "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? widget.defaultDate ?? DateTime(DateTime.now().year),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        // Customizing the Material date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              surface: LaTheme.surface(),
              primary: LaTheme.primary(),
              onPrimary: LaTheme.onPrimary(),
              onSurface: LaTheme.onSurface(),
            ),
            //textButtonTheme: TextButtonThemeData(
            //  style: LaTheme.font.body16.primary,
            //),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateSelected(pickedDate);
    }
  }

  Future<void> _showCupertinoDatePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: LaSizes.pickerHeight,
        decoration: BoxDecoration(
          color: LaTheme.surface(),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: LaSizes.pickerHeaderHeight,
              decoration: BoxDecoration(
                color: LaTheme.surface(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: LaText(
                      S.of(context).global_done,
                      style: LaTheme.font.body16.primary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (_selectedDate != null) {
                        widget.onDateSelected(_selectedDate!);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: widget.initialDate ?? widget.defaultDate ?? DateTime(DateTime.now().year),
                minimumDate: widget.firstDate,
                maximumDate: widget.lastDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (_selectedDate == null) {
      setState(() {
        _selectedDate = widget.initialDate ?? widget.defaultDate ?? DateTime(DateTime.now().year);
        widget.onDateSelected(_selectedDate!);
      });
    }
  }
}
