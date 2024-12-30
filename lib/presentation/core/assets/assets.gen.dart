/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/progress.json
  String get progress => 'assets/animations/progress.json';

  /// List of all assets
  List<String> get values => [progress];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/love_assistant_logo.svg
  String get loveAssistantLogo => 'assets/icons/love_assistant_logo.svg';

  /// List of all assets
  List<String> get values => [loveAssistantLogo];
}

class $AssetsIllustrationsGen {
  const $AssetsIllustrationsGen();

  /// Directory path: assets/illustrations/dark
  $AssetsIllustrationsDarkGen get dark => const $AssetsIllustrationsDarkGen();

  /// Directory path: assets/illustrations/light
  $AssetsIllustrationsLightGen get light => const $AssetsIllustrationsLightGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/love_assistant_logo.png
  AssetGenImage get loveAssistantLogo => const AssetGenImage('assets/images/love_assistant_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [loveAssistantLogo];
}

class $AssetsIllustrationsDarkGen {
  const $AssetsIllustrationsDarkGen();

  /// File path: assets/illustrations/dark/man_greetings.svg
  String get manGreetings => 'assets/illustrations/dark/man_greetings.svg';

  /// File path: assets/illustrations/dark/man_love.svg
  String get manLove => 'assets/illustrations/dark/man_love.svg';

  /// File path: assets/illustrations/dark/round_picture_background.svg
  String get roundPictureBackground => 'assets/illustrations/dark/round_picture_background.svg';

  /// File path: assets/illustrations/dark/woman_reading.svg
  String get womanReading => 'assets/illustrations/dark/woman_reading.svg';

  /// List of all assets
  List<String> get values => [manGreetings, manLove, roundPictureBackground, womanReading];
}

class $AssetsIllustrationsLightGen {
  const $AssetsIllustrationsLightGen();

  /// File path: assets/illustrations/light/man_greetings.svg
  String get manGreetings => 'assets/illustrations/light/man_greetings.svg';

  /// File path: assets/illustrations/light/man_love.svg
  String get manLove => 'assets/illustrations/light/man_love.svg';

  /// File path: assets/illustrations/light/round_picture_background.svg
  String get roundPictureBackground => 'assets/illustrations/light/round_picture_background.svg';

  /// File path: assets/illustrations/light/woman_reading.svg
  String get womanReading => 'assets/illustrations/light/woman_reading.svg';

  /// List of all assets
  List<String> get values => [manGreetings, manLove, roundPictureBackground, womanReading];
}

class AppAssets {
  AppAssets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsIllustrationsGen illustrations = $AssetsIllustrationsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
