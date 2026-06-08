import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/dismissible_content/dismissible_content_local_cubit.dart';
import 'package:la/application/main/main_cubit.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/presentation/main/widgets/main_home_content_organism.dart';
import 'package:la/setup.dart';

class MainPage extends StatelessWidget {
  static const Key profileCompletionCtaKey = Key("MainPage_profileCompletionCta");
  static const Key profileCompletionCtaActionKey = Key("MainPage_profileCompletionCtaAction");
  static const Key profileCompletionCtaDismissKey = Key("MainPage_profileCompletionCtaDismiss");
  static const DismissibleContentKey profileCompletionCtaDismissibleContentKey =
      DismissibleContentKey.completePartnerProfileCta;
  static const List<DismissibleContentKey> _trackedDismissibleContentKeys = [
    profileCompletionCtaDismissibleContentKey,
  ];

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(
          create: (BuildContext context) => getIt<MainCubit>()..init(),
        ),
        BlocProvider<DismissibleContentLocalCubit>(
          create: (BuildContext context) => getIt<DismissibleContentLocalCubit>()..init(_trackedDismissibleContentKeys),
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (BuildContext context, MainState mainState) {
          return BlocBuilder<DismissibleContentLocalCubit, DismissibleContentLocalState>(
            builder: (BuildContext context, DismissibleContentLocalState dismissibleContentState) {
              return _MainPageEventListener(
                onOpenDetailedProfileWizard: () => _onOpenDetailedProfileWizard(context),
                child: _buildTemplate(context, mainState, dismissibleContentState),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTemplate(
    BuildContext context,
    MainState mainState,
    DismissibleContentLocalState dismissibleContentState,
  ) {
    final S strings = S.of(context);
    final bool showProfileCompletionCta =
        mainState.status == MainStatus.loaded &&
        mainState.partnerProfile.incomplete &&
        !dismissibleContentState.isDismissed(profileCompletionCtaDismissibleContentKey);

    return LaDefaultPageTemplate(
      child: MainHomeContentOrganism(
        showProfileCompletionCta: showProfileCompletionCta,
        profileCompletionCtaTitle: strings.main_profile_completion_cta_title,
        profileCompletionCtaMessage: strings.main_profile_completion_cta_message,
        profileCompletionCtaAction: strings.main_profile_completion_cta_action,
        profileCompletionCtaDismissSemanticLabel: strings.main_profile_completion_cta_dismiss_semantic_label,
        profileCompletionCtaActionInProgress: mainState.profileCtaActionInProgress,
        profileCompletionCtaKey: profileCompletionCtaKey,
        profileCompletionCtaActionKey: profileCompletionCtaActionKey,
        profileCompletionCtaDismissKey: profileCompletionCtaDismissKey,
        onProfileCompletionCtaActionTap: context.read<MainCubit>().onProfileCtaActionTap,
        onProfileCompletionCtaDismissTap: () {
          context.read<DismissibleContentLocalCubit>().dismiss(profileCompletionCtaDismissibleContentKey);
        },
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
      }
    }
  }
}

class _MainPageEventListener extends StatelessWidget {
  final Future<void> Function() onOpenDetailedProfileWizard;
  final Widget child;

  const _MainPageEventListener({
    required this.onOpenDetailedProfileWizard,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LaMultiEventBusListener(
      listeners: [
        LaTypedEventBusListenerDefinition<MainOpenDetailedProfileWizardEvent>(
          onMessage: (_) => onOpenDetailedProfileWizard(),
        ),
      ],
      child: child,
    );
  }
}
