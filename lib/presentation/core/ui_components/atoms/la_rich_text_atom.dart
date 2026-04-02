import 'package:flutter/material.dart';

class LaRichTextAtom extends StatelessWidget {
  final InlineSpan text;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final bool softWrap;

  const LaRichTextAtom({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
