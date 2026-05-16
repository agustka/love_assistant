import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaFeatureHeadingMolecule extends StatelessWidget {
  final String title;
  final String subtitle;

  const LaFeatureHeadingMolecule({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      mainAxisSize: MainAxisSize.min,
      children: [
        LaTextAtom(
          title,
          style: LaTextAtomStyle.body28.bold,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.small),
        LaTextAtom(
          subtitle,
          style: LaTextAtomStyle.body16.light.hintText,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
