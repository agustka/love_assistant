import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/organisms/la_scaffold_organism.dart';

class LaDefaultPageTemplate extends StatelessWidget {
  final Widget child;
  final LaAppBarOrganism? appBar;
  final EdgeInsetsGeometry padding;
  final bool centerContent;
  final bool scrollable;

  const LaDefaultPageTemplate({
    super.key,
    required this.child,
    this.appBar,
    this.padding = const EdgeInsets.all(LaPadding.large),
    this.centerContent = false,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return LaGestureDetectorAtom(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LaScaffoldOrganism(
        appBar: appBar,
        child: LaSafeAreaAtom(
          top: appBar == null,
          child: LaLayoutBuilderAtom(
            builder: (BuildContext context, BoxConstraints constraints) {
              Widget content = LaPaddingAtom(
                padding: padding,
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
}
