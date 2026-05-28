import 'package:flutter/material.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/molecules/la_bottom_buttons_molecule.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/landing/widgets/landing_actions_organism.dart';

class LandingPage extends StatelessWidget {
  static const Key pageKey = Key("LandingPage_page");

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserPartnerProfile? partnerProfile =
        ModalRoute.of(context)?.settings.arguments as UserPartnerProfile?;

    return _LandingView(partnerProfile: partnerProfile);
  }
}

class _LandingView extends StatelessWidget {
  final UserPartnerProfile? partnerProfile;

  const _LandingView({required this.partnerProfile});

  @override
  Widget build(BuildContext context) {
    return LaDefaultPageTemplate(
      key: LandingPage.pageKey,
      centerContent: true,
      bottomButtons: _bottomButtons(context),
      child: LandingActionsOrganism(
        definition: _definition(context),
      ),
    );
  }

  LandingDefinition _definition(BuildContext context) {
    final S strings = S.of(context);
    return LandingDefinition(
      title: _title(strings),
      subtitle: strings.landing_subtitle,
      reassurances: [
        LandingReassurance(
          icon: Icons.check_circle_outline,
          text: strings.landing_reassurance_saved,
        ),
        LandingReassurance(
          icon: Icons.lock_open_outlined,
          text: strings.landing_reassurance_signup_free,
        ),
        LandingReassurance(
          icon: Icons.calendar_today_outlined,
          text: strings.landing_reassurance_trial,
        ),
      ],
    );
  }

  BottomButtonsDefinition _bottomButtons(BuildContext context) {
    final S strings = S.of(context);
    return BottomButtonsDefinition(
      type: BottomButtonsStyle.sandwich,
      buttons: [
        BottomButtonDefinition(
          text: strings.auth_login_signup_action,
          onTap: () => Navigator.of(context).pushNamed(PageName.signUp.route),
        ),
        BottomButtonDefinition(
          text: strings.auth_signup_login_action,
          onTap: () {},
        ),
      ],
    );
  }

  String _title(S strings) {
    final UserPartnerProfile? profile = partnerProfile;
    if (profile != null && profile.valid && profile.partnerName.isNotEmpty) {
      return strings.landing_title_named(profile.partnerName);
    }
    return strings.landing_title;
  }
}
