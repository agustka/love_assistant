import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/widgets/accessibility.dart';

class LaSvg extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final Color? color;
  final bool accessibilityScaling;

  const LaSvg(
    this.asset, {
    super.key,
    required this.width,
    required this.height,
    this.color,
    this.accessibilityScaling = true,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = max(1, Accessibility.of(context).uiScale);
    double imageWidth = width;
    double imageHeight = height;

    if (accessibilityScaling) {
      imageWidth = imageWidth * scale;
      imageHeight = imageHeight * scale;
    }

    final Widget svg;
    if (asset.startsWith("http")) {
      svg = SvgPicture.network(
        asset,
        width: imageWidth,
        height: imageHeight,
        colorFilter: color?.svg,
      );
    } else {
      svg = SvgPicture.asset(
        asset,
        width: imageWidth,
        height: imageHeight,
        colorFilter: color?.svg,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: imageWidth, maxHeight: imageHeight),
      child: Center(child: svg),
    );
  }
}
