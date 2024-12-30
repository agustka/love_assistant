import 'package:la/presentation/core/assets/assets.gen.dart';

class LaThemeIllustrations implements $AssetsIllustrationsDarkGen, $AssetsIllustrationsLightGen {
  final bool isDarkMode;

  const LaThemeIllustrations({required this.isDarkMode});

  $AssetsIllustrationsDarkGen get dark => const $AssetsIllustrationsDarkGen();

  $AssetsIllustrationsLightGen get light => const $AssetsIllustrationsLightGen();

  @override
  List<String> get values => [];

  @override
  String get womanReading => isDarkMode ? dark.womanReading : light.womanReading;

  @override
  String get manLove => isDarkMode ? dark.manLove : light.manLove;

  @override
  String get roundPictureBackground => isDarkMode ? dark.roundPictureBackground : light.roundPictureBackground;

  @override
  // TODO: implement manGreetings
  String get manGreetings => isDarkMode ? dark.manGreetings : light.manGreetings;
}
