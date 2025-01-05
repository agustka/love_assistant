import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/setup.dart';

Future<void> main() async {
  await appSetup();

  final InitializationService initService = getIt<InitializationService>();
  await initService.init();
  final Brightness? userBrightness = await initService.getPreferredBrightness();
  final Locale? userLocale = await initService.getPreferredLocale();

  if (userBrightness != null) {
    LaTheme.brightness = userBrightness;
  } else {
    final Brightness brightness = PlatformDispatcher.instance.platformBrightness;
    LaTheme.brightness = brightness;
  }

  if (userLocale != null) {
    App.userLocale = UserLocale.fromLocale(userLocale);
  }

  runApp(const App());
}
