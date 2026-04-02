import 'package:flutter/material.dart';

class LaSafeAreaAtom extends SafeArea {
  const LaSafeAreaAtom({
    super.key,
    super.left = true,
    super.top = true,
    super.right = true,
    super.bottom = true,
    super.minimum = EdgeInsets.zero,
    super.maintainBottomViewPadding = false,
    required super.child,
  });
}
