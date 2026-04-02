import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaAuthActionsDefinition {
  final String title;
  final String subtitle;
  final String googleText;
  final String appleText;
  final String prompt;
  final String actionText;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final VoidCallback onSwitchTap;
  final bool isLoading;
  final String? errorMessage;

  const LaAuthActionsDefinition({
    required this.title,
    required this.subtitle,
    required this.googleText,
    required this.appleText,
    required this.prompt,
    required this.actionText,
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
    return LaCardAtom(
      child: LaPaddingAtom.all(
        value: LaPadding.large,
        child: LaColumnAtom(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AuthHeader(
              title: definition.title,
              subtitle: definition.subtitle,
            ),
            const LaSizedBoxAtom(height: LaPadding.large),
            if (definition.errorMessage case final String errorMessage) ...[
              LaTextAtom(
                errorMessage,
                style: LaTextAtomStyle.body14.onError,
                textAlign: TextAlign.center,
              ),
              const LaSizedBoxAtom(height: LaPadding.mediumSmall),
            ],
            if (definition.isLoading)
              const LaCenterAtom(child: LaCircularProgressAtom())
            else ...[
              _ProviderButtons(
                googleText: definition.googleText,
                appleText: definition.appleText,
                onGoogleTap: definition.onGoogleTap,
                onAppleTap: definition.onAppleTap,
              ),
              const LaSizedBoxAtom(height: LaPadding.large),
              _SwitchModeButton(
                prompt: definition.prompt,
                actionText: definition.actionText,
                onTap: definition.onSwitchTap,
              ),
            ],
          ],
        ),
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
          style: LaTextAtomStyle.body24.bold,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.small),
        LaTextAtom(
          subtitle,
          style: LaTextAtomStyle.body16.light,
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

  const _ProviderButtons({
    required this.googleText,
    required this.appleText,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      children: [
        LaButtonAtom.mini(
          icon: Icons.g_mobiledata,
          text: googleText,
          onTap: onGoogleTap,
        ),
        const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        LaButtonAtom.mini(
          icon: Icons.apple,
          text: appleText,
          onTap: onAppleTap,
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
