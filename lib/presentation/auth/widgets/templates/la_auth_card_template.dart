import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/la_card.dart';
import 'package:la/presentation/core/ui_components/atoms/la_center.dart';

class LaAuthCardTemplate extends StatelessWidget {
  final Widget child;

  const LaAuthCardTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaCenter(
        child: LaCard(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
