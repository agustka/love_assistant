import 'package:flutter/material.dart';

class LaIgnorePointerAtom extends StatelessWidget {
  final Widget? child;
  final bool ignoring;

  const LaIgnorePointerAtom({
    super.key,
    this.child,
    this.ignoring = true,
  });

  @override
  Widget build(BuildContext context) => IgnorePointer(ignoring: ignoring, child: child);
}
