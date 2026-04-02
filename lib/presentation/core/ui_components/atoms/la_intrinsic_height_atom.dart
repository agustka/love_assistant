import 'package:flutter/material.dart';

class LaIntrinsicHeightAtom extends StatelessWidget {
  final Widget child;

  const LaIntrinsicHeightAtom({super.key, required this.child});

  @override
  Widget build(BuildContext context) => IntrinsicHeight(child: child);
}
