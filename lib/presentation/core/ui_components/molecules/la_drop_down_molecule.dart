import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class _LaDropDownMoleculeState<T> extends State<LaDropDownMolecule> {
  T? _selectedOption;
  String? _customInput = "";
  final FocusNode _customInputFocusNode = FocusNode();

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
        value: LaPaddings.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitle(context),
            const LaSizedBoxAtom(height: LaPaddings.small),
            LaColumnAtom(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LaSizedBoxAtom(height: LaPaddings.extraSmall),
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
        value: LaPaddings.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitle(context),
            const LaSizedBoxAtom(height: LaPaddings.small),
            LaColumnAtom(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LaSizedBoxAtom(height: LaPaddings.extraSmall),
                LaCardAtom(
                  type: CardType.secondary,
                  child: LaPaddingAtom(
                    padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.small),
                    child: DropdownButton<T>(
                      value: _selectedOption,
                      borderRadius: const BorderRadius.all(Radius.circular(LaCornerRadius.medium)),
                      elevation: LaElevation.medium.toInt(),
                      hint: LaTextAtom(widget.hint ?? "", style: LaTheme.font.body16.hintText),
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
                          widget.onChanged(_selectedOption, _customInput);
                          if (_selectedOption == widget.freeFormOption) {
                            _customInputFocusNode.requestFocus();
                          }
                        });
                      },
                      items: [
                        ...widget.options.map((dynamic option) {
                          return DropdownMenuItem<T>(
                            value: option as T,
                            child: LaTextAtom(option.toString(), style: LaTheme.font.body16),
                          );
                        }),
                        if (widget.freeFormOption != null)
                          DropdownMenuItem<T>(
                            value: widget.freeFormOption as T,
                            child: LaTextAtom(widget.freeFormOption!.toString(), style: LaTheme.font.body16),
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
    if (_selectedOption == widget.freeFormOption && widget.freeFormOption != null && widget.freeFormFieldId != null) {
      return LaPaddingAtom(
        padding: const EdgeInsets.only(top: LaPaddings.mediumSmall),
        child: LaTextField(
          fieldId: widget.freeFormFieldId!,
          showCard: false,
          focusNode: _customInputFocusNode,
          hint: widget.customHint ?? "",
          onChanged: (String input) => widget.onChanged(_selectedOption, input),
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
        height: LaSizes.dropdownHeight,
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
              child: CupertinoButton(
                child: LaTextAtom(S.of(context).global_done, style: LaTheme.font.body16.primary),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            LaExpandedAtom(
              child: CupertinoPicker(
                scrollController: scrollController,
                backgroundColor: LaTheme.surface(),
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    if (index < widget.options.length) {
                      _selectedOption = widget.options[index] as T;
                      _customInput = "";
                    } else {
                      _selectedOption = widget.freeFormOption as T;
                    }
                  });
                },
                children: [
                  ...widget.options.map(
                    (dynamic option) => LaCenterAtom(child: LaTextAtom((option as T).toString(), style: LaTheme.font.body16)),
                  ),
                  if (widget.freeFormOption != null)
                    LaCenterAtom(child: LaTextAtom(widget.freeFormOption!.toString(), style: LaTheme.font.body16)),
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
        _selectedOption = widget.options.first as T;
      });
    }

    widget.onChanged(_selectedOption, _customInput);
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
                LaTextAtom(widget.title, style: LaTheme.font.body14.light),
                const LaSizedBoxAtom(width: LaPaddings.extraSmall),
                if (widget.explanation != null) LaIconAtom(LaIcons.information, size: LaSizes.medium, color: LaTheme.hintText()),
              ],
            ),
          ),
        ),
        if (!widget.optional)
          LaTextAtom(
            "*${S.of(context).global_required}",
            style: LaTheme.font.body12.light.primary,
          ),
      ],
    );
  }
}
