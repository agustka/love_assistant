import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaDatePicker extends StatefulWidget {
  final String title;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime selectedDate) onDateSelected;

  const LaDatePicker({
    required this.title,
    required this.onDateSelected,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    super.key,
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
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: LaPadding.small,
          children: [
            LaText(widget.title, style: LaTheme.font.body14.light),
            GestureDetector(
              onTap: () {
                if (PlatformDetector.isIOS) {
                  _showCupertinoDatePicker(context);
                } else {
                  _showMaterialDatePicker(context);
                }
              },
              child: LaTextField(
                enabled: false,
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
      initialDate: widget.initialDate ?? DateTime(1990),
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
        height: 300,
        decoration: BoxDecoration(
          color: LaTheme.background(),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: LaTheme.background(),
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
                initialDateTime: widget.initialDate ?? DateTime(1990),
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
        _selectedDate = widget.initialDate ?? DateTime(1990);
        widget.onDateSelected(_selectedDate!);
      });
    }
  }
}
