import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la/presentation/core/theme/la_theme_illustrations.dart';

class LaPaddings {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double mediumSmall = 12;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 32;
  static const double huge = 40;
  static const double extraHuge = 48;
  static const double bottomPadding = 18;
}

class LaSizes {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double mediumSmall = 12;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 32;
  static const double huge = 40;
  static const double extraHuge = 48;
  static const double bottomPadding = 18;

  // Specific UI dimensions
  static const double pickerHeight = 300;
  static const double pickerHeaderHeight = 50;
  static const double dropdownHeight = 250;
  static const double pickerItemExtent = 32;
}

class LaElevation {
  static const double minimal = 0;
  static const double medium = 12;
}

class LaCornerRadius {
  // Primary radius values
  static const double extraSmall = 4;
  static const double small = 8;
  static const double mediumSmall = 12;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 32;
  static const double huge = 40;
  static const double extraHuge = 48;
}

extension LaCornerRadiusExtension on LaCornerRadius {
  RoundedRectangleBorder get drawer {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(LaCornerRadius.large),
        topRight: Radius.circular(LaCornerRadius.large),
      ),
    );
  }

  RoundedRectangleBorder get dialog {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(LaCornerRadius.large)),
    );
  }
}

class LaTheme {
  static Brightness? _brightness;
  static SystemUiOverlayStyle chrome = SystemUiOverlayStyle.dark;
  static SystemUiOverlayStyle chromeNoSpace = SystemUiOverlayStyle.dark;

  static LaThemeIllustrations get illustrations => LaThemeIllustrations(isDarkMode: _brightness == Brightness.dark);

  static Brightness? get brightness => _brightness;
  static set brightness(Brightness? brightness) {
    _brightness = brightness;
    chromeNoSpace = (brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light).copyWith(
      statusBarColor: LaTheme.surface(),
      systemNavigationBarColor: LaTheme.background(),
    );
    chrome = (brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
      statusBarColor: LaTheme.primary(),
      systemNavigationBarColor: LaTheme.background(),
    );
  }

  static TextStyle get font => TextStyle(color: LaTheme.onSurface());

  static const Color _lightBackground = Color(0xFFF9F9F9);
  static const Color _lightOnBackground = Color(0xFF0E0E0E);
  static const Color _lightSurface = Color(0xFFFEFEFE);
  static const Color _lightOnSurface = Color(0xFF2E2E2E);
  static const Color _lightSecondaryContainer = Color(0xFFEEEEEE);
  static const Color _lightOnSecondaryContainer = Color(0xFF262626);
  static const Color _lightTertiaryContainer = Color(0xFFE0E0E0);
  static const Color _lightOnTertiaryContainer = Color(0xFF0E0E0E);

