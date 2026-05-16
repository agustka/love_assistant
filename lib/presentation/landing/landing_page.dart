import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/landing/widgets/landing_actions_organism.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LaDefaultPageTemplate(
      centerContent: true,
      scrollable: false,
      child: LandingActionsOrganism(
        title: S.of(context).landing_title,
        subtitle: S.of(context).landing_subtitle,
        signupText: S.of(context).auth_login_signup_action,
        loginText: S.of(context).auth_signup_login_action,
        onSignupTap: () {

        },
        onLoginTap: () {

        },
      ),
    );
  }
}
