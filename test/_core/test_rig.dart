import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/setup.config.dart';
import 'package:la/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_setup/builders/base_builder.dart';
import 'test_setup/test_setup.dart';

const Locale _testLocale = Locale("en", "US");

List<TestSetupConstructor> _activeConstructors = [];

Future<void> launchApp(
  WidgetTester tester, {
  required Widget home,
  Map<String, WidgetBuilder> routes = const {},
  List<BaseBuilder> builders = const [],
  Brightness brightness = Brightness.light,
  bool accessibilityMode = false,
  double accessibilityTextScaleFactor = 2.0,
  Size size = const Size(390, 844),
  PageName? initialPageName,
}) async {
  await _bootstrapOfflineDependencies(builders);

  LaTheme.brightness = brightness;
  App.userLocale = UserLocale.fromLocale(_testLocale);

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  final PageName? effectiveInitialPageName = initialPageName ?? AppPages.pageNameForWidget(home);
  final Map<String, WidgetBuilder> effectiveRoutes = _routesFor(
    home: home,
    routes: routes,
    initialPageName: effectiveInitialPageName,
  );
  AppPages.navigationObserver.reset();

  await tester.pumpWidget(
    BlocProvider<LanguageCubit>(
      create: (BuildContext context) {
        return getIt<LanguageCubit>();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _testLocale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: LaTheme.materialTheme(brightness),
        builder: (BuildContext context, Widget? child) {
          if (!accessibilityMode) {
            return child!;
          }
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaler: TextScaler.linear(accessibilityTextScaleFactor)),
            child: child!,
          );
        },
        navigatorObservers: effectiveInitialPageName == null ? const [] : [AppPages.navigationObserver],
        routes: effectiveRoutes,
        initialRoute: effectiveInitialPageName?.route,
        onGenerateInitialRoutes: effectiveInitialPageName == null
            ? null
            : (String initialRoute) {
                return [
                  MaterialPageRoute<void>(
                    settings: RouteSettings(name: initialRoute),
                    builder: effectiveRoutes[initialRoute]!,
                  ),
                ];
              },
        home: effectiveInitialPageName == null ? home : null,
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Map<String, WidgetBuilder> _routesFor({
  required Widget home,
  required Map<String, WidgetBuilder> routes,
  required PageName? initialPageName,
}) {
  if (initialPageName == null) {
    return routes;
  }
  return {
    ...AppPages.routesFor(AppPageType.material),
    ...routes,
    initialPageName.route: (BuildContext context) => home,
  };
}

Future<void> closeApp() async {
  for (final TestSetupConstructor constructor in _activeConstructors) {
    await constructor.tearDown();
  }
  _activeConstructors = [];
  LaTheme.brightness = null;
  App.userLocale = null;
  await getIt.reset();
}

Future<void> _bootstrapOfflineDependencies(List<BaseBuilder> builders) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(const {});

  await getIt.reset();
  InjectableEnv.current = InjectableEnv.offline;
  await getIt.init(environment: InjectableEnv.offline.name);

  _activeConstructors = builders.map((BaseBuilder builder) => builder.build()).toList();
  for (final TestSetupConstructor constructor in _activeConstructors) {
    await constructor.setup();
  }
}
