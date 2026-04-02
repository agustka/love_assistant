import 'package:flutter/material.dart';

class LaPageViewAtom extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final PageController? controller;
  final ScrollPhysics? physics;
  final void Function(int page)? onPageChanged;

  const LaPageViewAtom({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.physics,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      physics: physics,
      onPageChanged: onPageChanged,
    );
  }
}
