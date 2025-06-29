import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/la_form_field_listener.dart';

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
        elevation: 0,
        child: Row(
          children: [
            Expanded(
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
              Padding(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: Center(child: Icon(widget.actionIcon, size: 24, color: widget.hintColor)),
              ),
          ],
        ),
      );
    } else {
      text = LaCard(
        backgroundColor: LaTheme.secondaryContainer(),
        elevation: 0,
        child: Row(
          children: [
            Expanded(
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
                    vertical: LaPadding.mediumSmall,
                    horizontal: LaPadding.medium,
                  ),
                  counterText: "",
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                cursorColor: LaTheme.primary(),
                maxLength: widget.maxLength,
              ),
            ),
            if (widget.actionIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: Center(child: Icon(widget.actionIcon, size: 24, color: widget.hintColor)),
              ),
          ],
        ),
      );
    }

    Widget finalWidget = text;
    if (!widget.showCard) {
      return finalWidget;
    } else {
      finalWidget = LaCard(
        backgroundColor: LaTheme.surface(),
        child: Padding(
          padding: const EdgeInsets.all(LaPadding.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: LaPadding.small,
            children: [
              Row(
                children: [
                  if (widget.title != null) Expanded(child: LaText(widget.title!, style: LaTheme.font.body14.light)),
                  if (!widget.optional) LaText("*${S.of(context).global_required}", style: LaTheme.font.body12.light.primary),
                ],
              ),
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
