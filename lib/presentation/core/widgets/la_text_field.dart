import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaTextField extends StatelessWidget {
  final String? title;
  final String hint;
  final TextEditingController? controller;
  final bool enabled;
  final Color? hintColor;
  final FocusNode? focusNode;
  final IconData? actionIcon;
  final void Function(String input)? onChanged;

  const LaTextField({
    super.key,
    this.title,
    required this.hint,
    this.controller,
    this.enabled = true,
    this.hintColor,
    this.focusNode,
    this.actionIcon,
    this.onChanged,
  });

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
                enabled: enabled,
                controller: controller,
                onChanged: onChanged,
                focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                placeholder: hint,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: LaTheme.secondaryContainer(),
                  borderRadius: BorderRadius.circular(12),
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                placeholderStyle: LaTheme.font.body16.copyWith(color: hintColor ?? LaTheme.hintText()),
                cursorColor: LaTheme.primary(),
              ),
            ),
            if (actionIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: Center(
                  child: Icon(
                    actionIcon,
                    size: 24,
                    color: hintColor,
                  ),
                ),
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
                enabled: enabled,
                controller: controller,
                onChanged: onChanged, focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: hintColor ?? LaTheme.hintText()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: LaPadding.mediumSmall,
                    horizontal: LaPadding.medium,
                  ),
                ),
                style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
                cursorColor: LaTheme.primary(), // Blue cursor
              ),
            ),
            if (actionIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: LaPadding.mediumSmall),
                child: Center(
                  child: Icon(
                    actionIcon,
                    size: 24,
                    color: hintColor,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (title != null) {
      return LaCard(
        backgroundColor: LaTheme.surface(),
        child: Padding(
          padding: const EdgeInsets.all(LaPadding.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: LaPadding.small,
            children: [
              LaText(title!, style: LaTheme.font.body14.light),
              text,
            ],
          ),
        ),
      );
    }
    return text;
  }
}
