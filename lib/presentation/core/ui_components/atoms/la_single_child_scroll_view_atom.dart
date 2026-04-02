import 'package:flutter/material.dart';

class LaSingleChildScrollViewAtom extends SingleChildScrollView {
  const LaSingleChildScrollViewAtom({
    super.key,
    super.scrollDirection = Axis.vertical,
    super.reverse = false,
    super.padding,
    super.physics,
    super.controller,
    super.child,
    super.clipBehavior = Clip.hardEdge,
  });
}
