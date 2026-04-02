import 'package:flutter/material.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/dialogs/import.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaMultiSelectPickerOrganism<T> extends StatefulWidget {
  final String fieldId;
  final String title;
  final List<T> options;
  final List<T> initialSelectedOptions;
  final bool optional;
  final bool error;
  final String? errorText;
  final String? explanation;
  final void Function(List<T>) onSelectionChanged;
  final EdgeInsets? padding;

  const LaMultiSelectPickerOrganism({
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
    this.padding,
  });

  @override
  _LaMultiSelectPickerOrganismState<T> createState() => _LaMultiSelectPickerOrganismState<T>();
}

class _LaMultiSelectPickerOrganismState<T> extends State<LaMultiSelectPickerOrganism<T>> {
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

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: LaFormFieldListener(
        fieldId: widget.fieldId,
        child: child,
      ),
    );
  }

  Widget _buildMaterialPillPicker() {
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTitle(context),
            const LaSizedBoxAtom(height: LaPadding.small),
            Wrap(
              spacing: LaPadding.small,
              runSpacing: LaPadding.extraSmall,
              children: widget.options.map((T option) {
                final bool isSelected = _selectedOptions.contains(option);
                return FilterChip(
                  label: LaTextAtom(
                    option.toString(),
                    style: isSelected
                        ? LaTextAtomStyle.body14.onSecondary.light
                        : LaTextAtomStyle.body14.onSecondaryContainer.light,
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
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTitle(context),
            LaPaddingAtom(
              padding: const EdgeInsets.only(top: LaPadding.small),
              child: Wrap(
                spacing: LaPadding.small,
                runSpacing: LaPadding.small,
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
                    child: LaContainerAtom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LaPadding.mediumSmall,
                        vertical: LaPadding.small,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? LaTheme.secondary() : LaTheme.secondaryContainer(),
                        borderRadius: BorderRadius.circular(LaCornerRadius.medium),
                      ),
                      child: LaTextAtom(
                        option.toString(),
                        style: isSelected
                            ? LaTextAtomStyle.body16.onSecondary.light
                            : LaTextAtomStyle.body16.onSecondaryContainer.light,
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
        LaExpandedAtom(
          child: LaTapVisualAtom(
            onTap: () =>
                LaConfirmationDialog.show(context: context, title: widget.title, message: widget.explanation ?? ""),
            enabled: widget.explanation != null,
            child: LaRow(
              children: [
                LaTextAtom(widget.title, style: LaTextAtomStyle.body14.light),
                if (widget.explanation != null) const LaSizedBoxAtom(width: LaPadding.extraSmall),
                if (widget.explanation != null)
                  LaIconAtom(LaIcons.information, size: LaSize.medium, color: LaTheme.hintText()),
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
    );
  }

  Widget _getError(BuildContext context) {
    return LaPaddingAtom(
      padding: const EdgeInsets.only(left: LaPadding.small),
      child: AnimatedCrossFade(
        duration: 300.milliseconds,
        crossFadeState: widget.error ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: const LaSizedBoxAtom.shrink(),
        secondChild: LaTextAtom(
          widget.errorText ?? S.of(context).global_generic_field_error,
          style: LaTextAtomStyle.body14.primary,
        ),
      ),
    );
  }
}
