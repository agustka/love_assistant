import 'package:flutter/material.dart';

class LaCenter extends StatelessWidget {
  final Widget child;
  final double? widthFactor;
  final double? heightFactor;

  const LaCenter({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
} 