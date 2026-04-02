import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaDividerAtom extends StatelessWidget {
  const LaDividerAtom({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: LaTheme.onSurface().withValues(alpha: 50),
    );
  }
}
