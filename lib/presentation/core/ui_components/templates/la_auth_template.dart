import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/organisms/la_scaffold_organism.dart';

class LaAuthTemplate extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final Widget? footer;
  final double? maxWidth;
  final LaAppBarOrganism? appBar;
  final BottomButtonsDefinition? bottomButtons;

  const LaAuthTemplate({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.footer,
    this.maxWidth = 400,
    this.appBar,
    this.bottomButtons,
  });

  @override
  Widget build(BuildContext context) {
    return LaGestureDetectorAtom(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LaScaffoldOrganism(
        appBar: appBar,
        bottomButtons: bottomButtons,
        child: LaCenterAtom(
          child: LaConstrainedBoxAtom(
            constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
            child: LaSingleChildScrollViewAtom(
              child: LaPaddingAtom(
                padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
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
        ),
      ),
    );
  }
}
