import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_text.dart';

class LaAuthHeaderTextAtom extends StatelessWidget {
  final String title;
  final String subtitle;

  const LaAuthHeaderTextAtom({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LaText(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        LaText(subtitle, style: LaTheme.font.body16, textAlign: TextAlign.center),
      ],
    );
  }
}
