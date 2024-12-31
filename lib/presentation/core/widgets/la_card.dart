import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaCard extends StatelessWidget {
  final Widget child;
  final BorderRadius? customBorderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;

  const LaCard({
    super.key,
    required this.child,
    this.customBorderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = customBorderRadius ?? BorderRadius.circular(10);
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: borderColor ?? Colors.transparent),
      ),
      elevation: elevation ?? 10,
      shadowColor: LaTheme.shadow(),
      color: backgroundColor ?? LaTheme.surface(),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
