import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button_atom.dart';
import 'package:la/presentation/core/ui_components/atoms/la_text_atom.dart';

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
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage != null) ...{
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: LaTextAtom(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
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
           const SizedBox(height: LaPaddings.mediumSmall),
         },
         if (onAppleLogin != null) ...{
           LaButtonAtom.mini(
             icon: Icons.apple,
             text: appleButtonText,
             onTap: onAppleLogin!,
           ),
           const SizedBox(height: LaPaddings.large),
         },
         if (onSignUp != null) ...{
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               if (signUpText != null) ...{
                 LaTextAtom(
                   signUpText!,
                   style: Theme.of(context).textTheme.bodyMedium,
                 ),
                 const SizedBox(width: LaPaddings.extraSmall),
               },
              TextButton(
                onPressed: onSignUp,
                child: LaTextAtom(
                  signUpButtonText!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        },
      ],
    );
  }
}
