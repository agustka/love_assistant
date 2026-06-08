import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/main/main_cubit.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/main/widgets/main_home_content_organism.dart';
import 'package:la/setup.dart';

class MainPage extends StatelessWidget {
  static const Key profileCompletionCtaKey = Key("MainPage_profileCompletionCta");
  static const Key profileCompletionCtaActionKey = Key("MainPage_profileCompletionCtaAction");
  static const Key profileCompletionCtaDismissKey = Key("MainPage_profileCompletionCtaDismiss");

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (BuildContext context) => getIt<MainCubit>()..init(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (BuildContext context, MainState state) {
          return _MainPageEventListener(
            onOpenDetailedProfileWizard: () => _onOpenDetailedProfileWizard(context),
            onDetailedProfileCompleted: (UserPartnerProfile profile) => _onDetailedProfileCompleted(context),
            child: _buildTemplate(context, state),
          );
        },
      ),
    );
  }

  Widget _buildTemplate(BuildContext context, MainState state) {
    final S strings = S.of(context);
    return LaDefaultPageTemplate(
      child: MainHomeContentOrganism(
        showProfileCompletionCta: state.showProfileCompletionCta,
        profileCompletionCtaTitle: strings.main_profile_completion_cta_title,
        profileCompletionCtaMessage: strings.main_profile_completion_cta_message,
        profileCompletionCtaAction: strings.main_profile_completion_cta_action,
        profileCompletionCtaDismissSemanticLabel: strings.main_profile_completion_cta_dismiss_semantic_label,
        profileCompletionCtaActionInProgress: state.profileCtaActionInProgress,
        profileCompletionCtaKey: profileCompletionCtaKey,
        profileCompletionCtaActionKey: profileCompletionCtaActionKey,
        profileCompletionCtaDismissKey: profileCompletionCtaDismissKey,
        onProfileCompletionCtaActionTap: context.read<MainCubit>().onProfileCtaActionTap,
        onProfileCompletionCtaDismissTap: context.read<MainCubit>().onProfileCtaDismissTap,
        underConstructionTitle: strings.main_under_construction_title,
        underConstructionMessage: strings.main_under_construction_message,
      ),
    );
  }

  Future<void> _onOpenDetailedProfileWizard(BuildContext context) async {
    final MainCubit cubit = context.read<MainCubit>();
    try {
      await Navigator.of(context).pushNamed(PageName.wizard.route);
    } finally {
      if (context.mounted) {
        cubit.onProfileCtaActionSettled();
        await cubit.init();
      }
    }
  }

  Future<void> _onDetailedProfileCompleted(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    await context.read<MainCubit>().init();
  }
}

class _MainPageEventListener extends StatelessWidget {
  final Future<void> Function() onOpenDetailedProfileWizard;
  final Future<void> Function(UserPartnerProfile profile) onDetailedProfileCompleted;
  final Widget child;

  const _MainPageEventListener({
    required this.onOpenDetailedProfileWizard,
    required this.onDetailedProfileCompleted,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LaMultiEventBusListener(
      listeners: [
        LaTypedEventBusListenerDefinition<MainOpenDetailedProfileWizardEvent>(
          onMessage: (_) => onOpenDetailedProfileWizard(),
        ),
        LaTypedEventBusListenerDefinition<WizardDetailedProfileCompletedEvent>(
          onMessage: (WizardDetailedProfileCompletedEvent event) => onDetailedProfileCompleted(event.profile),
        ),
      ],
      child: child,
    );
  }
}
