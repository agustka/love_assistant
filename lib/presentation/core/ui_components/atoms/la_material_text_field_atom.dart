import 'package:flutter/material.dart';

class LaMaterialTextFieldAtom extends TextField {
  const LaMaterialTextFieldAtom({
    super.key,
    super.controller,
    super.focusNode,
    super.decoration,
    super.keyboardType,
    super.style,
    super.cursorColor,
    super.maxLength,
    super.enabled = true,
    super.obscureText = false,
    super.onChanged,
    super.textCapitalization = TextCapitalization.none,
  });
}
