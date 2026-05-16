import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';

extension IntExtension on int {
  String get ordinal {
    String ordinalSuffix = "";
    if (this == 1) {
      ordinalSuffix = S.current.ordinal_suffix_first;
    } else if (this == 2) {
      ordinalSuffix = S.current.ordinal_suffix_second;
    } else if (this == 3) {
      ordinalSuffix = S.current.ordinal_suffix_third;
    } else if (this == 3) {
      ordinalSuffix = S.current.ordinal_suffix_generic;
    } else {
      ordinalSuffix = S.current.ordinal_suffix_generic;
    }
    return ordinalSuffix.trim();
  }

  Duration get milliseconds => Duration(milliseconds: this);
  Duration get seconds => Duration(seconds: this);
  Duration get minutes => Duration(minutes: this);
  Duration get hours => Duration(hours: this);
  Duration get days => Duration(days: this);
  Duration get months => Duration(days: this * 30);
  Duration get years => Duration(days: this * 365);

  /// Converts seconds to a digital clock 120 => 2:00, 66 => 1:06 etc...
  String get timeString => "${this ~/ 60}:${(this % 60).toString().padLeft(2, '0')}";
}

extension DoubleExtension on double {
  double normalizeRange({required double min, required double max}) {
    if (min == max) {
      if (this < min) {
        return 0;
      } else {
        return 1;
      }
    }
    return (this - min) / (max - min);
  }

  /// Linearly interpolates between [startValue] and [endValue] by this value (treated as t).
  /// Example: 0.5.lerp(10, 20) == 15
  double lerp(double startValue, double endValue) {
    return startValue + this * (endValue - startValue);
  }

  Duration get milliseconds => Duration(milliseconds: round());
  Duration get seconds => Duration(seconds: round());
  Duration get minutes => Duration(minutes: round());
  Duration get hours => Duration(hours: round());
  Duration get days => Duration(days: round());
}

extension StringExtensions on String {
  String get removeEndingSlash {
    if (endsWith("/")) {
      return substring(0, length - 1);
    }
    return this;
  }

  String get superTrim {
    return trim().replaceAll("\u200B", "").replaceAll("\u200C", "").replaceAll("\u200D", "");
  }

  String get noWhiteSpaces {
    return replaceAll(RegExp(r"\s+"), "");
  }

  String get capitalized {
    final String text = trim();
    if (text.isEmpty) {
      return text;
    }
    if (text.length == 1) {
      return toUpperCase();
    }
    return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
  }

  String get capitalizeWords {
    return split(" ").map((String word) => word.capitalized).join(" ");
  }

  bool get isNumeric {
    if (isEmpty) {
      return true;
    }
    return double.tryParse(this) != null;
  }

  String get digitsOnly {
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      final String character = this[i];
      if (_isDigit(character)) {
        buffer.write(character);
      }
    }
    return buffer.toString();
  }

  String get digitsAndSeparatorsOnly {
    return replaceAll(RegExp("[^0-9.,-]"), "");
  }

  String charAt(int index) {
    if (index >= length) {
      return "";
    }
    return this[index];
  }

  bool _isDigit(String char) => (char.codeUnitAt(0) ^ 0x30) <= 9;

  String get noIcelandicChars {
    return replaceAll("í", "i")
        .replaceAll("ó", "o")
        .replaceAll("æ", "ae")
        .replaceAll("é", "e")
        .replaceAll("ð", "d")
        .replaceAll("ö", "o")
        .replaceAll("þ", "th")
        .replaceAll("á", "a")
        .replaceAll("ý", "y")
        .replaceAll("ú", "u");
  }

  /// Converts the string into a dash-separated, uppercase identifier with letters only.
  String toEventIdentifier() {
    // 1) Truncate first (to avoid processing unnecessarily long strings)
    final String truncated = length > 100 ? substring(0, 100) : this;

    // 2) Convert Icelandic characters
    String result = truncated.noIcelandicChars;

    // 3) Convert to uppercase
    result = result.toUpperCase();

    // 4) Replace non-letters with a dash
    result = result.replaceAll(RegExp("[^A-Z]+"), "-");

    // 5) Remove leading/trailing/duplicate dashes
    result = result.replaceAll(RegExp("^-+|-+\$"), "");
    result = result.replaceAll(RegExp("-+"), "-");

    return result;
  }

  String get toBase64 {
    return base64.encode(utf8.encode(this));
  }

  String get fromBase64 {
    return utf8.decode(base64.decode(this));
  }

  String get withoutMarkupTags {
    return replaceAll(RegExp(r"<[^>]+>((.|\n)*</[^>]+>)?"), "");
  }

  String get withoutHyperlinks {
    final RegExp urlRegExp = RegExp(
      r"((https?://)?([\w\-]+\.)+[a-zA-Z]{2,6}(:\d+)?(/\S*)?)",
      caseSensitive: false,
    );
    return replaceAll(urlRegExp, "");
  }

  String get escapeNonLatin1 {
    final StringBuffer buffer = StringBuffer();
    for (final int codeUnit in runes) {
      if (codeUnit <= 0xFF) {
        buffer.write(String.fromCharCode(codeUnit));
      } else {
        buffer.write("&#$codeUnit;");
      }
    }
    return buffer.toString();
  }

  int get latin1AlphabeticCharactersCount {
    int count = 0;

    for (final int codeUnit in codeUnits) {
      final bool isAsciiUpperCaseLetter = codeUnit >= 0x41 && codeUnit <= 0x5A;
      final bool isAsciiLowerCaseLetter = codeUnit >= 0x61 && codeUnit <= 0x7A;
      final bool isLatin1UpperCaseLetter = codeUnit >= 0xC0 && codeUnit <= 0xD6;
      final bool isLatin1MiddleLetterRange = codeUnit >= 0xD8 && codeUnit <= 0xF6;
      final bool isLatin1LowerCaseLetter = codeUnit >= 0xF8 && codeUnit <= 0xFF;

      if (isAsciiUpperCaseLetter ||
          isAsciiLowerCaseLetter ||
          isLatin1UpperCaseLetter ||
          isLatin1MiddleLetterRange ||
          isLatin1LowerCaseLetter) {
        count++;
      }
    }

    return count;
  }

  bool get isJson {
    final String trimmed = trim();
    return startsWith("{") && trimmed.endsWith("}");
  }

  /// Converts all non-ASCII characters to their HTML escaped form (e.g., 😀 → &#x1f600;).
  String get toHtmlEscapedAsciiSafe {
    final StringBuffer buffer = StringBuffer();
    for (final int rune in runes) {
      if (rune <= 0x7F) {
        buffer.writeCharCode(rune);
      } else {
        buffer.write("&#x${rune.toRadixString(16)};");
      }
    }
    return buffer.toString();
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
    <K, List<E>>{},
        (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
  );
}

