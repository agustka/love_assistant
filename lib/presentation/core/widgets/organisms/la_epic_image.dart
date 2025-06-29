import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:lottie/lottie.dart';

enum LaEpicImageType {
  standard,
  avatar,
  animation,
}

class LaEpicImage extends StatelessWidget {
  final String asset;
  final String? fallbackAsset;
  final String? title;
  final String? message;
  final double widthAsPercentageOfScreen;
  final double? heightAsPercentageOfScreen;
  final String semantics;
  final bool padding;
  final Widget? overrideWidget;
  final LaEpicImageType type;
  final bool isLoading;
  final bool hideInAccessibilityMode;

  const LaEpicImage({
    super.key,
    required this.asset,
    this.title,
    this.message,
    this.widthAsPercentageOfScreen = 0.6,
    this.heightAsPercentageOfScreen,
    this.fallbackAsset,
    this.semantics = "",
    this.padding = true,
    this.overrideWidget,
    this.type = LaEpicImageType.standard,
    this.isLoading = false,
    this.hideInAccessibilityMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool shouldAddTopPadding = switch (type) {
      LaEpicImageType.standard => padding,
      LaEpicImageType.avatar => false,
      LaEpicImageType.animation => false,
    };
    final Widget image = overrideWidget ?? (isLoading ? LaLoadingBox(child: _getImage(context)) : _getImage(context));

    Widget core = LaPadding(
      padding: EdgeInsets.only(top: shouldAddTopPadding ? LaPaddings.huge : 0),
      child: image,
    );
    if (semantics.isNotEmpty) {
      core = Semantics(
        label: semantics,
        child: ExcludeSemantics(
          child: core,
        ),
      );
    }

    if (type == LaEpicImageType.avatar) {
      const double backgroundPadding = LaPaddings.large;
      final double size = _getSize(context);
      final double backgroundSize = size + backgroundPadding;
      core = Stack(
        alignment: Alignment.center,
        children: [
          LaSvg(
            LaTheme.illustrations.roundPictureBackground,
            width: backgroundSize,
            height: backgroundSize,
            color: LaTheme.secondary(),
          ),
          Align(
            child: LaContainer(
              margin: const EdgeInsets.only(left: backgroundPadding),
              height: size,
              width: size,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: core,
              ),
            ),
          ),
        ],
      );
    }

    if (Accessibility.of(context).isInAccessibilityMode && hideInAccessibilityMode) {
      core = const LaSizedBox.shrink();
    }

    if (title != null && message != null) {
      return LaColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          core,
          const LaSizedBox(height: LaPaddings.extraHuge),
          LaText(
            title!,
            style: LaTheme.font.body28.bold,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const LaSizedBox(height: LaPaddings.medium),
            LaText(
              message!,
              style: LaTheme.font.body16.light,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    } else if (message != null) {
      return LaColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          core,
          const LaSizedBox(height: LaPaddings.extraHuge),
          LaText(
            message!,
            style: LaTheme.font.body16.light,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (title != null) {
      return LaColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          core,
          const LaSizedBox(height: LaPaddings.extraHuge),
          LaText(
            title!,
            style: LaTheme.font.body28.bold,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return core;
  }

  Widget _getImage(BuildContext context) {
    if (type == LaEpicImageType.animation) {
      return Lottie.asset(
        AppAssets.animations.progress,
        width: _getSize(context),
        frameRate: FrameRate.max,
        animate: true,
      );
    } else {
      return LaImage(
        width: _getSize(context),
        height: _getSize(context),
        imageLink: asset,
        fit: switch (type) {
          LaEpicImageType.standard => BoxFit.contain,
          LaEpicImageType.avatar => BoxFit.cover,
          LaEpicImageType.animation => BoxFit.contain,
        },
        fallback: fallbackAsset == null ? null : LaImage(imageLink: fallbackAsset!),
      );
    }
  }

  double _getSize(BuildContext context) {
    final double dimension =
        heightAsPercentageOfScreen == null ? MediaQuery.sizeOf(context).width : MediaQuery.sizeOf(context).height;
    final double fraction =
        heightAsPercentageOfScreen == null ? widthAsPercentageOfScreen : heightAsPercentageOfScreen!;
    final double size = dimension * fraction;
    return size;
  }
}
