import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaDayMonthPicker extends StatefulWidget {
  final String fieldId;
  final String title;
  final String? hint;
  final int? initialMonth;
  final int? initialDay;
  final bool optional;
  final void Function(int month, int day) onDateSelected;

  const LaDayMonthPicker({
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
  _LaDayMonthPickerState createState() => _LaDayMonthPickerState();
}

class _LaDayMonthPickerState extends State<LaDayMonthPicker> {
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
    return LaCard(
      child: LaPadding.all(
        value: LaPaddings.medium,
        child: LaColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaRow(
              children: [
                LaExpanded(child: LaText(widget.title, style: LaTheme.font.body14.light)),
                if (!widget.optional)
                  LaText("*${S.of(context).global_required}", style: LaTheme.font.body12.light.primary),
              ],
            ),
            const LaSizedBox(height: LaPaddings.small),
            LaTapVisual(
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
        return LaContainer(
          height: LaSizes.pickerHeight,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
          ),
          child: LaColumn(
            children: [
              // Done button
              LaContainer(
                height: LaSizes.pickerHeaderHeight,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = tempMonth;
                      _selectedDay = tempDay;
                    });
                    widget.onDateSelected(_selectedMonth!, _selectedDay!);
                    Navigator.pop(context);
                  },
                  child: const LaText("Done", style: TextStyle(color: CupertinoColors.activeBlue)),
                ),
              ),
              // Day-Month Picker
              LaExpanded(
                child: LaRow(
                  children: [
                    // Month Picker
                    LaExpanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempMonth - 1),
                        itemExtent: LaSizes.pickerItemExtent,
                        onSelectedItemChanged: (index) {
                          tempMonth = index + 1;
                        },
                        children: List.generate(
                          12,
                          (int index) => LaCenter(child: LaText(_getMonthName(index + 1), style: LaTheme.font.body14)),
                        ),
                      ),
                    ),
                    // Day Picker
                    LaExpanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempDay - 1),
                        itemExtent: LaSizes.pickerItemExtent,
                        onSelectedItemChanged: (int index) {
                          tempDay = index + 1;
                        },
                        children: List.generate(
                          31,
                          (index) => LaCenter(child: LaText("${index + 1}", style: LaTheme.font.body14)),
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
        return Dialog(
          shape: LaCornerRadius().dialog,
          child: LaPadding.all(
            value: LaPaddings.medium,
            child: LaColumn(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                LaText(widget.title, style: LaTheme.font.body18.bold),
                const LaSizedBox(height: LaPaddings.medium),

                // Month Dropdown
                DropdownButton<int>(
                  value: _selectedMonth,
                  isExpanded: true,
                  items: List.generate(12, (int index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: LaText(_getMonthName(index + 1), style: LaTheme.font.body14),
                    );
                  }),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedMonth = value;
                      _selectedDay = null;
                    });
                  },
                ),
                const LaSizedBox(height: LaPaddings.medium),

                // Day Grid
                _buildDayGrid(),

                // Confirm Button
                const LaSizedBox(height: LaPaddings.medium),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null) {
                      widget.onDateSelected(_selectedMonth ?? 1, _selectedDay!);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: LaText(S.of(context).global_pick_date, style: LaTheme.font.body14)),
                      );
                    }
                  },
                  child: LaText(S.of(context).global_confirm, style: LaTheme.font.body14),
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

    return GridView.builder(
      shrinkWrap: true,
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 days in a week
        crossAxisSpacing: LaPaddings.small,
        mainAxisSpacing: LaPaddings.small,
      ),
      itemBuilder: (BuildContext context, int index) {
        final int day = index + 1;
        final bool isSelected = day == _selectedDay;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: LaContainer(
            decoration: BoxDecoration(
              color: isSelected ? LaTheme.primary() : LaTheme.secondaryContainer(),
              borderRadius: BorderRadius.circular(LaCornerRadius.small),
            ),
            child: LaCenter(
              child: LaText(
                _getMonthName(index + 1),
                style: TextStyle(
                  color: isSelected ? LaTheme.onPrimary() : LaTheme.onSecondaryContainer(),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
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
