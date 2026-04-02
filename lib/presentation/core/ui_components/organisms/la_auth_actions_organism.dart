import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
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
        const _AuthIllustration(),
        const LaSizedBoxAtom(height: LaPadding.extraLarge),
        _AuthHeader(
          title: definition.title,
          subtitle: definition.subtitle,
        ),
        const LaSizedBoxAtom(height: LaPadding.extraHuge),
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
        const LaDividerAtom(),
        const LaSizedBoxAtom(height: LaPadding.large),
        _ProviderButtons(
          googleText: definition.googleText,
          appleText: definition.appleText,
          onGoogleTap: definition.onGoogleTap,
          onAppleTap: definition.onAppleTap,
          isLoading: definition.isLoading,
        ),
        const LaSizedBoxAtom(height: LaPadding.large),
        _SwitchModeButton(
          prompt: definition.prompt,
          actionText: definition.actionText,
          onTap: definition.onSwitchTap,
        ),
      ],
    );
  }
}

class _AuthIllustration extends StatelessWidget {
  const _AuthIllustration();

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.sizeOf(context).width * 0.60;
    return LaCenterAtom(
      child: LaImageAtom(
        imageLink: LaTheme.illustrations.manLove,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AuthHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      mainAxisSize: MainAxisSize.min,
      children: [
        LaTextAtom(
          title,
          style: LaTextAtomStyle.body28.bold,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.small),
        LaTextAtom(
          subtitle,
          style: LaTextAtomStyle.body16.light.hintText,
          textAlign: TextAlign.center,
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

class _SwitchModeButton extends StatelessWidget {
  final String prompt;
  final String actionText;
  final VoidCallback onTap;

  const _SwitchModeButton({
    required this.prompt,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LaTapVisualAtom(
      onTap: onTap,
      child: LaRichTextAtom(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "$prompt ",
          style: LaTheme.font.body16,
          children: <InlineSpan>[
            TextSpan(
              text: actionText,
              style: LaTheme.font.body16.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
