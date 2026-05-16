import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef SpacedWithIndexedBuilder = Widget Function(int index);

extension SpacedWidgets on Iterable<Widget> {
  List<Widget> spacedWith(Widget spacer) => expand((widget) sync* {
    yield spacer;
    yield widget;
  }).skip(1).toList();

  List<Widget> spaced(double gap) => spacedWith(SizedBox(width: gap, height: gap));

  List<Widget> spacedWithIndexed(SpacedWithIndexedBuilder builder) => expandIndexed((index, widget) sync* {
    yield builder(index);
    yield widget;
  }).skip(1).toList();
}
