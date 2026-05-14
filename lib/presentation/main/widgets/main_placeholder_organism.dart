import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class MainPlaceholderOrganism extends StatelessWidget {
  final String title;

  const MainPlaceholderOrganism({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LaCenterAtom(
      child: LaTextAtom(
        title,
        style: LaTextAtomStyle.body28.bold.onSurface,
        textAlign: TextAlign.center,
      ),
    );
  }
}
