import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LoginFormOrganism extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onSignUp;
  final String? googleButtonText;
  final String? appleButtonText;
  final String? signUpText;
  final String? signUpButtonText;

  const LoginFormOrganism({
    super.key,
    this.isLoading = false,
    this.errorMessage,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.onSignUp,
    this.googleButtonText = 'Sign in with Google',
    this.appleButtonText = 'Sign in with Apple',
    this.signUpText = "Don't have an account?",
    this.signUpButtonText = 'Sign up',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LaCenterAtom(child: LaCircularProgressAtom());
    }

    return LaColumnAtom(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage != null) ...{
          LaPaddingAtom(
            padding: const EdgeInsets.only(bottom: LaPadding.medium),
            child: LaTextAtom(
              errorMessage!,
              style: LaTextAtomStyle.body14.onError,
              textAlign: TextAlign.center,
            ),
          ),
        },
        if (onGoogleLogin != null) ...{
          LaButtonAtom.mini(
            icon: Icons.g_mobiledata,
            text: googleButtonText,
            onTap: onGoogleLogin!,
          ),
          const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        },
        if (onAppleLogin != null) ...{
          LaButtonAtom.mini(
            icon: Icons.apple,
            text: appleButtonText,
            onTap: onAppleLogin!,
          ),
          const LaSizedBoxAtom(height: LaPadding.large),
        },
        if (onSignUp != null) ...{
          LaRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (signUpText != null) ...{
                LaTextAtom(
                  signUpText!,
                  style: LaTextAtomStyle.body16.onSurface,
                ),
                const LaSizedBoxAtom(width: LaPadding.extraSmall),
              },
              LaTapVisualAtom(
                onTap: onSignUp,
                child: LaTextAtom(
                  signUpButtonText!,
                  style: LaTextAtomStyle.body16.bold.primary,
                ),
              ),
            ],
          ),
        },
      ],
    );
  }
}
