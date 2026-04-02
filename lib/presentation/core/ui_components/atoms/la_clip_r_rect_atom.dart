import 'package:flutter/material.dart';

class LaClipRRectAtom extends ClipRRect {
  const LaClipRRectAtom({
    super.key,
    super.borderRadius = BorderRadius.zero,
    super.clipBehavior = Clip.antiAlias,
    super.child,
  });
}
