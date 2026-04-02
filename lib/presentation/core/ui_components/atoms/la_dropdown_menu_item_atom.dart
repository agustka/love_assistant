import 'package:flutter/material.dart';

class LaDropdownMenuItemAtom<T> extends DropdownMenuItem<T> {
  const LaDropdownMenuItemAtom({
    super.key,
    super.onTap,
    super.enabled = true,
    super.alignment = AlignmentDirectional.centerStart,
    required super.value,
    required super.child,
  });
}
