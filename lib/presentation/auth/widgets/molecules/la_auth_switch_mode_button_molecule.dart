import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';

class LaAuthSwitchModeButtonMolecule extends StatelessWidget {
  final String prompt;
  final String actionText;
  final VoidCallback onTap;

  const LaAuthSwitchModeButtonMolecule({
    super.key,
    required this.prompt,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "$prompt ",
          style: LaTheme.font.body16,
          children: <InlineSpan>[
            TextSpan(
              text: actionText,
              style: LaTheme.font.body16.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
