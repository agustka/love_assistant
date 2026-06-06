import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaTextField extends StatefulWidget {
  final String fieldId;
  final Key? editableKey;
  final String? title;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
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
  final Widget? belowField;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final void Function(String value)? onSubmitted;
  final bool obscureTextToggle;
  final Key? obscureTextToggleKey;

  const LaTextField({
    super.key,
    this.title,
    required this.fieldId,
    this.editableKey,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autocorrect = true,
    this.enableSuggestions = true,
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
    this.belowField,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
    this.obscureTextToggle = false,
    this.obscureTextToggleKey,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaTextField();
  }
}

class _LaTextField extends State<LaTextField> {
  late final FocusNode _fallbackFocusNode;
  TextEditingController? _fallbackController;
  late bool _obscured;

  @override
  void initState() {
    super.initState();

    _obscured = widget.obscureText;

    if (widget.focusNode == null) {
      _fallbackFocusNode = FocusNode();
    }

    if (widget.controller == null && (widget.initialValue ?? "").isNotEmpty) {
      _fallbackController = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _fallbackFocusNode.dispose();
    }
    _fallbackController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
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
                key: widget.editableKey,
                enabled: widget.enabled,
                controller: widget.controller ?? _fallbackController,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: widget.textCapitalization,
                autocorrect: widget.autocorrect,
                enableSuggestions: widget.enableSuggestions,
                keyboardType: widget.keyboardType,
                placeholder: widget.hint,
                obscureText: _obscured,
                padding: const EdgeInsets.symmetric(vertical: LaPadding.mediumSmall, horizontal: LaPadding.medium),
                decoration: BoxDecoration(
                  color: LaTheme.secondaryContainer(),
                  borderRadius: BorderRadius.circular(LaCornerRadius.mediumSmall),
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                placeholderStyle: LaTheme.font.body16.copyWith(color: widget.hintColor ?? LaTheme.hintText()),
                cursorColor: LaTheme.primary(),
                maxLength: widget.maxLength,
                autofocus: widget.autofocus,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
              ),
            ),
            if (widget.obscureTextToggle)
              _ObscureTextToggle(
                key: widget.obscureTextToggleKey,
                obscured: _obscured,
                onToggle: _toggleObscured,
                color: widget.hintColor,
              )
            else if (widget.actionIcon != null)
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
                key: widget.editableKey,
                enabled: widget.enabled,
                controller: widget.controller ?? _fallbackController,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? _fallbackFocusNode,
                textCapitalization: widget.textCapitalization,
                autocorrect: widget.autocorrect,
                enableSuggestions: widget.enableSuggestions,
                keyboardType: widget.keyboardType,
                obscureText: _obscured,
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
                autofocus: widget.autofocus,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
              ),
            ),
            if (widget.obscureTextToggle)
              _ObscureTextToggle(
                key: widget.obscureTextToggleKey,
                obscured: _obscured,
                onToggle: _toggleObscured,
                color: widget.hintColor,
              )
            else if (widget.actionIcon != null)
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
              if (widget.belowField != null) widget.belowField!,
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

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}

class _ObscureTextToggle extends StatelessWidget {
  final bool obscured;
  final void Function() onToggle;
  final Color? color;

  const _ObscureTextToggle({
    super.key,
    required this.obscured,
    required this.onToggle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LaPaddingAtom(
      padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
      child: LaTapVisualAtom(
        onTap: onToggle,
        useDebounce: false,
        child: LaPaddingAtom.all(
          value: LaPadding.small,
          child: LaIconAtom(
            obscured ? LaIcons.visibility : LaIcons.visibilityOff,
            size: LaSize.large,
            color: color ?? LaTheme.hintText(),
            semanticLabel: obscured ? S.of(context).global_show_password : S.of(context).global_hide_password,
          ),
        ),
      ),
    );
  }
}
