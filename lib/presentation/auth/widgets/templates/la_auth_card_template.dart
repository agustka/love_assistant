import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_card_atom.dart';
import 'package:la/presentation/core/ui_components/atoms/la_center_atom.dart';

class LaAuthCardTemplate extends StatelessWidget {
  final Widget child;

  const LaAuthCardTemplate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaCenterAtom(
         child: LaCardAtom(
           child: Padding(
             padding: const EdgeInsets.all(LaPaddings.large),
             child: child,
           ),
         ),
      ),
    );
  }
}
