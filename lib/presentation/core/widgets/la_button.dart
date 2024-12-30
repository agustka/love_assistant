import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/theme/la_theme.dart';

class LaButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const LaButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformDetector.isIOS
        ? CupertinoButton(
            onPressed: onTap,
            color: LaTheme.secondary(),
            child: Text(
              text,
              style: LaTheme.onSecondary().text.copyWith(fontSize: 18),
            ),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: LaTheme.secondary(),
              foregroundColor: LaTheme.onSecondary(),
            ),
            child: Text(
              text,
              style: LaTheme.onSecondary().text.copyWith(fontSize: 16),
            ),
          );
  }
}
