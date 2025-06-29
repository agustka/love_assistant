import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/presentation/core/theme/la_theme.dart';

part 'la_loading_box_details.dart';

class LaLoadingBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final bool isLoading;

  const LaLoadingBox({
    super.key,
    this.width,
    this.height,
    this.child,
    this.baseColor,
    this.highlightColor,
    this.customBorderRadius,
    this.borderRadius = 8,
    this.isLoading = true,
  }) : assert(!(height == null && child == null), "Supply either height or child. Both are null.");

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return _getBody(context);
    }
    return _Shimmer.fromColors(
      highlightColor: highlightColor ?? LaTheme.onSecondaryContainer(),
      baseColor: baseColor ?? LaTheme.secondaryContainer(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
          color: LaTheme.onSecondaryContainer(),
        ),
        child: _getBody(context),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}
