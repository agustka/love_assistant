import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/la_auth_illustration_molecule.dart';
import 'package:la/presentation/core/ui_components/molecules/la_feature_heading_molecule.dart';
import 'package:la/presentation/core/ui_components/molecules/la_link_prompt_molecule.dart';

class LandingReassurance {
  final IconData icon;
  final String text;

  const LandingReassurance({required this.icon, required this.text});
}

class LandingDefinition {
  final String title;
  final String subtitle;
  final List<LandingReassurance> reassurances;
  final String loginPrompt;
  final String loginAction;
  final Key loginPromptKey;
  final Key loginActionKey;
  final VoidCallback onLogin;

  const LandingDefinition({
    required this.title,
    required this.subtitle,
    required this.reassurances,
    required this.loginPrompt,
    required this.loginAction,
    required this.loginPromptKey,
    required this.loginActionKey,
    required this.onLogin,
  });
}

class LandingActionsOrganism extends StatelessWidget {
  final LandingDefinition definition;

  const LandingActionsOrganism({
    super.key,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Placeholder illustration until the dedicated landing art is ready.
        // Decorative: kept out of the semantics tree so screen readers jump
        // straight to the heading.
        LaExcludeSemanticsAtom(
          child: LaAuthIllustrationMolecule(
            illustration: LaTheme.illustrations.manLove,
            size: LaAuthIllustrationSize.medium,
          ),
        ),
        const LaSizedBoxAtom(height: LaPadding.large),
        LaFeatureHeadingMolecule(
          title: definition.title,
          subtitle: definition.subtitle,
        ),
        const LaSizedBoxAtom(height: LaPadding.mediumSmall),
        LaLinkPromptMolecule(
          promptKey: definition.loginPromptKey,
          actionKey: definition.loginActionKey,
          prompt: definition.loginPrompt,
          actionText: definition.loginAction,
          onTap: definition.onLogin,
        ),
        const LaSizedBoxAtom(height: LaPadding.medium),
        _ReassurancePanel(reassurances: definition.reassurances),
      ],
    );
  }
}

class _ReassurancePanel extends StatelessWidget {
  final List<LandingReassurance> reassurances;

  const _ReassurancePanel({required this.reassurances});

  @override
  Widget build(BuildContext context) {
    return LaContainerAtom(
      padding: const EdgeInsets.all(LaPadding.medium),
      decoration: BoxDecoration(
        color: LaTheme.secondaryContainer(),
        borderRadius: BorderRadius.circular(LaCornerRadius.large),
      ),
      child: LaColumnAtom(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: LaPadding.mediumSmall,
        children: reassurances.map(_ReassurancePoint.new).toList(),
      ),
    );
  }
}

class _ReassurancePoint extends StatelessWidget {
  final LandingReassurance reassurance;

  const _ReassurancePoint(this.reassurance);

  @override
  Widget build(BuildContext context) {
    return LaRow(
      spacing: LaPadding.mediumSmall,
      children: [
        LaExcludeSemanticsAtom(
          child: LaIconAtom(
            reassurance.icon,
            size: LaSize.medium,
            color: LaTheme.primary(),
          ),
        ),
        LaExpandedAtom(
          child: LaTextAtom(
            reassurance.text,
            style: LaTextAtomStyle.body16.onSurface,
          ),
        ),
      ],
    );
  }
}
