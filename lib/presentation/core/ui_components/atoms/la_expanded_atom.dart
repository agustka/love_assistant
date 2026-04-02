import 'package:flutter/material.dart';

class LaExpandedAtom extends StatelessWidget {
  final Widget child;
  final int flex;

  const LaExpandedAtom({
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
