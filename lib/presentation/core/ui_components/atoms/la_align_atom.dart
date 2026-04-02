import 'package:flutter/material.dart';

class LaAlignAtom extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;

  const LaAlignAtom({
    super.key,
    this.child,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
