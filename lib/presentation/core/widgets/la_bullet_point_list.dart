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

  TextStyle get bulletSize {
    switch (this) {
      case BulletPointListSize.normal:
        return LaTheme.font.body14;
      case BulletPointListSize.small:
        return LaTheme.font.body12;
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

class LaBulletPointList extends StatelessWidget {
  final String title;
  final List<String> entries;
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
              (String e) => LaListTile(
                leading: LaText("•", style: size.bulletSize),
                title: LaText(e, style: size.bulletSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
