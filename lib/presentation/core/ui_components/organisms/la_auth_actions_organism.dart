import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/molecules/la_auth_illustration_molecule.dart';
import 'package:la/presentation/core/ui_components/molecules/la_feature_heading_molecule.dart';
import 'package:la/presentation/core/ui_components/molecules/la_link_prompt_molecule.dart';
import 'package:la/presentation/core/ui_components/organisms/la_email_password_form_organism.dart';

class LaAuthActionsDefinition {
  final String title;
  final String subtitle;
  final String emailHint;
  final String passwordHint;
  final String emailSubmitText;
  final String googleText;
  final String appleText;
  final String prompt;
  final String actionText;
  final void Function(String email, String password) onEmailSubmit;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final VoidCallback onSwitchTap;
  final bool isLoading;
  final String? errorMessage;

  const LaAuthActionsDefinition({
    required this.title,
    required this.subtitle,
    required this.emailHint,
    required this.passwordHint,
    required this.emailSubmitText,
    required this.googleText,
    required this.appleText,
    required this.prompt,
    required this.actionText,
    required this.onEmailSubmit,
    required this.onGoogleTap,
    required this.onAppleTap,
    required this.onSwitchTap,
    this.isLoading = false,
    this.errorMessage,
  });
}

class LaAuthActionsOrganism extends StatelessWidget {
  final LaAuthActionsDefinition definition;

  const LaAuthActionsOrganism({
    super.key,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LaAuthIllustrationMolecule(
          illustration: LaTheme.illustrations.manLove,
          size: LaAuthIllustrationSize.medium,
        ),
        const LaSizedBoxAtom(height: LaPadding.extraLarge),
        LaFeatureHeadingMolecule(
          title: definition.title,
          subtitle: definition.subtitle,
        ),
        const LaSizedBoxAtom(height: LaPadding.huge),
        if (definition.errorMessage case final String errorMessage) ...[
          LaTextAtom(
            errorMessage,
            style: LaTextAtomStyle.body14.onError,
            textAlign: TextAlign.center,
          ),
          const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        ],
        LaEmailPasswordFormOrganism(
          onSubmit: definition.onEmailSubmit,
          emailHint: definition.emailHint,
          passwordHint: definition.passwordHint,
          submitLabel: definition.emailSubmitText,
          loading: definition.isLoading,
        ),
        const LaSizedBoxAtom(height: LaPadding.large),
        LaLinkPromptMolecule(
          prompt: definition.prompt,
          actionText: definition.actionText,
          onTap: definition.onSwitchTap,
        ),
        const LaSizedBoxAtom(height: LaPadding.large),
        const LaPaddingAtom(
          padding: EdgeInsets.symmetric(horizontal: LaPadding.large),
          child: LaDividerAtom(),
        ),
        const LaSizedBoxAtom(height: LaPadding.medium),
        _ProviderButtons(
          googleText: definition.googleText,
          appleText: definition.appleText,
          onGoogleTap: definition.onGoogleTap,
          onAppleTap: definition.onAppleTap,
          isLoading: definition.isLoading,
        ),
      ],
    );
  }
}

class _ProviderButtons extends StatelessWidget {
  final String googleText;
  final String appleText;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final bool isLoading;

  const _ProviderButtons({
    required this.googleText,
    required this.appleText,
    required this.onGoogleTap,
    required this.onAppleTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      children: [
        LaButtonAtom(
          icon: Icons.g_mobiledata,
          text: googleText,
          onTap: onGoogleTap,
          busy: isLoading,
        ),
        const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        LaButtonAtom(
          icon: Icons.apple,
          text: appleText,
          onTap: onAppleTap,
          busy: isLoading,
          buttonStyle: LaButtonStyle.secondary,
        ),
      ],
    );
  }
}
