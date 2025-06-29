import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';

final class LaText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final bool container;
  final bool loading;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final String? semanticsLabel;
  final bool? softWrap;

  const LaText(
    this.data, {
    super.key,
    required this.style,
    this.container = false,
    this.loading = false,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.letterSpacing,
    this.semanticsLabel,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      data,
      style: style.copyWith(color: color),
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
      return LaLoadingBox(child: text);
    }
    return text;
  }

  static Widget fromNullableText(
    String? text, {
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    required TextStyle style,
  }) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
      textAlign: textAlign,
    );
  }
}
