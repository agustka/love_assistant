import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la/presentation/core/app.dart';

class LaPadding {
  static const double medium = 16;
}

class LaTheme {
  static const Color _lightPrimary = Color(0xFFE0311A);
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
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkPrimary : _lightPrimary;
  }

  static Color onPrimary() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkOnPrimary : _lightOnPrimary;
  }

  static Color secondary() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkSecondary : _lightSecondary;
  }

  static Color onSecondary() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkOnSecondary : _lightOnSecondary;
  }

  static Color surface() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkSurface : _lightSurface;
  }

  static Color onSurface() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkOnSurface : _lightOnSurface;
  }

  static Color error() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkError : _lightError;
  }

  static Color onError() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkOnError : _lightOnError;
  }

  static Color secondaryContainer() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkSecondaryContainer : _lightSecondaryContainer;
  }

  static Color onSecondaryContainer() {
    final bool isDark = App.brightness == Brightness.dark;
    return isDark ? _darkOnSecondaryContainer : _lightOnSecondaryContainer;
  }

  static ThemeData materialTheme() {
    return ThemeData(
      brightness: App.brightness,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: surface(),
      colorScheme: ColorScheme(
        brightness: App.brightness,
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
      brightness: App.brightness,
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
