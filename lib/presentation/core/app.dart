import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/auth/sign_up_page.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/landing/landing_page.dart';
import 'package:la/presentation/main/main_page.dart';
import 'package:la/presentation/splash/splash_page.dart';
import 'package:la/presentation/wizard/wizard_page.dart';
import 'package:la/setup.dart';

enum PageName {
  splash("/"),
  landing("/landing"),
  wizard("/wizard"),
  login("/login"),
  signUp("/sign-up"),
  emailConfirmation("/email-confirmation"),
  main("/main");

  final String route;

  const PageName(this.route);
}

enum AppPageType {
  cupertino,
  material,
}

enum AppPageTransition {
  platformDefault,
}

class AppPageDescriptor {
  final PageName name;
  final Key? identityKey;
  final Set<AppPageType> pageTypes;
  final AppPageTransition transition;
  final Widget Function(BuildContext context, Key? identityKey) builder;

  String get route {
    return name.route;
  }

  const AppPageDescriptor({
    required this.name,
    required this.builder,
    this.identityKey,
    this.pageTypes = const {
      AppPageType.cupertino,
      AppPageType.material,
    },
    this.transition = AppPageTransition.platformDefault,
  });

  bool supports(AppPageType pageType) {
    return pageTypes.contains(pageType);
  }

  Widget build(BuildContext context) {
    return builder(context, identityKey);
  }
}

class AppPages {
  static const List<AppPageDescriptor> all = [
    AppPageDescriptor(
      name: PageName.splash,
      builder: _splash,
    ),
    AppPageDescriptor(
      name: PageName.landing,
      identityKey: LandingPage.pageKey,
      builder: _landing,
    ),
    AppPageDescriptor(
      name: PageName.main,
      identityKey: MainPage.pageKey,
      builder: _main,
    ),
    AppPageDescriptor(
      name: PageName.wizard,
      identityKey: WizardPage.pageKey,
      builder: _wizard,
    ),
    AppPageDescriptor(
      name: PageName.login,
      identityKey: LoginPage.pageKey,
      builder: _login,
    ),
    AppPageDescriptor(
      name: PageName.signUp,
      identityKey: SignUpPage.pageKey,
      builder: _signUp,
    ),
    AppPageDescriptor(
      name: PageName.emailConfirmation,
      identityKey: EmailConfirmationPage.pageKey,
      builder: _emailConfirmation,
    ),
  ];

  const AppPages._();

  static Map<String, WidgetBuilder> routesFor(AppPageType pageType) {
    return {
      for (final AppPageDescriptor page in all)
        if (page.supports(pageType)) page.route: page.build,
    };
  }

  static Widget _splash(BuildContext context, Key? identityKey) {
    return SplashPage(key: identityKey);
  }

  static Widget _landing(BuildContext context, Key? identityKey) {
    return LandingPage(key: identityKey);
  }

  static Widget _main(BuildContext context, Key? identityKey) {
    return MainPage(key: identityKey);
  }

  static Widget _wizard(BuildContext context, Key? identityKey) {
    return WizardPage(key: identityKey);
  }

  static Widget _login(BuildContext context, Key? identityKey) {
    return LoginPage(key: identityKey);
  }

  static Widget _signUp(BuildContext context, Key? identityKey) {
    return SignUpPage(key: identityKey);
  }

  static Widget _emailConfirmation(BuildContext context, Key? identityKey) {
    return EmailConfirmationPage(key: identityKey);
  }
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
    final Widget core = PlatformDetector.isIOS
        ? CupertinoApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            navigatorKey: App.navigatorKey,
            routes: AppPages.routesFor(AppPageType.cupertino),
            initialRoute: PageName.splash.route,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: App.userLocale?.locale,
            theme: LaTheme.cupertinoTheme(LaTheme.brightness ?? Brightness.light),
            debugShowCheckedModeBanner: false,
          )
        : MaterialApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            navigatorKey: App.navigatorKey,
            routes: AppPages.routesFor(AppPageType.material),
            initialRoute: PageName.splash.route,
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
          );

    return BlocProvider<LanguageCubit>(
      create: (BuildContext context) {
        return getIt<LanguageCubit>();
      },
      child: BlocConsumer<LanguageCubit, LanguageState>(
        listener: (BuildContext context, LanguageState state) {
          setState(() {
            App.userLocale = UserLocale.fromLanguage(state.language);
          });
        },
        builder: (BuildContext context, LanguageState state) {
          return core;
        },
      ),
    );
  }
}
