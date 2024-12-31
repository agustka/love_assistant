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
  String? selectedOption;
  String? customInput = "";
  final FocusNode customInputFocusNode = FocusNode();

  @override
  void dispose() {
    customInputFocusNode.dispose(); // Dispose FocusNode to avoid memory leaks
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
                  hintText: selectedOption ?? "Select your partner's pronouns",
                  hintColor: selectedOption == null ? LaTheme.hintText() : LaTheme.onSecondaryContainer(),
                  enabled: false,
                ),
              ),
            ),
            if (selectedOption == widget.freeFormOptionLabel)
              LaTextField(
                hintText: "Enter custom value",
                focusNode: customInputFocusNode,
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
                  value: selectedOption,
                  hint: LaText(
                    "Select your partner's pronouns",
                    style: LaTheme.font.body16.copyWith(color: Colors.grey[500]),
                  ),
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      if (selectedOption != widget.freeFormOptionLabel) {
                        customInput = '';
                      }
                      widget.onChanged(selectedOption, customInput);
                    });
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
            if (selectedOption == widget.freeFormOptionLabel)
              LaTextField(
                focusNode: customInputFocusNode,
                hintText: "Enter custom value",
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    int initialIndex = widget.options.indexOf(selectedOption ?? widget.options.first);
    if (selectedOption == widget.freeFormOptionLabel) {
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
                      selectedOption = widget.options[index];
                      customInput = "";
                    } else {
                      selectedOption = widget.freeFormOptionLabel;
                    }
                    widget.onChanged(selectedOption, customInput);
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

    if (result != true && selectedOption == widget.freeFormOptionLabel) {
      customInputFocusNode.requestFocus();
    } else if (result == true && selectedOption == widget.freeFormOptionLabel) {
      customInputFocusNode.requestFocus();
    }
  }
}
