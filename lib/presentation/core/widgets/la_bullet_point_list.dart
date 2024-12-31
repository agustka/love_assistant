import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaBulletPointList extends StatelessWidget {
  final String title;
  final List<String> entries;

  const LaBulletPointList({super.key, required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LaText(title, style: LaTheme.font.body24),
        const SizedBox(height: LaPadding.medium),
        ...entries.map(
          (String e) => ListTile(
            leading: LaText("•", style: LaTheme.font.body14),
            title: LaText(e, style: LaTheme.font.body14),
          ),
        ),
      ],
    );
  }
}
