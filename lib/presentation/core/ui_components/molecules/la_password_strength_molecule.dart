import 'package:flutter/material.dart';
import 'package:la/domain/core/auth/value_objects/password_strength_evaluator.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaPasswordStrengthMolecule extends StatelessWidget {
  static const Key meterKey = Key("LaPasswordStrengthMolecule_meter");

  static const int _segmentCount = 3;

  final PasswordStrength strength;

  const LaPasswordStrengthMolecule({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _color();
    final int filledSegments = _filledSegments();

    return LaColumnAtom(
      key: meterKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: LaPadding.small,
      children: [
        LaRow(
          spacing: LaPadding.extraSmall,
          children: [
            for (int index = 0; index < _segmentCount; index++)
              LaExpandedAtom(
                child: _PasswordStrengthSegment(
                  filled: index < filledSegments,
                  color: color,
                ),
              ),
          ],
        ),
        LaTextAtom(
          _label(context),
          style: LaTextAtomStyle.body12.light,
        ),
      ],
    );
  }

  Color _color() {
    switch (strength) {
      case PasswordStrength.tooShort:
        return LaTheme.hintText();
      case PasswordStrength.weak:
        return LaTheme.error();
      case PasswordStrength.fair:
        return LaTheme.onSecondaryContainer();
      case PasswordStrength.strong:
        return LaTheme.primary();
    }
  }

  int _filledSegments() {
    switch (strength) {
      case PasswordStrength.tooShort:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.strong:
        return 3;
    }
  }

  String _label(BuildContext context) {
    final S strings = S.of(context);
    switch (strength) {
      case PasswordStrength.tooShort:
        return strings.auth_password_strength_too_short;
      case PasswordStrength.weak:
        return strings.auth_password_strength_weak;
      case PasswordStrength.fair:
        return strings.auth_password_strength_fair;
      case PasswordStrength.strong:
        return strings.auth_password_strength_strong;
    }
  }
}

class _PasswordStrengthSegment extends StatelessWidget {
  static const double _height = 6;

  final bool filled;
  final Color color;

  const _PasswordStrengthSegment({
    required this.filled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LaContainerAtom(
      height: _height,
      decoration: BoxDecoration(
        color: filled ? color : LaTheme.secondaryContainer(),
        borderRadius: BorderRadius.circular(LaCornerRadius.extraSmall),
      ),
    );
  }
}
