import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_card_atom.dart';
import 'package:la/presentation/core/ui_components/atoms/la_center_atom.dart';

class LaAuthTemplate extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final Widget? footer;
  final double? maxWidth;

  const LaAuthTemplate({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.footer,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaCenterAtom(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: SingleChildScrollView(
             child: LaCardAtom(
               child: Padding(
                 padding: const EdgeInsets.all(LaPaddings.large),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Text(
                       title,
                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                         fontWeight: FontWeight.bold,
                       ),
                       textAlign: TextAlign.center,
                     ),
                     if (subtitle != null) ...{
                       const SizedBox(height: LaPaddings.small),
                       Text(
                         subtitle!,
                         style: Theme.of(context).textTheme.bodyMedium,
                         textAlign: TextAlign.center,
                       ),
                     },
                     const SizedBox(height: LaPaddings.extraLarge),
                     child,
                     if (footer != null) ...{
                       const SizedBox(height: LaPaddings.large),
                       footer!,
                     },
                   ],
                 ),
               ),
             ),
          ),
        ),
      ),
    );
  }
}
