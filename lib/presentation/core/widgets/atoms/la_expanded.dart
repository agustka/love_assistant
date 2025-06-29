import 'package:flutter/material.dart';

class LaExpanded extends StatelessWidget {
  final Widget child;
  final int flex;

  const LaExpanded({
    super.key,
    required this.child,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
} 