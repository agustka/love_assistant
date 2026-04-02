import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button_atom.dart';

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
        LaButtonAtom.mini(
          icon: Icons.g_mobiledata,
          text: googleText,
          onTap: onGoogleTap,
        ),
        const SizedBox(height: LaPaddings.mediumSmall),
        LaButtonAtom.mini(
          icon: Icons.apple,
          text: appleText,
          onTap: onAppleTap,
        ),
      ],
    );
  }
}
