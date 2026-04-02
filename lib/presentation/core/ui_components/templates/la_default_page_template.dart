import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_scaffold_organism.dart';

class LaDefaultPageTemplate extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showBack;
  final AppBarActionDefinition? appBarAction;
  final EdgeInsetsGeometry padding;
  final bool centerContent;
  final bool scrollable;

  const LaDefaultPageTemplate({
    super.key,
    required this.child,
    this.title,
    this.showBack = false,
    this.appBarAction,
    this.padding = const EdgeInsets.all(LaPadding.large),
    this.centerContent = false,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAppBar = title != null || showBack || appBarAction != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LaScaffoldOrganism(
        appBar: hasAppBar
            ? LaAppBarOrganism(
                title: title,
                showBack: showBack,
                action: appBarAction,
                style: AppBarStyle.background,
              )
            : null,
        child: SafeArea(
          top: !hasAppBar,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Widget content = Padding(
                padding: padding,
                child: child,
              );

              content = centerContent
                  ? Center(child: content)
                  : Align(
                      alignment: Alignment.topCenter,
                      child: content,
                    );

              if (!scrollable) {
                return content;
              }

              return SingleChildScrollView(
                child: ConstrainedBox(
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
