import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la/presentation/core/theme/la_theme_illustrations.dart';

class LaPadding {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 32;
  static const double huge = 40;
  static const double extraHuge = 48;
  static const double bottomPadding = 18;
}

class LaTheme {
  static bool brightnessSet = false;
  static Brightness _brightness = Brightness.dark;
  static SystemUiOverlayStyle chrome = SystemUiOverlayStyle.dark;
  static SystemUiOverlayStyle chromeNoSpace = SystemUiOverlayStyle.dark;

  static LaThemeIllustrations get illustrations => LaThemeIllustrations(isDarkMode: _brightness == Brightness.dark);

  static Brightness get brightness => _brightness;
  static set brightness(Brightness brightness) {
    _brightness = brightness;
    chromeNoSpace = (brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light).copyWith(
      statusBarColor: LaTheme.surface(),
      systemNavigationBarColor: LaTheme.surface(),
    );
    chrome = (brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
      statusBarColor: LaTheme.primary(),
      systemNavigationBarColor: LaTheme.surface(),
    );
  }

  static TextStyle get font => const TextStyle();

  static const Color _lightPrimary = Color(0xFFD85555);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFFFFD700);
  static const Color _lightOnSecondary = Color(0xFF0E0E0E);
  static const Color _lightError = Color(0xFFFF0000);
  static const Color _lightOnError = Color(0xFFFFFFFF);
  static const Color _lightSurface = Color(0xFFFEFEFE);
  static const Color _lightOnSurface = Color(0xFF0E0E0E);
  static const Color _lightSecondaryContainer = Color(0xFFD1D1D1);
  static const Color _lightOnSecondaryContainer = Color(0xFF0E0E0E);

  static const Color _darkPrimary = Color(0xFFd85555);
  static const Color _darkOnPrimary = Color(0xFF000000);
  static const Color _darkSecondary = Color(0xFF1A1010);
  static const Color _darkOnSecondary = Color(0xFFDADADA);
  static const Color _darkError = Color(0xFFFF0000);
  static const Color _darkOnError = Color(0xFFFFFFFF);
  static const Color _darkSurface = Color(0xFF1A1010);
  static const Color _darkOnSurface = Color(0xFFFAFAFA);
  static const Color _darkSecondaryContainer = Color(0xFF121212);
  static const Color _darkOnSecondaryContainer = Color(0xFFA7A7A7);

  static Color primary() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkPrimary : _lightPrimary;
  }

  static Color onPrimary() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkOnPrimary : _lightOnPrimary;
  }

  static Color secondary() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkSecondary : _lightSecondary;
  }

  static Color onSecondary() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkOnSecondary : _lightOnSecondary;
  }

  static Color surface() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkSurface : _lightSurface;
  }

  static Color onSurface() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkOnSurface : _lightOnSurface;
  }

  static Color error() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkError : _lightError;
  }

  static Color onError() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkOnError : _lightOnError;
  }

  static Color secondaryContainer() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkSecondaryContainer : _lightSecondaryContainer;
  }

  static Color onSecondaryContainer() {
    final bool isDark = LaTheme.brightness == Brightness.dark;
    return isDark ? _darkOnSecondaryContainer : _lightOnSecondaryContainer;
  }

  static ThemeData materialTheme() {
    return ThemeData(
      brightness: LaTheme.brightness,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: surface(),
      colorScheme: ColorScheme(
        brightness: LaTheme.brightness,
        primary: primary(),
        onPrimary: onPrimary(),
        secondary: secondary(),
        onSecondary: onSecondary(),
        error: error(),
        onError: onError(),
        surface: surface(),
        onSurface: onSurface(),
        secondaryContainer: secondaryContainer(),
        onSecondaryContainer: onSecondaryContainer(),
      ),
    );
  }

  static CupertinoThemeData cupertinoTheme() {
    return CupertinoThemeData(
      brightness: LaTheme.brightness,
      primaryColor: primary(),
      barBackgroundColor: surface(),
      scaffoldBackgroundColor: surface(),
      applyThemeToAll: true,
      textTheme: CupertinoTextThemeData(
        primaryColor: onPrimary(),
        textStyle: GoogleFonts.poppins().copyWith(color: onSurface()),
      ),
    );
  }
}

extension ColorExtension on Color {
  TextStyle get text {
    return TextStyle(color: this);
  }

  ColorFilter get svg {
    return ColorFilter.mode(this, BlendMode.srcIn);
  }
}

extension TextStyleExtension on TextStyle {
  TextStyle get body32 => copyWith(fontSize: 32);
  TextStyle get body18 => copyWith(fontSize: 18);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get light => copyWith(fontWeight: FontWeight.w400);
}
