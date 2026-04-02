import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/dialogs/import.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaDatePickerMolecule extends StatefulWidget {
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
  final EdgeInsets? padding;

  const LaDatePickerMolecule({
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
    this.padding,
  });

  @override
  _LaDatePickerMoleculeState createState() => _LaDatePickerMoleculeState();
}

class _LaDatePickerMoleculeState extends State<LaDatePickerMolecule> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return LaPaddingAtom(
      padding: widget.padding ?? EdgeInsets.zero,
      child: LaCardAtom(
        child: LaPaddingAtom.all(
          value: LaPadding.medium,
          child: LaColumnAtom(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaRow(
                children: [
                  LaExpandedAtom(
                    child: LaTapVisualAtom(
                      onTap: () => LaConfirmationDialog.show(
                        context: context,
                        title: widget.title,
                        message: widget.explanation ?? "",
                      ),
                      enabled: widget.explanation != null,
                      child: LaRow(
                        children: [
                          LaTextAtom(widget.title, style: LaTextAtomStyle.body14.light),
                          if (widget.explanation != null) const LaSizedBoxAtom(width: LaPadding.extraSmall),
                          if (widget.explanation != null) LaIconAtom(LaIcons.information, size: LaSize.medium, color: LaTheme.hintText()),
                        ],
                      ),
                    ),
                  ),
                  if (!widget.optional)
                    LaTextAtom(
                      "*${S.of(context).global_required}",
                      style: LaTextAtomStyle.body12.light.primary,
                    ),
                ],
              ),
                  const LaSizedBoxAtom(height: LaPadding.small),
              LaTapVisualAtom(
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
      builder: (BuildContext context) => LaContainerAtom(
        height: LaSize.pickerHeight,
        decoration: BoxDecoration(
          color: LaTheme.surface(),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
        ),
        child: LaColumnAtom(
          children: [
            LaContainerAtom(
              height: LaSize.pickerHeaderHeight,
              decoration: BoxDecoration(
                color: LaTheme.surface(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
              ),
              child: LaRow(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: LaTextAtom(
                      S.of(context).global_done,
                      style: LaTextAtomStyle.body16.primary,
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
            LaExpandedAtom(
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
