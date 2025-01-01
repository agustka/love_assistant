import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaDropDown<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final T freeFormOption;
  final void Function(dynamic selected, String? customInput) onChanged;

  const LaDropDown({
    required this.title,
    required this.options,
    required this.freeFormOption,
    required this.onChanged,
    super.key,
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
            LaText(widget.title, style: LaTheme.font.body14.light),
            LaTapVisual(
              onTap: () => _showCupertinoPicker(context),
              child: LaCard(
                backgroundColor: LaTheme.secondaryContainer(),
                elevation: 0,
                child: LaTextField(
                  hintText: _selectedOption?.toString() ?? "Select your partner's pronouns",
                  hintColor: _selectedOption == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                  enabled: false,
                ),
              ),
            ),
            if (_selectedOption == widget.freeFormOption)
              LaTextField(
                hintText: "Enter custom value",
                focusNode: _customInputFocusNode,
                onChanged: (String input) => widget.onChanged(_selectedOption, input),
              ),
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
            LaText(widget.title, style: LaTheme.font.body14.light),
            LaCard(
              backgroundColor: LaTheme.secondaryContainer(),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.small),
                child: DropdownButton<T>(
                  value: _selectedOption,
                  hint: LaText(
                    "Select your partner's pronouns",
                    style: LaTheme.font.body16.copyWith(color: Colors.grey[500]),
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
                          child: LaText(option.toString(), style: LaTheme.font.body14),
                        );
                      },
                    ),
                    if (widget.freeFormOption != null)
                      DropdownMenuItem<T>(
                        value: widget.freeFormOption as T,
                        child: LaText(widget.freeFormOption!.toString(), style: LaTheme.font.body14),
                      ),
                  ],
                ),
              ),
            ),
            if (_selectedOption == widget.freeFormOption)
              LaTextField(
                focusNode: _customInputFocusNode,
                hintText: "Enter custom value",
                onChanged: (String input) => widget.onChanged(_selectedOption, input),
              ),
          ],
        ),
      ),
    );
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
                  "Done",
                  style: LaTheme.font.body16.copyWith(color: LaTheme.primary()),
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
}
