import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LaImage extends StatelessWidget {
  final String imageLink;
  final Widget? fallback;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool applyVignetteIfLowContrast;
  final ImageFrameBuilder? frameBuilder;

  Widget get _fallback => fallback ?? const SizedBox.shrink();

  const LaImage({
    super.key,
    required this.imageLink,
    this.fallback,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.frameBuilder,
    this.applyVignetteIfLowContrast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageLink.startsWith("http")) {
      return _networked(context);
    } else {
      return _asset(context);
    }
  }

  Widget _networked(BuildContext context) {
    if (imageLink.endsWith("svg")) {
      return SvgPicture.network(
        imageLink,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (BuildContext context) => _fallback,
      );
    }

    return Image.network(
      imageLink,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: frameBuilder,
      errorBuilder: (BuildContext context, Object error, StackTrace? trace) => _fallback,
    );
  }

  Widget _asset(BuildContext context) {
    if (imageLink.startsWith("/")) {
      return _LaFileImage(
        path: imageLink,
        fallback: fallback,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: frameBuilder,
      );
    } else {
      if (imageLink.toLowerCase().endsWith("svg")) {
        return SizedBox(
          width: width,
          height: height,
          child: SvgPicture.asset(
            imageLink,
            width: width,
            height: height,
            fit: fit,
            placeholderBuilder: (BuildContext context) => _fallback,
          ),
        );
      } else {
        return Image.asset(
          width: width,
          height: height,
          imageLink,
          fit: fit,
          frameBuilder: frameBuilder,
          errorBuilder: (BuildContext context, Object error, StackTrace? trace) => _fallback,
        );
      }
    }
  }
}

class _LaFileImage extends StatelessWidget {
  final String path;
  final Widget? fallback;
  final BoxFit fit;
  final double? width;
  final double? height;
  final ImageFrameBuilder? frameBuilder;

  const _LaFileImage({
    required this.path,
    this.fallback,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.frameBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
