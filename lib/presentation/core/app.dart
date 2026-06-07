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
  final Set<AppPageType> pageTypes;
  final AppPageTransition transition;
  final WidgetBuilder builder;

  String get route {
    return name.route;
  }

  const AppPageDescriptor({
    required this.name,
    required this.builder,
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
    return builder(context);
  }
}

class AppPageNavigationObserver extends NavigatorObserver {
  final List<AppPageDescriptor> _stack = [];

  AppPageDescriptor? get currentPage {
    if (_stack.isEmpty) {
      return null;
    }
    return _stack.last;
  }

  List<AppPageDescriptor> get stack {
    return List.unmodifiable(_stack);
  }

  void reset() {
    _stack.clear();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final AppPageDescriptor? descriptor = AppPages.descriptorForRoute(route.settings.name);
    if (descriptor != null) {
      _stack.add(descriptor);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final AppPageDescriptor? descriptor = AppPages.descriptorForRoute(route.settings.name);
    if (descriptor != null) {
      _removeLast(descriptor);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final AppPageDescriptor? descriptor = AppPages.descriptorForRoute(route.settings.name);
    if (descriptor != null) {
      _removeLast(descriptor);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final AppPageDescriptor? oldDescriptor = AppPages.descriptorForRoute(oldRoute?.settings.name);
    final AppPageDescriptor? newDescriptor = AppPages.descriptorForRoute(newRoute?.settings.name);
    if (oldDescriptor != null) {
      _removeLast(oldDescriptor);
    }
    if (newDescriptor != null) {
      _stack.add(newDescriptor);
    }
  }

  void _removeLast(AppPageDescriptor descriptor) {
    for (int index = _stack.length - 1; index >= 0; index -= 1) {
      if (_stack[index] == descriptor) {
        _stack.removeAt(index);
        return;
      }
    }
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
      builder: _landing,
    ),
    AppPageDescriptor(
      name: PageName.main,
      builder: _main,
    ),
    AppPageDescriptor(
      name: PageName.wizard,
      builder: _wizard,
    ),
    AppPageDescriptor(
      name: PageName.login,
      builder: _login,
    ),
    AppPageDescriptor(
      name: PageName.signUp,
      builder: _signUp,
    ),
    AppPageDescriptor(
      name: PageName.emailConfirmation,
      builder: _emailConfirmation,
    ),
  ];

  static final AppPageNavigationObserver navigationObserver = AppPageNavigationObserver();

  const AppPages._();

  static AppPageDescriptor? descriptorForRoute(String? route) {
    if (route == null) {
      return null;
    }
    for (final AppPageDescriptor descriptor in all) {
      if (descriptor.route == route) {
        return descriptor;
      }
    }
    return null;
  }

  static AppPageDescriptor descriptorForName(PageName name) {
    for (final AppPageDescriptor descriptor in all) {
      if (descriptor.name == name) {
        return descriptor;
      }
    }
    throw ArgumentError.value(name, "name", "No app page descriptor is registered for this page name.");
  }

  static PageName? pageNameForWidget(Widget widget) {
    return switch (widget) {
      SplashPage() => PageName.splash,
      LandingPage() => PageName.landing,
      MainPage() => PageName.main,
      WizardPage() => PageName.wizard,
      LoginPage() => PageName.login,
      SignUpPage() => PageName.signUp,
      EmailConfirmationPage() => PageName.emailConfirmation,
      _ => null,
    };
  }

  static Map<String, WidgetBuilder> routesFor(AppPageType pageType) {
    return {
      for (final AppPageDescriptor page in all)
        if (page.supports(pageType)) page.route: page.build,
    };
  }

  static Widget _splash(BuildContext context) {
    return const SplashPage();
  }

  static Widget _landing(BuildContext context) {
    return const LandingPage();
  }

  static Widget _main(BuildContext context) {
    return const MainPage();
  }

  static Widget _wizard(BuildContext context) {
    return const WizardPage();
  }

  static Widget _login(BuildContext context) {
    return const LoginPage();
  }

  static Widget _signUp(BuildContext context) {
    return const SignUpPage();
  }

  static Widget _emailConfirmation(BuildContext context) {
    return const EmailConfirmationPage();
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
    AppPages.navigationObserver.reset();
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
            navigatorObservers: [AppPages.navigationObserver],
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
            navigatorObservers: [AppPages.navigationObserver],
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
