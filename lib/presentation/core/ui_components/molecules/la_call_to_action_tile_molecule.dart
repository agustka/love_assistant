import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaCallToActionTileMolecule extends StatelessWidget {
  static const double _dismissTargetSize = 48;

  final String title;
  final String message;
  final String actionText;
  final String dismissSemanticLabel;
  final VoidCallback onActionTap;
  final VoidCallback onDismissTap;
  final bool actionEnabled;
  final bool actionBusy;
  final Key? actionKey;
  final Key? dismissKey;

  const LaCallToActionTileMolecule({
    super.key,
    required this.title,
    required this.message,
    required this.actionText,
    required this.dismissSemanticLabel,
    required this.onActionTap,
    required this.onDismissTap,
    this.actionEnabled = true,
    this.actionBusy = false,
    this.actionKey,
    this.dismissKey,
  });

  @override
  Widget build(BuildContext context) {
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.medium,
        child: LaColumnAtom(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: LaPadding.mediumSmall,
          children: [
            LaRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LaExpandedAtom(
                  child: LaTextAtom(
                    title,
                    style: LaTextAtomStyle.body20.bold.onSurface,
                  ),
                ),
                const LaSizedBoxAtom(width: LaPadding.small),
                LaSemanticsAtom(
                  label: dismissSemanticLabel,
                  button: true,
                  child: LaTapVisualAtom(
                    key: dismissKey,
                    borderRadius: BorderRadius.circular(LaCornerRadius.large),
                    onTap: onDismissTap,
                    excludeFromSemantics: true,
                    child: LaSizedBoxAtom(
                      width: _dismissTargetSize,
                      height: _dismissTargetSize,
                      child: LaCenterAtom(
                        child: LaIconAtom(
                          Icons.close,
                          color: LaTheme.hintText(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LaTextAtom(
              message,
              style: LaTextAtomStyle.body16.light.hintText,
            ),
            LaButtonAtom(
              key: actionKey,
              onTap: onActionTap,
              text: actionText,
              enabled: actionEnabled,
              busy: actionBusy,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
