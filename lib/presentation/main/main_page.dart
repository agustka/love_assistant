import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/main/widgets/main_placeholder_organism.dart';

class MainPage extends StatelessWidget {
  static const Key pageKey = Key("MainPage_page");

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LaDefaultPageTemplate(
      key: pageKey,
      centerContent: true,
      scrollable: false,
      child: MainPlaceholderOrganism(
        title: S.of(context).main_title,
      ),
    );
  }
}
