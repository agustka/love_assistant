import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LandingActionsOrganism extends StatelessWidget {
  final String title;
  final String subtitle;
  final String signupText;
  final String loginText;
  final VoidCallback onSignupTap;
  final VoidCallback onLoginTap;

  const LandingActionsOrganism({
    super.key,
    required this.title,
    required this.subtitle,
    required this.signupText,
    required this.loginText,
    required this.onSignupTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LaTextAtom(
          title,
          style: LaTextAtomStyle.body28.bold.onSurface,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.medium),
        LaTextAtom(
          subtitle,
          style: LaTextAtomStyle.body16.onSurface,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.extraLarge),
        LaButtonAtom(
          onTap: onSignupTap,
          text: signupText,
        ),
        const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        LaButtonAtom(
          onTap: onLoginTap,
          text: loginText,
          buttonStyle: LaButtonStyle.secondary,
        ),
      ],
    );
  }
}
