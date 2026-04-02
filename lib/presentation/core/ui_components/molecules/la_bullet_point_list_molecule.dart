import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

enum BulletPointListSize {
  normal,
  small,
}

extension _BulletPointListSizeExtension on BulletPointListSize {
  LaTextAtomStyle get titleStyle {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTextAtomStyle.body24;
      case BulletPointListSize.small:
        return LaTextAtomStyle.body20;
    }
  }

  LaTextAtomStyle get entryStyle {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTextAtomStyle.body16;
      case BulletPointListSize.small:
        return LaTextAtomStyle.body14;
    }
  }

  LaTextAtomStyle get bulletStyle {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTextAtomStyle.body28;
      case BulletPointListSize.small:
        return LaTextAtomStyle.body24;
    }
  }

  double get titlePadding {
    switch (this) {
      case BulletPointListSize.normal:
        return LaPadding.medium;
      case BulletPointListSize.small:
        return LaPadding.small;
    }
  }
}

class BulletPointEntry {
  final String text;
  final IconData? icon;
  final String? emoji;

  BulletPointEntry({required this.text, this.icon, this.emoji});
}

class LaBulletPointListMolecule extends StatelessWidget {
  final String title;
  final List<BulletPointEntry> entries;
  final BulletPointListSize size;
  final EdgeInsets? padding;

  const LaBulletPointListMolecule({
    super.key,
    required this.title,
    required this.entries,
    this.size = BulletPointListSize.normal,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LaPaddingAtom(
      padding: padding ?? EdgeInsets.zero,
      child: LaCardAtom(
        child: LaPaddingAtom.all(
          value: LaPadding.medium,
          child: LaColumnAtom(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaTextAtom(title, style: size.titleStyle),
              LaSizedBoxAtom(height: size.titlePadding),
              ...entries.map(
                (BulletPointEntry e) => LaListTileMolecule(
                  leading: _getLeading(e),
                  title: LaTextAtom(e.text, style: size.entryStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLeading(BulletPointEntry e) {
    if (e.icon != null) {
      return LaIconAtom(
        e.icon!,
        size: LaSize.large,
      );
    } else if (e.emoji != null) {
      return LaTextAtom(e.emoji ?? "•", style: LaTextAtomStyle.body20);
    }
    return LaTextAtom("•", style: size.bulletStyle);
  }
}
