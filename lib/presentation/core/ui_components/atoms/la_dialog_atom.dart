import 'package:flutter/material.dart';

class LaDialogAtom extends StatelessWidget {
  final Widget? child;
  final ShapeBorder? shape;
  final EdgeInsets insetPadding;

  const LaDialogAtom({
    super.key,
    this.child,
    this.shape,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shape,
      insetPadding: insetPadding,
      child: child,
    );
  }
}
