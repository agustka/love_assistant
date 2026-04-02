import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaDayMonthPickerMolecule extends StatefulWidget {
  final String fieldId;
  final String title;
  final String? hint;
  final int? initialMonth;
  final int? initialDay;
  final bool optional;
  final void Function(int month, int day) onDateSelected;

  const LaDayMonthPickerMolecule({
    super.key,
    required this.fieldId,
    required this.title,
    required this.onDateSelected,
    this.hint,
    this.initialMonth,
    this.initialDay,
    this.optional = true,
  });

  @override
  _LaDayMonthPickerMoleculeState createState() => _LaDayMonthPickerMoleculeState();
}

class _LaDayMonthPickerMoleculeState extends State<LaDayMonthPickerMolecule> {
  int? _selectedMonth;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedDay = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) {
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaRow(
              children: [
                LaExpandedAtom(child: LaTextAtom(widget.title, style: LaTextAtomStyle.body14.light)),
                if (!widget.optional)
                  LaTextAtom("*${S.of(context).global_required}", style: LaTextAtomStyle.body12.light.primary),
              ],
            ),
            const LaSizedBoxAtom(height: LaPadding.small),
            LaTapVisualAtom(
              onTap: () {
                if (PlatformDetector.isIOS) {
                  _showCupertinoDayMonthPicker(context);
                } else {
                  _showMaterialDayMonthPicker(context);
                }
              },
              child: LaTextField(
                fieldId: widget.fieldId,
                enabled: false,
                showCard: false,
                actionIcon: LaIcons.calendarDayMonth,
                hintColor: _selectedDay == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                hint: _selectedDay != null ? _getSelectedDateText(context) : widget.hint ?? "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCupertinoDayMonthPicker(BuildContext context) async {
    int tempMonth = _selectedMonth ?? 1;
    int tempDay = _selectedDay ?? 1;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LaContainerAtom(
          height: LaSize.pickerHeight,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
          ),
          child: LaColumnAtom(
            children: [
              // Done button
              LaContainerAtom(
                height: LaSize.pickerHeaderHeight,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = tempMonth;
                      _selectedDay = tempDay;
                    });
                    widget.onDateSelected(_selectedMonth!, _selectedDay!);
                    Navigator.pop(context);
                  },
                  child: LaTextAtom("Done", style: LaTextAtomStyle.body16.primary),
                ),
              ),
              // Day-Month Picker
              LaExpandedAtom(
                child: LaRow(
                  children: [
                    // Month Picker
                    LaExpandedAtom(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempMonth - 1),
                        itemExtent: LaSize.pickerItemExtent,
                        onSelectedItemChanged: (index) {
                          tempMonth = index + 1;
                        },
                        children: List.generate(
                          12,
                          (int index) =>
                              LaCenterAtom(child: LaTextAtom(_getMonthName(index + 1), style: LaTextAtomStyle.body14)),
                        ),
                      ),
                    ),
                    // Day Picker
                    LaExpandedAtom(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempDay - 1),
                        itemExtent: LaSize.pickerItemExtent,
                        onSelectedItemChanged: (int index) {
                          tempDay = index + 1;
                        },
                        children: List.generate(
                          31,
                          (index) => LaCenterAtom(child: LaTextAtom("${index + 1}", style: LaTextAtomStyle.body14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    return DateFormat.MMMM().format(DateTime(0, month));
  }

  Future<void> _showMaterialDayMonthPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LaDialogAtom(
          shape: LaCornerRadius().dialog,
          child: LaPaddingAtom.all(
            value: LaPadding.medium,
            child: LaColumnAtom(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                LaTextAtom(widget.title, style: LaTextAtomStyle.body18.bold),
                const LaSizedBoxAtom(height: LaPadding.medium),

                // Month Dropdown
                DropdownButton<int>(
                  value: _selectedMonth,
                  isExpanded: true,
                  items: List.generate(12, (int index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: LaTextAtom(_getMonthName(index + 1), style: LaTextAtomStyle.body14),
                    );
                  }),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedMonth = value;
                      _selectedDay = null;
                    });
                  },
                ),
                const LaSizedBoxAtom(height: LaPadding.medium),

                // Day Grid
                _buildDayGrid(),

                // Confirm Button
                const LaSizedBoxAtom(height: LaPadding.medium),
                LaButtonAtom(
                  onTap: () {
                    if (_selectedDay != null) {
                      widget.onDateSelected(_selectedMonth ?? 1, _selectedDay!);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: LaTextAtom(S.of(context).global_pick_date, style: LaTextAtomStyle.body14)),
                      );
                    }
                  },
                  text: S.of(context).global_confirm,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayGrid() {
    final int daysInMonth = _getDaysInMonth(_selectedMonth ?? 1);

    return LaGridViewAtom(
      shrinkWrap: true,
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: LaPadding.small,
        mainAxisSpacing: LaPadding.small,
      ),
      itemBuilder: (BuildContext context, int index) {
        final int day = index + 1;
        final bool isSelected = day == _selectedDay;

        return LaTapVisualAtom(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: LaContainerAtom(
            decoration: BoxDecoration(
              color: isSelected ? LaTheme.primary() : LaTheme.secondaryContainer(),
              borderRadius: BorderRadius.circular(LaCornerRadius.small),
            ),
            child: LaCenterAtom(
              child: LaTextAtom(
                _getMonthName(index + 1),
                style: isSelected
                    ? LaTextAtomStyle.body14.bold.onPrimary
                    : LaTextAtomStyle.body14.onSecondaryContainer,
              ),
            ),
          ),
        );
      },
    );
  }

  int _getDaysInMonth(int month) {
    return DateTime(2000, month + 1, 0).day;
  }

  String _getSelectedDateText(BuildContext context) {
    final DateFormat format = DateFormat(S.of(context).date_format_month_and_day);
    return format.format(DateTime(2000, _selectedMonth ?? 1, _selectedDay ?? 1));
  }
}
