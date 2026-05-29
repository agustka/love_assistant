import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaTextField extends StatefulWidget {
  final String fieldId;
  final String? title;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool optional;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final bool showCard;
  final Color? hintColor;
  final FocusNode? focusNode;
  final IconData? actionIcon;
  final int? maxLength;
  final void Function(String input)? onChanged;
  final EdgeInsets? padding;

  const LaTextField({
    super.key,
    this.title,
    required this.fieldId,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.optional = true,
    this.showCard = true,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.hintColor,
    this.focusNode,
    this.actionIcon,
    this.onChanged,
    this.maxLength,
    this.padding,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaTextField();
  }
}

class _LaTextField extends State<LaTextField> {
  late final FocusNode _fallbackFocusNode;
  TextEditingController? _fallbackController;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode == null) {
      _fallbackFocusNode = FocusNode();
    }

    if (widget.controller == null && (widget.initialValue ?? "").isNotEmpty) {
      _fallbackController = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget text;
    if (PlatformDetector.isIOS) {
      text = LaCardAtom(
        type: CardType.secondary,
        child: LaRow(
          children: [
            LaExpandedAtom(
              child: LaCupertinoTextFieldAtom(
                enabled: widget.enabled,
                controller: widget.controller ?? _fallbackController,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: widget.keyboardType,
                placeholder: widget.hint,
                obscureText: widget.obscureText,
                padding: const EdgeInsets.symmetric(vertical: LaPadding.mediumSmall, horizontal: LaPadding.medium),
                decoration: BoxDecoration(
                  color: LaTheme.secondaryContainer(),
                  borderRadius: BorderRadius.circular(LaCornerRadius.mediumSmall),
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                placeholderStyle: LaTheme.font.body16.copyWith(color: widget.hintColor ?? LaTheme.hintText()),
                cursorColor: LaTheme.primary(),
                maxLength: widget.maxLength,
              ),
            ),
            if (widget.actionIcon != null)
              LaPaddingAtom(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: LaCenterAtom(
                  child: LaIconAtom(widget.actionIcon!, size: LaSize.large, color: widget.hintColor),
                ),
              ),
          ],
        ),
      );
    } else {
      text = LaCardAtom(
        type: CardType.secondary,
        child: LaRow(
          children: [
            LaExpandedAtom(
              child: LaMaterialTextFieldAtom(
                enabled: widget.enabled,
                controller: widget.controller ?? _fallbackController,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
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
              LaPaddingAtom(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: LaCenterAtom(
                  child: LaIconAtom(widget.actionIcon!, size: LaSize.large, color: widget.hintColor),
                ),
              ),
          ],
        ),
      );
    }

    Widget finalWidget = text;
    if (widget.showCard) {
      finalWidget = LaCardAtom(
        child: LaPaddingAtom.all(
          value: LaPadding.medium,
          child: LaColumnAtom(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaRow(
                children: [
                  if (widget.title != null)
                    LaExpandedAtom(child: LaTextAtom(widget.title!, style: LaTextAtomStyle.body14.light)),
                  if (!widget.optional)
                    LaTextAtom("*${S.of(context).global_required}", style: LaTextAtomStyle.body12.light.primary),
                ],
              ),
              const LaSizedBoxAtom(height: LaPadding.small),
              finalWidget,
            ],
          ),
        ),
      );
    }

    return LaPaddingAtom(
      padding: widget.padding ?? EdgeInsets.zero,
      child: LaFormFieldListener(
        fieldId: widget.fieldId,
        focus: widget.focusNode ?? _fallbackFocusNode,
        child: finalWidget,
      ),
    );
  }
}
