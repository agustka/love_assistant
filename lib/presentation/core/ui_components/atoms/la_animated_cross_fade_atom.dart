import 'package:flutter/material.dart';

class LaAnimatedCrossFadeAtom extends AnimatedCrossFade {
  const LaAnimatedCrossFadeAtom({
    super.key,
    required super.firstChild,
    required super.secondChild,
    required super.crossFadeState,
    required super.duration,
    super.reverseDuration,
    super.firstCurve = Curves.linear,
    super.secondCurve = Curves.linear,
    super.sizeCurve = Curves.linear,
    super.alignment = Alignment.topCenter,
  });
}
