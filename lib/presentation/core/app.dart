import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/splash/splash_page.dart';
import 'package:la/presentation/wizard/wizard_page.dart';
import 'package:la/setup.dart';

enum PageName {
  splash("/splash"),
  wizard("/wizard"),
  main("/main");

  final String route;

  const PageName(this.route);
}

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static UserLocale? userLocale;

  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() async {
      final PlatformDispatcher dispatcher = View.of(context).platformDispatcher;

      final InitializationService service = getIt<InitializationService>();
      final bool hasSet = (await service.getPreferredBrightness()) != null;
      if (!hasSet) {
        LaTheme.brightness = dispatcher.platformBrightness;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformDetector.isIOS
        ? CupertinoApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            navigatorKey: App.navigatorKey,
            routes: {
              PageName.splash.route: (BuildContext context) => const SplashPage(),
              PageName.wizard.route: (BuildContext context) => const WizardPage(),
            },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: App.userLocale?.locale,
            theme: LaTheme.cupertinoTheme(),
            debugShowCheckedModeBanner: false,
            initialRoute: PageName.splash.route,
          )
        : MaterialApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            navigatorKey: App.navigatorKey,
            routes: {
              PageName.splash.route: (BuildContext context) => const SplashPage(),
              PageName.wizard.route: (BuildContext context) => const WizardPage(),
            },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: App.userLocale?.locale,
            debugShowCheckedModeBanner: false,
            theme: LaTheme.materialTheme(Brightness.light),
            darkTheme: LaTheme.materialTheme(Brightness.dark),
            initialRoute: PageName.splash.route,
          );
  }
}
