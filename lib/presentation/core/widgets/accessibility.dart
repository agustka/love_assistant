import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/app.dart';

class Accessibility {
  static double? androidDensityFactor;

  static const double minFontScale = 1.0;
  static const double maxFontScale = 3.11;

  final double scale;
  final double pixelDensity;
  final AccessibilitySize size;
  final bool screenReader;
  final bool boldText;

  bool get huge => size == AccessibilitySize.huge;
  bool get large => size == AccessibilitySize.large;
  bool get normal => size == AccessibilitySize.normal;
  bool get small => size == AccessibilitySize.small;

  bool get isSizeBiggerThanNormal {
    return switch (size) {
      AccessibilitySize.small || AccessibilitySize.normal => false,
      AccessibilitySize.large || AccessibilitySize.huge => true,
    };
  }

  double get uiScale {
    if (PlatformDetector.isIOS) {
      return scale;
    } else {
      return scale * (androidDensityFactor ?? 1);
    }
  }

  const Accessibility._({
    required this.scale,
    required this.pixelDensity,
    required this.size,
    required this.screenReader,
    required this.boldText,
  });

  factory Accessibility.normal() {
    return const Accessibility._(
      scale: 1,
      pixelDensity: 1,
      size: AccessibilitySize.normal,
      screenReader: false,
      boldText: false,
    );
  }

  factory Accessibility.of(BuildContext context) {
    if (!context.mounted) {
      return Accessibility.normal();
    }

    final double scale = MediaQuery.of(context).textScaler.scale(16) / 16.0;

    final MediaQueryData media = MediaQuery.of(context);
    final double pixelDensity = media.devicePixelRatio;
    final bool screenReader = media.accessibleNavigation;
    final bool boldText = media.boldText;

    AccessibilitySize size = AccessibilitySize.normal;
    if (scale >= 1.9) {
      size = AccessibilitySize.huge;
    } else if (scale >= 1.3) {
      size = AccessibilitySize.large;
    } else if (scale >= 1) {
      size = AccessibilitySize.normal;
    } else {
      size = AccessibilitySize.small;
    }

    final Accessibility accessibility = Accessibility._(
      scale: scale,
      pixelDensity: pixelDensity,
      size: size,
      screenReader: screenReader,
      boldText: boldText,
    );

    return accessibility;
  }

  bool get isInAccessibilityMode {
    return uiScale > 1.25;
  }

  TextStyle getScaledFont({required TextStyle textStyle}) {
    if (isInAccessibilityMode) {
      double min = PlatformDetector.isAndroid ? 1.2 : 1.6;
      double max = PlatformDetector.isAndroid ? 1.6 : 2;
      if (uiScale > max) {
        max = uiScale;
      }
      if (uiScale < min) {
        min = uiScale;
      }
      final double scaleUp = 1 + (uiScale - min) / (max - min);
      final double fontSize = textStyle.fontSize ?? 1;
      return textStyle.copyWith(fontSize: (fontSize * scaleUp).roundToDouble());
    }
    return textStyle;
  }

  static String convertDateTimeToVoiceOverSentence(DateTime? date) {
    final DateFormat accessibilityDateTimeFormat = DateFormat.yMMMMd(App.userLocale?.locale.languageCode);

    if (date == null) {
      return "Invalid date.";
    } else {
      return "${accessibilityDateTimeFormat.format(date)}.";
    }
  }

  /// Takes in a string like "491008-0160" and turns it into a readable voiceover message like "49, 10, 08, dash, 01, 60."
  static String convertStringToVoiceOverSentence(String value) {
    if (value.isEmpty) {
      return "";
    }

    final StringBuffer buffer = StringBuffer();
    value.trim().replaceAll("–", "-").split("-").forEach((String part) {
      final List<String> chars = part.split("");
      for (int i = 1; i < chars.length + 1; i++) {
        final String char = chars[i - 1];
        buffer.write(char);
        if (i.isEven) {
          // we add a comma every second char so that the reader can read 2 digit numbers
          buffer.write(", ");
        }
      }
      // replace a "-" with a word, to avoid reading it like "minus 6"
      buffer.write("dash, ");
    });
    final String string = buffer.toString();

    // remove the last 'dash, ' part that was added in the last loop and also add a dot at the end to have a small pause
    return "${string.substring(0, string.length - 8)}.";
  }
}

enum AccessibilitySize {
  huge,
  large,
  normal,
  small,
}
