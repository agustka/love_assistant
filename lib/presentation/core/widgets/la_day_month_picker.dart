import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaDayMonthPicker extends StatefulWidget {
  final String title;
  final String? hint;
  final int? initialMonth;
  final int? initialDay;
  final bool optional;
  final bool error;
  final String? errorText;
  final void Function(int month, int day) onDateSelected;

  const LaDayMonthPicker({
    super.key,
    required this.title,
    required this.onDateSelected,
    this.hint,
    this.initialMonth,
    this.initialDay,
    this.optional = true,
    this.error = false,
    this.errorText,
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
      child: Padding(
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: LaPadding.small,
          children: [
            Row(
              children: [
                Expanded(child: LaText(widget.title, style: LaTheme.font.body14.light)),
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
                  _showCupertinoDayMonthPicker(context);
                } else {
                  _showMaterialDayMonthPicker(context);
                }
              },
              child: LaTextField(
                enabled: false,
                showCard: false,
                actionIcon: LaIcons.calendarDayMonth,
                hintColor: _selectedDay == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                hint: _selectedDay != null ? _getSelectedDateText(context) : widget.hint ?? "",
                error: widget.error,
                errorText: widget.errorText,
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
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Done button
              Container(
                height: 50,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = tempMonth;
                      _selectedDay = tempDay;
                    });
                    widget.onDateSelected(_selectedMonth!, _selectedDay!);
                    Navigator.pop(context);
                  },
                  child: const Text("Done", style: TextStyle(color: CupertinoColors.activeBlue)),
                ),
              ),
              // Day-Month Picker
              Expanded(
                child: Row(
                  children: [
                    // Month Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempMonth - 1),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          tempMonth = index + 1;
                        },
                        children: List.generate(
                          12,
                          (index) => Center(child: Text(_getMonthName(index + 1))),
                        ),
                      ),
                    ),
                    // Day Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempDay - 1),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          tempDay = index + 1;
                        },
                        children: List.generate(
                          31,
                          (index) => Center(child: Text("${index + 1}")),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // Month Dropdown
                DropdownButton<int>(
                  value: _selectedMonth,
                  isExpanded: true,
                  items: List.generate(12, (int index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(_getMonthName(index + 1)),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                      _selectedDay = null; // Reset day when month changes
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Day Grid
                _buildDayGrid(),

                // Confirm Button
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null) {
                      widget.onDateSelected(_selectedMonth ?? 1, _selectedDay!);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a day.")),
                      );
                    }
                  },
                  child: const Text("Confirm"),
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
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _selectedDay == day ? Colors.blue : Colors.grey[300], // Highlight selected day
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedDay == day ? Colors.blue : Colors.grey,
              ),
            ),
            child: Text(
              "$day",
              style: TextStyle(
                color: _selectedDay == day ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
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
