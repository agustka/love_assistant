import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

enum BulletPointListSize {
  normal,
  small,
}

extension _BulletPointListSizeExtension on BulletPointListSize {
  TextStyle get titleSize {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTheme.font.body24;
      case BulletPointListSize.small:
        return LaTheme.font.body20;
    }
  }

  TextStyle get entrySize {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTheme.font.body16;
      case BulletPointListSize.small:
        return LaTheme.font.body14;
    }
  }

  TextStyle get bulletSize {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTheme.font.body28;
      case BulletPointListSize.small:
        return LaTheme.font.body24;
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

class LaBulletPointList extends StatelessWidget {
  final String title;
  final List<BulletPointEntry> entries;
  final BulletPointListSize size;

  const LaBulletPointList({
    super.key,
    required this.title,
    required this.entries,
    this.size = BulletPointListSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return LaCard(
      child: Padding(
        padding: const EdgeInsets.all(LaPadding.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaText(title, style: size.titleSize),
            SizedBox(height: size.titlePadding),
            ...entries.map(
              (BulletPointEntry e) => LaListTile(
                leading: _getLeading(e),
                title: LaText(e.text, style: size.entrySize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLeading(BulletPointEntry e) {
    if (e.icon != null) {
      return Icon(
        e.icon,
        size: 24,
      );
    } else if (e.emoji != null) {
      return LaText(e.emoji ?? "•", style: LaTheme.font.body20);
    }
    return LaText("•", style: size.bulletSize);
  }
}
