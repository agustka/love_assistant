import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaDivider extends StatelessWidget {
  const LaDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: LaTheme.onSurface().withValues(alpha: 50),
    );
  }
}
