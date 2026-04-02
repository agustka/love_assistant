import 'package:flutter/material.dart';

class LaSizedBoxAtom extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;

  const LaSizedBoxAtom({
    super.key,
    this.child,
    this.width,
    this.height,
  });

  const LaSizedBoxAtom.shrink({
    super.key,
  }) : child = null, width = null, height = null;

  const LaSizedBoxAtom.expand({
    super.key,
    this.child,
  }) : width = double.infinity, height = double.infinity;

  const LaSizedBoxAtom.fromSize({
    super.key,
    this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
