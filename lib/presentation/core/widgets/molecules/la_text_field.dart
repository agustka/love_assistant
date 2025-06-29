import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaTextField extends StatefulWidget {
  final String fieldId;
  final String? title;
  final String hint;
  final bool optional;
  final TextEditingController? controller;
  final bool enabled;
  final bool showCard;
  final Color? hintColor;
  final FocusNode? focusNode;
  final IconData? actionIcon;
  final int? maxLength;
  final void Function(String input)? onChanged;

  const LaTextField({
    super.key,
    this.title,
    required this.fieldId,
    required this.hint,
    this.optional = true,
    this.showCard = true,
    this.controller,
    this.enabled = true,
    this.hintColor,
    this.focusNode,
    this.actionIcon,
    this.onChanged,
    this.maxLength,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaTextField();
  }
}

class _LaTextField extends State<LaTextField> {
  late final FocusNode _fallbackFocusNode;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode == null) {
      _fallbackFocusNode = FocusNode();
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget text;
    if (PlatformDetector.isIOS) {
      text = LaCard(
        backgroundColor: LaTheme.secondaryContainer(),
        elevation: LaElevation.minimal,
        child: LaRow(
          children: [
            LaExpanded(
              child: CupertinoTextField(
                enabled: widget.enabled,
                controller: widget.controller,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: TextCapitalization.sentences,
                placeholder: widget.hint,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(color: LaTheme.secondaryContainer(), borderRadius: BorderRadius.circular(12)),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                placeholderStyle: LaTheme.font.body16.copyWith(color: widget.hintColor ?? LaTheme.hintText()),
                cursorColor: LaTheme.primary(),
                maxLength: widget.maxLength,
              ),
            ),
            if (widget.actionIcon != null)
              LaPadding(
                padding: const EdgeInsets.only(right: LaPaddings.mediumSmall),
                child: LaCenter(
                  child: LaIcon(widget.actionIcon!, size: LaSizes.large, color: widget.hintColor),
                ),
              ),
          ],
        ),
      );
    } else {
      text = LaCard(
        backgroundColor: LaTheme.secondaryContainer(),
        elevation: 0,
        child: LaRow(
          children: [
            LaExpanded(
              child: TextField(
                enabled: widget.enabled,
                controller: widget.controller,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: widget.hintColor ?? LaTheme.hintText()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: LaPaddings.mediumSmall,
                    horizontal: LaPaddings.medium,
                  ),
                  counterText: "",
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                cursorColor: LaTheme.primary(),
                maxLength: widget.maxLength,
              ),
            ),
            if (widget.actionIcon != null)
              LaPadding(
                padding: const EdgeInsets.only(right: LaPaddings.mediumSmall),
                child: LaCenter(
                  child: LaIcon(widget.actionIcon!, size: LaSizes.large, color: widget.hintColor),
                ),
              ),
          ],
        ),
      );
    }

    Widget finalWidget = text;
    if (widget.showCard) {
      finalWidget = LaCard(
        backgroundColor: LaTheme.surface(),
        child: LaPadding.all(
          value: LaPaddings.medium,
          child: LaColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaRow(
                children: [
                  if (widget.title != null) LaExpanded(child: LaText(widget.title!, style: LaTheme.font.body14.light)),
                  if (!widget.optional) LaText("*${S.of(context).global_required}", style: LaTheme.font.body12.light.primary),
                ],
              ),
              const LaSizedBox(height: LaPaddings.small),
              finalWidget,
            ],
          ),
        ),
      );
    }

    return LaFormFieldListener(
      fieldId: widget.fieldId,
      focus: widget.focusNode ?? _fallbackFocusNode,
      child: finalWidget,
    );
  }
}
