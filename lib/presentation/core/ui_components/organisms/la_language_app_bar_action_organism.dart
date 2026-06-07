import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/definitions/la_language_app_bar_action_definition.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';

class LaLanguageAppBarActionOrganism extends StatelessWidget {
  static const Key actionKey = LaLanguageAppBarActionDefinition.actionKey;

  final AppBarStyle style;

  const LaLanguageAppBarActionOrganism({
    super.key,
    this.style = AppBarStyle.background,
  });

  @override
  Widget build(BuildContext context) {
    return LaLanguageAppBarActionDefinition(context).toWidget(style: style);
  }
}
