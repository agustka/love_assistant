import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button.dart';

class LaAuthProviderButtonsMolecule extends StatelessWidget {
  final String googleText;
  final String appleText;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const LaAuthProviderButtonsMolecule({
    super.key,
    required this.googleText,
    required this.appleText,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LaButton.mini(
          icon: Icons.g_mobiledata,
          text: googleText,
          onTap: onGoogleTap,
        ),
        const SizedBox(height: 12),
        LaButton.mini(
          icon: Icons.apple,
          text: appleText,
          onTap: onAppleTap,
        ),
      ],
    );
  }
}
