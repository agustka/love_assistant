import 'package:flutter/cupertino.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/dialogs/import.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaDropDownMolecule<T> extends StatefulWidget {
  final String fieldId;
  final String title;
  final List<T> options;
  final T? freeFormOption;
  final T? initialValue;
  final String? initialCustomValue;
  final String? freeFormFieldId;
  final String? hint;
  final String? customHint;
  final bool optional;
  final String? explanation;
  final void Function(T selected, String? customInput) onChanged;
  final EdgeInsets? padding;

  const LaDropDownMolecule({
    super.key,
    required this.fieldId,
    required this.title,
    required this.options,
    this.freeFormOption,
    this.initialValue,
    this.initialCustomValue,
    this.freeFormFieldId,
    required this.onChanged,
    this.hint,
    this.customHint,
    this.optional = true,
    this.explanation,
    this.padding,
  });

  @override
  _LaDropDownMoleculeState createState() => _LaDropDownMoleculeState<T>();
}

class _LaDropDownMoleculeState<T> extends State<LaDropDownMolecule<T>> {
  T? _selectedOption;
  String? _customInput = "";
  final FocusNode _customInputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _selectedOption = widget.initialValue;
    _customInput = widget.initialCustomValue ?? "";
  }

  @override
  void dispose() {
    _customInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (PlatformDetector.isIOS) {
      child = _getCupertinoPicker(context);
    } else {
      child = _getMaterialPicker(context);
    }

    return LaPaddingAtom(
      padding: widget.padding ?? EdgeInsets.zero,
      child: LaFormFieldListener(fieldId: widget.fieldId, child: child),
    );
  }

  Widget _getCupertinoPicker(BuildContext context) {
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitle(context),
            const LaSizedBoxAtom(height: LaPadding.small),
            LaColumnAtom(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LaSizedBoxAtom(height: LaPadding.extraSmall),
                LaTapVisualAtom(
                  onTap: () => _showCupertinoPicker(context),
                  child: LaCardAtom(
                    type: CardType.secondary,
                    child: LaTextField(
                      fieldId: widget.fieldId,
                      optional: false,
                      showCard: false,
                      hint: _selectedOption?.toString() ?? widget.hint ?? "",
                      hintColor: _selectedOption == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                      actionIcon: LaIcons.dropDown,
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
            _getFreeFormOption(context),
          ],
        ),
      ),
    );
  }

  Widget _getMaterialPicker(BuildContext context) {
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitle(context),
            const LaSizedBoxAtom(height: LaPadding.small),
            LaColumnAtom(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LaSizedBoxAtom(height: LaPadding.extraSmall),
                LaCardAtom(
                  type: CardType.secondary,
                  child: LaPaddingAtom(
                    padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.small),
                    child: LaDropdownButtonAtom<T>(
                      value: _selectedOption,
                      borderRadius: const BorderRadius.all(Radius.circular(LaCornerRadius.medium)),
                      elevation: LaElevation.medium.toInt(),
                      hint: LaTextAtom(widget.hint ?? "", style: LaTextAtomStyle.body16.hintText),
                      underline: const LaSizedBoxAtom.shrink(),
                      isExpanded: true,
                      onChanged: (T? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedOption = value;
                          if (_selectedOption != widget.freeFormOption) {
                            _customInput = "";
                          }
                          widget.onChanged(value, _customInput);
                          if (_selectedOption == widget.freeFormOption) {
                            _customInputFocusNode.requestFocus();
                          }
                        });
                      },
                      items: [
                        ...widget.options.map((dynamic option) {
                          return LaDropdownMenuItemAtom<T>(
                            value: option as T,
                            child: LaTextAtom(option.toString(), style: LaTextAtomStyle.body16),
                          );
                        }),
                        if (widget.freeFormOption != null)
                          LaDropdownMenuItemAtom<T>(
                            value: widget.freeFormOption as T,
                            child: LaTextAtom(widget.freeFormOption!.toString(), style: LaTextAtomStyle.body16),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _getFreeFormOption(context),
          ],
        ),
      ),
    );
  }

  Widget _getFreeFormOption(BuildContext context) {
    final T? selectedOption = _selectedOption;
    if (selectedOption != null &&
        selectedOption == widget.freeFormOption &&
        widget.freeFormOption != null &&
        widget.freeFormFieldId != null) {
      return LaPaddingAtom(
        padding: const EdgeInsets.only(top: LaPadding.mediumSmall),
        child: LaTextField(
          fieldId: widget.freeFormFieldId!,
          showCard: false,
          focusNode: _customInputFocusNode,
          hint: widget.customHint ?? "",
          onChanged: (String input) => widget.onChanged(selectedOption, input),
        ),
      );
    }
    return const LaSizedBoxAtom.shrink();
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    int initialIndex = widget.options.indexOf(_selectedOption ?? widget.options.first);
    if (_selectedOption == widget.freeFormOption) {
      initialIndex = widget.options.length;
    }
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: initialIndex);

    final dynamic result = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => LaContainerAtom(
        height: LaSize.dropdownHeight,
        decoration: BoxDecoration(
          color: LaTheme.surface(),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20), // Rounded top corners
          ),
        ),
        child: LaColumnAtom(
          children: [
            LaAlignAtom(
              alignment: Alignment.topRight,
              child: LaCupertinoButtonAtom(
                child: LaTextAtom(S.of(context).global_done, style: LaTextAtomStyle.body16.primary),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            LaExpandedAtom(
              child: LaCupertinoPickerAtom(
                scrollController: scrollController,
                backgroundColor: LaTheme.surface(),
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    if (index < widget.options.length) {
                      _selectedOption = widget.options[index];
                      _customInput = "";
                    } else {
                      _selectedOption = widget.freeFormOption;
                    }
                  });
                },
                children: [
                  ...widget.options.map(
                    (dynamic option) =>
                        LaCenterAtom(child: LaTextAtom((option as T).toString(), style: LaTextAtomStyle.body16)),
                  ),
                  if (widget.freeFormOption != null)
                    LaCenterAtom(child: LaTextAtom(widget.freeFormOption!.toString(), style: LaTextAtomStyle.body16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (result != true && _selectedOption == widget.freeFormOption) {
      _customInputFocusNode.requestFocus();
    } else if (result == true && _selectedOption == widget.freeFormOption) {
      _customInputFocusNode.requestFocus();
    } else if (_selectedOption == null) {
      setState(() {
        _selectedOption = widget.options.first;
      });
    }

    final T? selectedOption = _selectedOption;
    if (selectedOption != null) {
      widget.onChanged(selectedOption, _customInput);
    }
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
                const LaSizedBoxAtom(width: LaPadding.extraSmall),
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
}
