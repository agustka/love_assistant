import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/assets/assets.gen.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/widgets/la_app_bar.dart';
import 'package:la/presentation/core/widgets/la_scaffold.dart';
import 'package:la/presentation/core/widgets/la_svg.dart';

class App extends StatefulWidget {
  static UserLocale? _userLocale;
  static bool _brightnessSet = false;
  static Brightness _brightness = Brightness.dark;
  static SystemUiOverlayStyle chrome = SystemUiOverlayStyle.dark;

  static Brightness get brightness => _brightness;
  static set brightness(Brightness brightness) {
    _brightness = brightness;
    final SystemUiOverlayStyle which =
        brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
    chrome = which.copyWith(
      statusBarColor: LaTheme.surface(),
      systemNavigationBarColor: LaTheme.surface(),
    );
  }

  static UserLocale get userLocale => _userLocale ?? UserLocale.english();

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

    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) {
        setState(() {
          App._brightnessSet = true;
          App.brightness = PlatformDetector.platformBrightness(context);
        });
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {
      App.brightness = View.of(context).platformDispatcher.platformBrightness;

      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: LaTheme.surface(),
        systemNavigationBarColor: LaTheme.surface(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!App._brightnessSet) {
      return const SizedBox.shrink();
    }
    return PlatformDetector.isIOS
        ? CupertinoApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: LaTheme.cupertinoTheme(),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          )
        : MaterialApp(
            onGenerateTitle: (BuildContext context) => S.of(context).app_name,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: LaTheme.materialTheme(),
            home: const HomePage(),
          );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LaScaffold(
      appBar: const LaAppBar(showBack: false, takesUpSpace: false),
      child: Center(
        child: LaSvg(
          AppAssets.icons.loveAssistantLogo,
          width: MediaQuery.sizeOf(context).width * 0.25,
          height: MediaQuery.sizeOf(context).width * 0.25,
          accessibilityScaling: false,
        ),
      ),
    );
  }
}
