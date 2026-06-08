import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/main/widgets/main_under_construction_organism.dart';

class MainHomeContentOrganism extends StatelessWidget {
  final bool showProfileCompletionCta;
  final String profileCompletionCtaTitle;
  final String profileCompletionCtaMessage;
  final String profileCompletionCtaAction;
  final String profileCompletionCtaDismissSemanticLabel;
  final bool profileCompletionCtaActionInProgress;
  final VoidCallback onProfileCompletionCtaActionTap;
  final VoidCallback onProfileCompletionCtaDismissTap;
  final Key? profileCompletionCtaKey;
  final Key? profileCompletionCtaActionKey;
  final Key? profileCompletionCtaDismissKey;
  final String underConstructionTitle;
  final String underConstructionMessage;

  const MainHomeContentOrganism({
    super.key,
    required this.showProfileCompletionCta,
    required this.profileCompletionCtaTitle,
    required this.profileCompletionCtaMessage,
    required this.profileCompletionCtaAction,
    required this.profileCompletionCtaDismissSemanticLabel,
    required this.profileCompletionCtaActionInProgress,
    required this.onProfileCompletionCtaActionTap,
    required this.onProfileCompletionCtaDismissTap,
    required this.underConstructionTitle,
    required this.underConstructionMessage,
    this.profileCompletionCtaKey,
    this.profileCompletionCtaActionKey,
    this.profileCompletionCtaDismissKey,
  });

  @override
  Widget build(BuildContext context) {
    return LaSeparatedColumnMolecule(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: (BuildContext context, int index) => const LaSizedBoxAtom(height: LaPadding.large),
      children: [
        if (showProfileCompletionCta)
          LaCallToActionTileMolecule(
            key: profileCompletionCtaKey,
            title: profileCompletionCtaTitle,
            message: profileCompletionCtaMessage,
            actionText: profileCompletionCtaAction,
            dismissSemanticLabel: profileCompletionCtaDismissSemanticLabel,
            actionEnabled: !profileCompletionCtaActionInProgress,
            actionBusy: profileCompletionCtaActionInProgress,
            actionKey: profileCompletionCtaActionKey,
            dismissKey: profileCompletionCtaDismissKey,
            onActionTap: onProfileCompletionCtaActionTap,
            onDismissTap: onProfileCompletionCtaDismissTap,
          ),
        MainUnderConstructionOrganism(
          title: underConstructionTitle,
          message: underConstructionMessage,
        ),
      ],
    );
  }
}
