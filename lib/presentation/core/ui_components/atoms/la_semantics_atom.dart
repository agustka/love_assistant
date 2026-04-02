import 'package:flutter/material.dart';

class LaSemanticsAtom extends Semantics {
  LaSemanticsAtom({
    super.key,
    super.label,
    super.hint,
    super.child,
    super.enabled,
    super.button,
    super.header,
    super.excludeSemantics = false,
  });
}
