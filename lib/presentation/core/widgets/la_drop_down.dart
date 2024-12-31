import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class GenericPicker extends StatefulWidget {
  final String title;
  final List<String> options;
  final String freeFormOptionLabel;
  final void Function(String? selected, String? customInput) onChanged; // Callback to handle selection or custom input

  const GenericPicker({
    required this.title,
    required this.options,
    required this.freeFormOptionLabel,
    required this.onChanged,
    super.key,
  });

  @override
  _GenericPickerState createState() => _GenericPickerState();
}

class _GenericPickerState extends State<GenericPicker> {
  String? _selectedOption;
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
      return _buildCupertinoPicker(context);
    } else {
      return _buildMaterialPicker(context);
    }
  }

  Widget _buildCupertinoPicker(BuildContext context) {
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
                  hintText: _selectedOption ?? "Select your partner's pronouns",
                  hintColor: _selectedOption == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                  enabled: false,
                ),
              ),
            ),
            if (_selectedOption == widget.freeFormOptionLabel)
              LaTextField(
                hintText: "Enter custom value",
                focusNode: _customInputFocusNode,
              ),
          ],
        ),
      ),
    );
  }

  // Material Picker for Android
  Widget _buildMaterialPicker(BuildContext context) {
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
                child: DropdownButton(
                  value: _selectedOption,
                  hint: LaText(
                    "Select your partner's pronouns",
                    style: LaTheme.font.body16.copyWith(color: Colors.grey[500]),
                  ),
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  onChanged: (String? value) {
                    setState(
                      () {
                        _selectedOption = value;
                        if (_selectedOption != widget.freeFormOptionLabel) {
                          _customInput = "";
                        }
                        widget.onChanged(_selectedOption, _customInput);

                        if (_selectedOption == widget.freeFormOptionLabel) {
                          _customInputFocusNode.requestFocus();
                        }
                      },
                    );
                  },
                  items: [
                    ...widget.options.map(
                      (String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      },
                    ),
                    DropdownMenuItem(
                      value: widget.freeFormOptionLabel,
                      child: Text(widget.freeFormOptionLabel),
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedOption == widget.freeFormOptionLabel)
              LaTextField(
                focusNode: _customInputFocusNode,
                hintText: "Enter custom value",
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    int initialIndex = widget.options.indexOf(_selectedOption ?? widget.options.first);
    if (_selectedOption == widget.freeFormOptionLabel) {
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
            // Optional: Add a done button at the top to close the picker
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
                      _selectedOption = widget.options[index];
                      _customInput = "";
                    } else {
                      _selectedOption = widget.freeFormOptionLabel;
                    }
                    widget.onChanged(_selectedOption, _customInput);
                  });
                },
                children: [
                  ...widget.options.map(
                    (String option) => Center(
                      child: LaText(
                        option,
                        style: LaTheme.font.body16,
                      ),
                    ),
                  ),
                  Center(
                    child: LaText(widget.freeFormOptionLabel, style: LaTheme.font.body16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (result != true && _selectedOption == widget.freeFormOptionLabel) {
      _customInputFocusNode.requestFocus();
    } else if (result == true && _selectedOption == widget.freeFormOptionLabel) {
      _customInputFocusNode.requestFocus();
    }
  }
}
