import 'package:flutter/material.dart';

class LaMaterialAtom extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;

  const LaMaterialAtom({
    super.key,
    this.child,
    this.color,
    this.borderRadius,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius,
      shape: shape,
      child: child,
    );
  }
}
