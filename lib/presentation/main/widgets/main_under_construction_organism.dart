import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class MainUnderConstructionOrganism extends StatelessWidget {
  static const double _iconSize = 64;

  final String title;
  final String message;

  const MainUnderConstructionOrganism({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LaCenterAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.large,
        child: LaColumnAtom(
          mainAxisSize: MainAxisSize.min,
          spacing: LaPadding.medium,
          children: [
            LaExcludeSemanticsAtom(
              child: LaIconAtom(
                Icons.construction_outlined,
                size: _iconSize,
                color: LaTheme.primary(),
              ),
            ),
            LaTextAtom(
              title,
              style: LaTextAtomStyle.body28.bold.onSurface,
              textAlign: TextAlign.center,
            ),
            LaTextAtom(
              message,
              style: LaTextAtomStyle.body16.light.hintText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
