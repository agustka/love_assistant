import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/la_button.dart';
import 'package:la/presentation/core/widgets/atoms/la_text.dart';

class LoginForm extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onSignUp;
  final String? googleButtonText;
  final String? appleButtonText;
  final String? signUpText;
  final String? signUpButtonText;

  const LoginForm({
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
            child: LaText(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        },
        if (onGoogleLogin != null) ...{
          LaButton.mini(
            icon: Icons.g_mobiledata,
            text: googleButtonText,
            onTap: onGoogleLogin!,
          ),
          const SizedBox(height: 12),
        },
        if (onAppleLogin != null) ...{
          LaButton.mini(
            icon: Icons.apple,
            text: appleButtonText,
            onTap: onAppleLogin!,
          ),
          const SizedBox(height: 24),
        },
        if (onSignUp != null) ...{
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (signUpText != null) ...{
                LaText(
                  signUpText!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 4),
              },
              TextButton(
                onPressed: onSignUp,
                child: LaText(
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
