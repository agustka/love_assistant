import 'package:flutter/material.dart';

class LaGestureDetectorAtom extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final HitTestBehavior? behavior;

  const LaGestureDetectorAtom({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: behavior,
      child: child,
    );
  }
}
