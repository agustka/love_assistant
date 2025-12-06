import 'package:flutter/material.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';

class LaMultiSelectPicker<T> extends StatefulWidget {
  final String fieldId;
  final String title;
  final List<T> options;
  final List<T> initialSelectedOptions;
  final bool optional;
  final bool error;
  final String? errorText;
  final String? explanation;
  final void Function(List<T>) onSelectionChanged;

  const LaMultiSelectPicker({
    super.key,
    required this.fieldId,
    required this.title,
    required this.options,
    required this.onSelectionChanged,
    this.optional = true,
    this.error = false,
    this.errorText,
    this.explanation,
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
    final Widget child;
    if (PlatformDetector.isIOS) {
      child = _buildCupertinoPillPicker();
    } else {
      child = _buildMaterialPillPicker();
    }

    return LaFormFieldListener(
      fieldId: widget.fieldId,
      child: child,
    );
  }

  Widget _buildMaterialPillPicker() {
    return LaCard(
      child: LaPadding.all(
        value: LaPaddings.medium,
        child: LaColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTitle(context),
            const LaSizedBox(height: LaPaddings.small),
            Wrap(
              spacing: LaPaddings.small,
              runSpacing: LaPaddings.extraSmall,
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
                    borderRadius: BorderRadius.circular(LaCornerRadius.medium),
                  ),
                  side: isSelected ? BorderSide.none : const BorderSide(color: Colors.transparent),
                );
              }).toList(),
            ),
            _getError(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoPillPicker() {
    return LaCard(
      child: LaPadding.all(
        value: LaPaddings.medium,
        child: LaColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTitle(context),
            LaPadding(
              padding: const EdgeInsets.only(top: LaPaddings.small),
              child: Wrap(
                spacing: LaPaddings.small,
                runSpacing: LaPaddings.small,
                children: widget.options.map((T option) {
                  final bool isSelected = _selectedOptions.contains(option);
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
                    child: LaContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LaPaddings.mediumSmall,
                        vertical: LaPaddings.small,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? LaTheme.secondary() : LaTheme.secondaryContainer(),
                        borderRadius: BorderRadius.circular(LaCornerRadius.medium),
                      ),
                      child: LaText(
                        option.toString(),
                        style: isSelected
                            ? LaTheme.font.body16.onSecondary.light
                            : LaTheme.font.body16.onSecondaryContainer.light,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            _getError(context),
          ],
        ),
      ),
    );
  }

  Widget _getTitle(BuildContext context) {
    return LaRow(
      children: [
        LaExpanded(
          child: LaTapVisual(
            onTap: () =>
                LaConfirmationDialog.show(context: context, title: widget.title, message: widget.explanation ?? ""),
            enabled: widget.explanation != null,
            child: LaRow(
              children: [
                LaText(widget.title, style: LaTheme.font.body14.light),
                if (widget.explanation != null) const LaSizedBox(width: LaPaddings.extraSmall),
                if (widget.explanation != null) LaIcon(LaIcons.information, size: LaSizes.medium, color: LaTheme.hintText()),
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
    );
  }

  Widget _getError(BuildContext context) {
    return LaPadding(
      padding: const EdgeInsets.only(left: LaPaddings.small),
      child: AnimatedCrossFade(
        duration: 300.milliseconds,
        crossFadeState: widget.error ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: const LaSizedBox.shrink(),
        secondChild: LaText(
          widget.errorText ?? S.of(context).global_generic_field_error,
          style: LaTheme.font.body14.primary,
        ),
      ),
    );
  }
}
