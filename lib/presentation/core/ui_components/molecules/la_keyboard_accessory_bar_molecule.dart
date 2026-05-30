import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

/// Trailing action toolbar that sits above the on-screen keyboard.
///
/// Hosts a single right-aligned action (for example "Next" or "Done") that the
/// caller labels and handles, keeping this molecule free of feature knowledge.
class LaKeyboardAccessoryBarMolecule extends StatelessWidget {
  final String actionLabel;
  final void Function() onActionPressed;

  const LaKeyboardAccessoryBarMolecule({
    super.key,
    required this.actionLabel,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LaMaterialAtom(
      color: LaTheme.background(),
      child: LaRow(
        children: [
          const LaExpandedAtom(child: LaSizedBoxAtom.shrink()),
          LaCupertinoButtonAtom(
            padding: const EdgeInsets.symmetric(
              horizontal: LaPadding.medium,
              vertical: LaPadding.small,
            ),
            onPressed: onActionPressed,
            child: LaTextAtom(
              actionLabel,
              style: LaTextAtomStyle.body16.primary,
            ),
          ),
        ],
      ),
    );
  }
}