extension FileExtension on File {
  Future<double> getSizeInMegabytes() async {
    final Uint8List fileBytes = await readAsBytes();
    const double oneMegabyte = 1024.0 * 1024.0;
    final double megabytes = fileBytes.lengthInBytes / oneMegabyte;
    return megabytes;
  }
}

extension ImageExtendsion on Image {
  Future<Color?> calculateDominantColor({Color? fallback}) async {
    final ImageProvider imageProvider = this.image;
    final Uint8List? imageBytes = imageProvider is MemoryImage
        ? imageProvider.bytes
        : await getImageBytes(ui.ImageByteFormat.png);
    if (imageBytes == null) {
      return fallback;
    }

    final Image image = Image.memory(imageBytes);

    final Completer<Map<Color, int>> completer = Completer<Map<Color, int>>();

    image.image
        .resolve(ImageConfiguration.empty)
        .addListener(
      ImageStreamListener((ImageInfo info, bool _) async {
        final Map<Color, int> pixelMap = <Color, int>{};

        try {
          final ByteData byteData = (await info.image.toByteData()) ?? ByteData(0);
          final Uint8List buffer = byteData.buffer.asUint8List();
          for (int i = 0; i < buffer.length; i += 4) {
            final Color color = Color.fromRGBO(
              buffer[i],
              buffer[i + 1],
              buffer[i + 2],
              buffer[i + 3] / 255,
            );
            pixelMap[color] = (pixelMap[color] ?? 0) + 1;
          }

          completer.complete(pixelMap);
        } catch (_) {
          completer.complete(pixelMap);
        }
      }),
    );

    final Map<Color, int> pixelMap = await completer.future;

    // Find the color with the highest count
    Color dominantColor = Colors.transparent;
    int maxCount = 0;

    for (final Color color in pixelMap.keys) {
      final int count = pixelMap[color] ?? 0;
      if (count > maxCount) {
        dominantColor = color;
        maxCount = count;
      }
    }

    if (dominantColor == Colors.transparent) {
      return null;
    }

    return dominantColor;
  }

  Future<Uint8List?> getImageBytes(ui.ImageByteFormat format) {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Completer<Uint8List?> work = Completer<Uint8List>();

    image
        .resolve(ImageConfiguration.empty)
        .addListener(
      ImageStreamListener((ImageInfo info, bool _) async {
        try {
          canvas.drawImageRect(
            info.image,
            Rect.fromLTRB(0, 0, info.image.width.toDouble(), info.image.height.toDouble()),
            Rect.fromLTRB(0, 0, info.image.width.toDouble(), info.image.height.toDouble()),
            Paint(),
          );

          final ui.Picture picture = recorder.endRecording();
          final ui.Image img = await picture.toImage(
            info.image.width,
            info.image.height,
          );
          final ByteData data = (await img.toByteData(format: format)) ?? ByteData(0);
          final Uint8List bytes = data.buffer.asUint8List();

          work.complete(bytes);
        } catch (_) {
          work.complete(null);
        }
      }),
    );

    return work.future;
  }
}

extension ColorExtension on Color {
  Color getGradientLightShade({double lightnessFactor = 0.1}) {
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + lightnessFactor).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Color getGradientDarkShade({double lightnessFactor = 0.1}) {
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness - lightnessFactor).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  bool isLowContrast(Color backgroundColor) {
    final double luminance1 = backgroundColor.computeLuminance();
    final double luminance2 = computeLuminance();

    final double contrast = (luminance1 + 0.05) / (luminance2 + 0.05);
    final bool lowContrast = contrast < 1.5;

    return lowContrast;
  }
}

extension Sets<E> on Set<E> {
  /// Returns the elements that are in either the first or the second set but not in both.
  Set<E> pairless(Set<E> other) {
    final Set<E> firstDiff = difference(other);
    final Set<E> secondDiff = other.difference(this);
    return firstDiff.union(secondDiff);
  }
}

extension FutureFunctionX<T extends Object> on Future<T> Function() {
  /// Used to repeatedly call async function until [condition] evaluates to true.
  Future<T> callUntil(
      FutureOr<bool> Function(T) condition, {
        required int maxTries,
        Duration delay = const Duration(milliseconds: 100),
      }) async {
    int tries = 0;
    while (true) {
      tries++;
      if (tries >= maxTries) {
        throw Exception("Max tries reached");
      }

      final value = await call();
      final evaluation = await condition(value);
      if (evaluation) {
        return value;
      }

      await Future<void>.delayed(delay);
    }
  }
}

extension SizeExtension on Size {
  Size swapSizeValues({bool swap = true}) {
    if (!swap) {
      return this;
    }
    return Size(height, width);
  }
}
