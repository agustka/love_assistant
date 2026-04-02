import 'package:flutter/material.dart';

class LaDropdownButtonAtom<T> extends DropdownButton<T> {
  LaDropdownButtonAtom({
    super.key,
    super.value,
    super.hint,
    super.underline,
    super.icon,
    super.iconSize,
    super.isDense,
    super.isExpanded = false,
    super.elevation,
    super.style,
    super.borderRadius,
    required super.items,
    required super.onChanged,
  });
}
