import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaIconCircle extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? circleColor;
  final bool loading;
  final double? size;
  final double? iconSize;
  final String? semanticsLabel;
  final Function()? onTap;

  const LaIconCircle({
    super.key,
    required this.icon,
    this.iconColor,
    this.circleColor,
    this.loading = false,
    this.size,
    this.iconSize,
    this.semanticsLabel,
    this.onTap,
  });

  const LaIconCircle.loading({super.key})
      : iconColor = null,
        circleColor = null,
        semanticsLabel = null,
        size = null,
        iconSize = null,
        onTap = null,
        icon = Icons.downloading,
        loading = true;

  @override
  Widget build(BuildContext context) {
    final Color defaultCircleColor = LaTheme.surface();

    final double scale = min(2, max(1, Accessibility.of(context).uiScale));

    final Widget widget = Semantics(
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: ClipOval(
          child: LaTapVisual(
            enabled: onTap != null,
            onTap: onTap ?? () {},
            child: ColoredBox(
              color: circleColor ?? defaultCircleColor,
              child: SizedBox(
                width: size ?? LaSizes.huge * scale,
                height: size ?? LaSizes.huge * scale,
                child: Icon(
                  icon,
                  color: iconColor ?? LaTheme.onSurface(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (loading) {
      return LaLoadingBox(
        customBorderRadius: const BorderRadius.all(Radius.circular(LaCornerRadius.large)),
        child: widget,
      );
    } else {
      return widget;
    }
  }
}
