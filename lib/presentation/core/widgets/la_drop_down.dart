import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaDropDown<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final T? freeFormOption;
  final String? hint;
  final String? customHint;
  final bool optional;
  final bool error;
  final String? errorText;
  final String? explanation;
  final void Function(dynamic selected, String? customInput) onChanged;

  const LaDropDown({
    super.key,
    required this.title,
    required this.options,
    this.freeFormOption,
    required this.onChanged,
    this.hint,
    this.customHint,
    this.optional = true,
    this.error = false,
    this.errorText,
    this.explanation,
  });

  @override
  _LaDropDownState createState() => _LaDropDownState<T>();
}

class _LaDropDownState<T> extends State<LaDropDown> {
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
    if (PlatformDetector.isIOS) {
      return _getCupertinoPicker(context);
    } else {
      return _getMaterialPicker(context);
    }
  }

  Widget _getCupertinoPicker(BuildContext context) {
    return LaCard(
      child: Padding(
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: LaPadding.small,
          children: [
            _getTitle(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: LaPadding.extraSmall,
              children: [
                LaTapVisual(
                  onTap: () => _showCupertinoPicker(context),
                  child: LaCard(
                    backgroundColor: LaTheme.secondaryContainer(),
                    elevation: 0,
                    child: LaTextField(
                      optional: false,
                      showCard: false,
                      hint: _selectedOption?.toString() ?? widget.hint ?? "",
                      hintColor: _selectedOption == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                      actionIcon: LaIcons.dropDown,
                      enabled: false,
                    ),
                  ),
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
            _getFreeFormOption(context),
          ],
        ),
      ),
    );
  }

  Widget _getMaterialPicker(BuildContext context) {
    return LaCard(
      child: Padding(
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: LaPadding.small,
          children: [
            _getTitle(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: LaPadding.extraSmall,
              children: [
                LaCard(
                  backgroundColor: LaTheme.secondaryContainer(),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.small),
                    child: DropdownButton<T>(
                      value: _selectedOption,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      elevation:12,
                      hint: LaText(
                        widget.hint ?? "",
                        style: LaTheme.font.body16.hintText,
                      ),
                      underline: const SizedBox.shrink(),
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
                        ...widget.options.map(
                          (dynamic option) {
                            return DropdownMenuItem<T>(
                              value: option as T,
                              child: LaText(option.toString(), style: LaTheme.font.body16),
                            );
                          },
                        ),
                        if (widget.freeFormOption != null)
                          DropdownMenuItem<T>(
                            value: widget.freeFormOption as T,
                            child: LaText(widget.freeFormOption!.toString(), style: LaTheme.font.body16),
                          ),
                      ],
                    ),
                  ),
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
            _getFreeFormOption(context),
          ],
        ),
      ),
    );
  }

  Widget _getFreeFormOption(BuildContext context) {
    if (_selectedOption == widget.freeFormOption && widget.freeFormOption != null) {
      return LaTextField(
        showCard: false,
        focusNode: _customInputFocusNode,
        hint: widget.customHint ?? "",
        onChanged: (String input) => widget.onChanged(_selectedOption, input),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    int initialIndex = widget.options.indexOf(_selectedOption ?? widget.options.first);
    if (_selectedOption == widget.freeFormOption) {
      initialIndex = widget.options.length;
    }
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: initialIndex);

    final dynamic result = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        decoration: BoxDecoration(
          color: LaTheme.surface(),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20), // Rounded top corners
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                child: LaText(
                  S.of(context).global_done,
                  style: LaTheme.font.body16.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
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
                    (dynamic option) => Center(
                      child: LaText(
                        (option as T).toString(),
                        style: LaTheme.font.body16,
                      ),
                    ),
                  ),
                  if (widget.freeFormOption != null)
                    Center(
                      child: LaText(widget.freeFormOption!.toString(), style: LaTheme.font.body16),
                    ),
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
    return Row(
      children: [
        Expanded(
          child: LaTapVisual(
            onTap: () =>
                LaConfirmationDialog.show(context: context, title: widget.title, message: widget.explanation ?? ""),
            enabled: widget.explanation != null,
            child: Row(
              spacing: LaPadding.extraSmall,
              children: [
                LaText(widget.title, style: LaTheme.font.body14.light),
                if (widget.explanation != null) Icon(LaIcons.information, size: 16, color: LaTheme.hintText()),
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
}
