import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/organisms/la_scaffold_organism.dart';

enum LaDefaultPageTemplatePadding {
  large,
  medium,
}

class LaDefaultPageTemplate extends StatelessWidget {
  final Widget child;
  final LaAppBarOrganism? appBar;
  final BottomButtonsDefinition? bottomButtons;
  final EdgeInsetsGeometry? padding;
  final LaDefaultPageTemplatePadding paddingPreset;
  final bool centerContent;
  final bool scrollable;

  const LaDefaultPageTemplate({
    super.key,
    required this.child,
    this.appBar,
    this.bottomButtons,
    this.padding,
    this.paddingPreset = LaDefaultPageTemplatePadding.large,
    this.centerContent = false,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return LaGestureDetectorAtom(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LaScaffoldOrganism(
        appBar: appBar,
        bottomButtons: bottomButtons,
        child: LaSafeAreaAtom(
          top: appBar == null,
          child: LaLayoutBuilderAtom(
            builder: (BuildContext context, BoxConstraints constraints) {
              Widget content = LaPaddingAtom(
                padding: padding ?? _resolvedPadding,
                child: child,
              );

              content = centerContent
                  ? LaCenterAtom(child: content)
                  : LaAlignAtom(
                      alignment: Alignment.topCenter,
                      child: content,
                    );

              if (!scrollable) {
                return content;
              }

              return LaSingleChildScrollViewAtom(
                child: LaConstrainedBoxAtom(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: content,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry get _resolvedPadding {
    switch (paddingPreset) {
      case LaDefaultPageTemplatePadding.large:
        return const EdgeInsets.all(LaPadding.large);
      case LaDefaultPageTemplatePadding.medium:
        return const EdgeInsets.symmetric(horizontal: LaPadding.medium, vertical: LaPadding.medium);
    }
  }
}
