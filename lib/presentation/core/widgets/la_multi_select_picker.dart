import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaMultiSelectPicker<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final List<T> initialSelectedOptions;
  final bool optional;
  final bool error;
  final String? errorText;
  final void Function(List<T>) onSelectionChanged;

  const LaMultiSelectPicker({
    super.key,
    required this.title,
    required this.options,
    required this.onSelectionChanged,
    this.optional = true,
    this.error = false,
    this.errorText,
    this.initialSelectedOptions = const [],
  });

  @override
  _LaMultiSelectPickerState<T> createState() => _LaMultiSelectPickerState<T>();
}

class _LaMultiSelectPickerState<T> extends State<LaMultiSelectPicker<T>> {
  late List<T> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.from(widget.initialSelectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS) {
      return _buildCupertinoPillPicker();
    } else {
      return _buildMaterialPillPicker();
    }
  }

  Widget _buildMaterialPillPicker() {
    return LaCard(
      child: Padding(
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: LaPadding.small,
          children: [
            Row(
              children: [
                Expanded(child: LaText(widget.title, style: LaTheme.font.body14)),
                if (!widget.optional)
                  LaText(
                    "*${S.of(context).global_required}",
                    style: LaTheme.font.body12.light.primary,
                  ),
              ],
            ),
            Wrap(
              spacing: LaPadding.small,
              runSpacing: LaPadding.extraSmall,
              children: widget.options.map((T option) {
                final bool isSelected = _selectedOptions.contains(option);
                return FilterChip(
                  label: LaText(
                    option.toString(),
                    style: isSelected
                        ? LaTheme.font.body14.onSecondary.light
                        : LaTheme.font.body14.onSecondaryContainer.light,
                  ),
                  selected: isSelected,
                  checkmarkColor: LaTheme.onSecondary(),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedOptions.add(option);
                      } else {
                        _selectedOptions.remove(option);
                      }
                      widget.onSelectionChanged(_selectedOptions);
                    });
                  },
                  selectedColor: LaTheme.secondary(),
                  backgroundColor: LaTheme.secondaryContainer(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: isSelected ? BorderSide.none : const BorderSide(color: Colors.transparent),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: LaPadding.small),
              child: AnimatedCrossFade(
                duration: 300.milliseconds,
                crossFadeState: widget.error ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: LaText(
                  widget.errorText ?? S.of(context).global_generic_field_error,
                  style: LaTheme.font.body14.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoPillPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.options.map((option) {
            final isSelected = _selectedOptions.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedOptions.remove(option);
                  } else {
                    _selectedOptions.add(option);
                  }
                  widget.onSelectionChanged(_selectedOptions);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LaText(
                  option.toString(),
                  style: TextStyle(
                    color: isSelected ? CupertinoColors.white : CupertinoColors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
