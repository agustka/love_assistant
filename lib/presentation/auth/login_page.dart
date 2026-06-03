import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/main/widgets/main_under_construction_organism.dart';

class LoginPage extends StatelessWidget {
  static const Key pageKey = Key("LoginPage_page");
  static const Key underConstructionKey = Key("LoginPage_underConstruction");

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final S strings = S.of(context);
    return LaDefaultPageTemplate(
      key: pageKey,
      appBar: const LaAppBarOrganism(
        style: AppBarStyle.background,
      ),
      centerContent: true,
      scrollable: false,
      child: MainUnderConstructionOrganism(
        key: underConstructionKey,
        title: strings.auth_login_under_construction_title,
        message: strings.auth_login_under_construction_message,
      ),
    );
  }
}
