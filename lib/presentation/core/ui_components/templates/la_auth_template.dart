import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

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
    return LaScaffoldAtom(
      body: LaCenterAtom(
        child: LaConstrainedBoxAtom(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: LaSingleChildScrollViewAtom(
            child: LaCardAtom(
              child: LaPaddingAtom.all(
                value: LaPadding.large,
                child: LaColumnAtom(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LaTextAtom(
                      title,
                      style: LaTextAtomStyle.body24.bold,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...{
                      const LaSizedBoxAtom(height: LaPadding.small),
                      LaTextAtom(
                        subtitle!,
                        style: LaTextAtomStyle.body16.light,
                        textAlign: TextAlign.center,
                      ),
                    },
                    const LaSizedBoxAtom(height: LaPadding.extraLarge),
                    child,
                    if (footer != null) ...{
                      const LaSizedBoxAtom(height: LaPadding.large),
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
