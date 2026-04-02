import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_loading_box_atom.dart';

enum LaTextAtomSize {
  body12,
  body14,
  body16,
  body17,
  body18,
  body20,
  body24,
  body28,
  body32,
}

enum LaTextAtomWeight {
  regular,
  light,
  bold,
}

enum LaTextAtomColor {
  onSurface,
  primary,
  onPrimary,
  secondary,
  onSecondary,
  onSecondaryContainer,
  onTertiaryContainer,
  onBackground,
  onError,
  hintText,
}

final class LaTextAtomStyle {
  final LaTextAtomSize size;
  final LaTextAtomWeight weight;
  final LaTextAtomColor color;

  const LaTextAtomStyle._({
    required this.size,
    this.weight = LaTextAtomWeight.regular,
    this.color = LaTextAtomColor.onSurface,
  });

  static const LaTextAtomStyle body12 = LaTextAtomStyle._(size: LaTextAtomSize.body12);
  static const LaTextAtomStyle body14 = LaTextAtomStyle._(size: LaTextAtomSize.body14);
  static const LaTextAtomStyle body16 = LaTextAtomStyle._(size: LaTextAtomSize.body16);
  static const LaTextAtomStyle body17 = LaTextAtomStyle._(size: LaTextAtomSize.body17);
  static const LaTextAtomStyle body18 = LaTextAtomStyle._(size: LaTextAtomSize.body18);
  static const LaTextAtomStyle body20 = LaTextAtomStyle._(size: LaTextAtomSize.body20);
  static const LaTextAtomStyle body24 = LaTextAtomStyle._(size: LaTextAtomSize.body24);
  static const LaTextAtomStyle body28 = LaTextAtomStyle._(size: LaTextAtomSize.body28);
  static const LaTextAtomStyle body32 = LaTextAtomStyle._(size: LaTextAtomSize.body32);

  LaTextAtomStyle get light => _copyWith(weight: LaTextAtomWeight.light);
  LaTextAtomStyle get bold => _copyWith(weight: LaTextAtomWeight.bold);

  LaTextAtomStyle get primary => _copyWith(color: LaTextAtomColor.primary);
  LaTextAtomStyle get onPrimary => _copyWith(color: LaTextAtomColor.onPrimary);
  LaTextAtomStyle get secondary => _copyWith(color: LaTextAtomColor.secondary);
  LaTextAtomStyle get onSecondary => _copyWith(color: LaTextAtomColor.onSecondary);
  LaTextAtomStyle get onSurface => _copyWith(color: LaTextAtomColor.onSurface);
  LaTextAtomStyle get onSecondaryContainer => _copyWith(color: LaTextAtomColor.onSecondaryContainer);
  LaTextAtomStyle get onTertiaryContainer => _copyWith(color: LaTextAtomColor.onTertiaryContainer);
  LaTextAtomStyle get onBackground => _copyWith(color: LaTextAtomColor.onBackground);
  LaTextAtomStyle get onError => _copyWith(color: LaTextAtomColor.onError);
  LaTextAtomStyle get hintText => _copyWith(color: LaTextAtomColor.hintText);

  TextStyle resolve() {
    TextStyle resolved = switch (size) {
      LaTextAtomSize.body12 => LaTheme.font.body12,
      LaTextAtomSize.body14 => LaTheme.font.body14,
      LaTextAtomSize.body16 => LaTheme.font.body16,
      LaTextAtomSize.body17 => LaTheme.font.body17,
      LaTextAtomSize.body18 => LaTheme.font.body18,
      LaTextAtomSize.body20 => LaTheme.font.body20,
      LaTextAtomSize.body24 => LaTheme.font.body24,
      LaTextAtomSize.body28 => LaTheme.font.body28,
      LaTextAtomSize.body32 => LaTheme.font.body32,
    };

    resolved = switch (weight) {
      LaTextAtomWeight.regular => resolved,
      LaTextAtomWeight.light => resolved.light,
      LaTextAtomWeight.bold => resolved.bold,
    };

    return switch (color) {
      LaTextAtomColor.onSurface => resolved.onSurface,
      LaTextAtomColor.primary => resolved.primary,
      LaTextAtomColor.onPrimary => resolved.onPrimary,
      LaTextAtomColor.secondary => resolved.secondary,
      LaTextAtomColor.onSecondary => resolved.onSecondary,
      LaTextAtomColor.onSecondaryContainer => resolved.onSecondaryContainer,
      LaTextAtomColor.onTertiaryContainer => resolved.onTertiaryContainer,
      LaTextAtomColor.onBackground => resolved.onBackground,
      LaTextAtomColor.onError => resolved.onError,
      LaTextAtomColor.hintText => resolved.hintText,
    };
  }

  LaTextAtomStyle _copyWith({
    LaTextAtomWeight? weight,
    LaTextAtomColor? color,
  }) {
    return LaTextAtomStyle._(
      size: size,
      weight: weight ?? this.weight,
      color: color ?? this.color,
    );
  }
}

final class LaTextAtom extends StatelessWidget {
  final String data;
  final LaTextAtomStyle style;
  final bool container;
  final bool loading;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final String? semanticsLabel;
  final bool? softWrap;

  const LaTextAtom(
    this.data, {
    super.key,
    required this.style,
    this.container = false,
    this.loading = false,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.semanticsLabel,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      data,
      style: style.resolve().copyWith(letterSpacing: letterSpacing),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
    );

    if (container) {
      return Semantics(
        container: true,
        label: semanticsLabel,
        child: ExcludeSemantics(child: text),
      );
    }

    if (loading) {
      return LaLoadingBoxAtom(child: text);
    }
    return text;
  }

  static Widget fromNullableText(
    String? text, {
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    required LaTextAtomStyle style,
  }) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: style.resolve(),
      textAlign: textAlign,
    );
  }
}