  static const Color _lightPrimary = Color(0xFFD85555);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFFF0A07E);
  static const Color _lightOnSecondary = Color(0xFF0E0E0E);
  static const Color _lightShadow = Color(0x44000000);
  static const Color _lightSingleElement = Color(0x22000000);
  static const Color _lightHintText = Color(0xFFA0A0A0);
  static const Color _lightError = Color(0xFFD83535);
  static const Color _lightOnError = Color(0xFF1A0000);

  static const Color _darkBackground = Color(0xFF1A1010);
  static const Color _darkOnBackground = Color(0xFFE0E0E0);
  static const Color _darkSurface = Color(0xFF2B1E1E);
  static const Color _darkOnSurface = Color(0xFFDADADA);
  static const Color _darkSecondaryContainer = Color(0xFF3C2D2D);
  static const Color _darkOnSecondaryContainer = Color(0xFFF5F5F5);
  static const Color _darkTertiaryContainer = Color(0xFF2E2323);
  static const Color _darkOnTertiaryContainer = Color(0xFFF5F5F5);

  static const Color _darkPrimary = Color(0xFFd85555);
  static const Color _darkOnPrimary = Color(0xFF000000);
  static const Color _darkSecondary = Color(0xFFC76D5A);
  static const Color _darkOnSecondary = Color(0xFF0E0E0E);
  static const Color _darkShadow = Color(0xCC000000);
  static const Color _darkSingleElement = Color(0x33FFFFFF);
  static const Color _darkHintText = Color(0xFF707070);
  static const Color _darkError = Color(0xFFE54D4D);
  static const Color _darkOnError = Color(0xFF1A0000);

  static Color primary({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkPrimary : _lightPrimary;
  }

  static Color onPrimary({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnPrimary : _lightOnPrimary;
  }

  static Color secondary({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkSecondary : _lightSecondary;
  }

  static Color onSecondary({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnSecondary : _lightOnSecondary;
  }

  static Color surface({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkSurface : _lightSurface;
  }

  static Color onSurface({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnSurface : _lightOnSurface;
  }

  static Color error({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkError : _lightError;
  }

  static Color onError({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnError : _lightOnError;
  }

  static Color background({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkBackground : _lightBackground;
  }

  static Color onBackground({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnBackground : _lightOnBackground;
  }

  static Color secondaryContainer({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkSecondaryContainer : _lightSecondaryContainer;
  }

  static Color onSecondaryContainer({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnSecondaryContainer : _lightOnSecondaryContainer;
  }

  static Color tertiaryContainer({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkTertiaryContainer : _lightTertiaryContainer;
  }

  static Color onTertiaryContainer({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkOnTertiaryContainer : _lightOnTertiaryContainer;
  }

  static Color shadow({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkShadow : _lightShadow;
  }

  static Color singleElement({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkSingleElement : _lightSingleElement;
  }

  static Color hintText({Brightness? brightness}) {
    final bool isDark = (brightness ?? LaTheme.brightness) == Brightness.dark;
    return isDark ? _darkHintText : _lightHintText;
  }

  static ThemeData materialTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        fontFamily: "Poppins",
      ),
      scaffoldBackgroundColor: background(brightness: brightness),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary(brightness: brightness),
        onPrimary: onPrimary(brightness: brightness),
        secondary: secondary(brightness: brightness),
        onSecondary: onSecondary(brightness: brightness),
        error: error(brightness: brightness),
        onError: onError(brightness: brightness),
        surface: surface(brightness: brightness),
        onSurface: onSurface(brightness: brightness),
        secondaryContainer: secondaryContainer(brightness: brightness),
        onSecondaryContainer: onSecondaryContainer(brightness: brightness),
      ),
    );
  }

  static CupertinoThemeData cupertinoTheme(Brightness brightness) {
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: primary(brightness: brightness),
      barBackgroundColor: surface(brightness: brightness),
      scaffoldBackgroundColor: background(brightness: brightness),
      applyThemeToAll: true,
      textTheme: CupertinoTextThemeData(
        primaryColor: onPrimary(brightness: brightness),
        textStyle: const TextStyle(
          fontFamily: "Poppins",
        ).copyWith(color: onSurface(brightness: brightness)),
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
  TextStyle get body28 => copyWith(fontSize: 28);
  TextStyle get body24 => copyWith(fontSize: 24);
  TextStyle get body20 => copyWith(fontSize: 20);
  TextStyle get body18 => copyWith(fontSize: 18);
  TextStyle get body17 => copyWith(fontSize: 17);
  TextStyle get body16 => copyWith(fontSize: 16);
  TextStyle get body14 => copyWith(fontSize: 14);
  TextStyle get body12 => copyWith(fontSize: 12);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get light => copyWith(fontWeight: FontWeight.w400);

  TextStyle get primary => copyWith(color: LaTheme.primary());
  TextStyle get onPrimary => copyWith(color: LaTheme.onPrimary());
  TextStyle get secondary => copyWith(color: LaTheme.secondary());
  TextStyle get onSecondary => copyWith(color: LaTheme.onSecondary());
  TextStyle get onSurface => copyWith(color: LaTheme.onSurface());
  TextStyle get onSecondaryContainer => copyWith(color: LaTheme.onSecondaryContainer());
  TextStyle get onBackground => copyWith(color: LaTheme.onBackground());
  TextStyle get onError => copyWith(color: LaTheme.onError());
  TextStyle get hintText => copyWith(color: LaTheme.hintText());
}
