import 'package:flutter/material.dart';

class LaFlexibleAtom extends StatelessWidget {
  final Widget child;
  final int flex;
  final FlexFit fit;

  const LaFlexibleAtom({
    super.key,
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}
