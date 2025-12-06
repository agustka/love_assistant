import 'package:flutter/material.dart';

class LaPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const LaPadding({
    super.key,
    required this.child,
    required this.padding,
  });

  LaPadding.all({
    super.key,
    required this.child,
    required double value,
  }) : padding = EdgeInsets.all(value);

  LaPadding.symmetric({
    super.key,
    required this.child,
    double horizontal = 0.0,
    double vertical = 0.0,
  }) : padding = EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  LaPadding.only({
    super.key,
    required this.child,
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) : padding = EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
