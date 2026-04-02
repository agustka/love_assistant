import 'package:flutter/material.dart';

class LaAnnotatedRegionAtom<T extends Object> extends AnnotatedRegion<T> {
  const LaAnnotatedRegionAtom({
    super.key,
    required super.value,
    required super.child,
    super.sized = true,
  });
}
