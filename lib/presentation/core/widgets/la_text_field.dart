import 'dart:io'; // For Platform checks
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaTextField extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;

  const LaTextField({
    super.key,
    this.title,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    late Widget text;
    if (PlatformDetector.isIOS) {
      text = CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: LaTheme.secondaryContainer(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: LaTheme.shadow(),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
        placeholderStyle: LaTheme.font.body16.copyWith(color: CupertinoColors.systemGrey4.withOpacity(0.5)),
        cursorColor: LaTheme.primary(),
      );
    } else {
      text = Container(
        decoration: BoxDecoration(
          color: LaTheme.secondaryContainer(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: LaTheme.shadow(),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          style: LaTheme.font.body16.copyWith(color: LaTheme.onSecondaryContainer()),
          cursorColor: LaTheme.primary(), // Blue cursor
        ),
      );
    }

    if (title != null) {
      return LaCard(
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
