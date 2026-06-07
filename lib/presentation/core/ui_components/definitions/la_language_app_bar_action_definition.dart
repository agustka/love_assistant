import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';

final class LaLanguageAppBarActionDefinition extends AppBarActionDefinition {
  static const Key actionKey = Key("la_language_app_bar_action");

  LaLanguageAppBarActionDefinition({
    required super.onTap,
    super.showsIcon = true,
  }) : super(
         key: actionKey,
         icon: LaIcons.language,
       );
}
