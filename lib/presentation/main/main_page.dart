import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/main/widgets/main_under_construction_organism.dart';

class MainPage extends StatelessWidget {
  static const Key pageKey = Key("MainPage_page");

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final S strings = S.of(context);
    return LaDefaultPageTemplate(
      centerContent: true,
      scrollable: false,
      child: MainUnderConstructionOrganism(
        title: strings.main_under_construction_title,
        message: strings.main_under_construction_message,
      ),
    );
  }
}
