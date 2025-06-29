import 'package:flutter/material.dart';

class LaSizedBox extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;

  const LaSizedBox({
    super.key,
    this.child,
    this.width,
    this.height,
  });

  const LaSizedBox.shrink({
    super.key,
  }) : child = null, width = null, height = null;

  const LaSizedBox.expand({
    super.key,
    this.child,
  }) : width = double.infinity, height = double.infinity;

  const LaSizedBox.fromSize({
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
