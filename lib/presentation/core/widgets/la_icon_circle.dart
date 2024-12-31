import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

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
    final double iconSize = size == null ? 16 : (size! / 2.5);

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
                width: size ?? 40 * scale,
                height: size ?? 40 * scale,
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
        customBorderRadius: const BorderRadius.all(Radius.circular(24)),
        child: widget,
      );
    } else {
      return widget;
    }
  }
}
