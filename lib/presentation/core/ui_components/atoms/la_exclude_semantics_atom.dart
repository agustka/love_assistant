import 'package:flutter/material.dart';

class LaExcludeSemanticsAtom extends StatelessWidget {
  final Widget child;
  final bool excluding;

  const LaExcludeSemanticsAtom({
    super.key,
    required this.child,
    this.excluding = true,
  });

  @override
  Widget build(BuildContext context) => ExcludeSemantics(excluding: excluding, child: child);
}
