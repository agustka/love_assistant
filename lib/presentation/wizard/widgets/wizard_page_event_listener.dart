part of "../wizard_page.dart";

class _WizardPageEventListener extends StatelessWidget {
  final PageController pageController;
  final Future<void> Function(WizardEvent event) onWizardMessage;
  final Future<void> Function(UserPartnerProfile profile) onInitialSetupCompleted;
  final Future<void> Function(UserPartnerProfile profile) onDetailedProfileCompleted;
  final Widget child;

  const _WizardPageEventListener({
    required this.pageController,
    required this.onWizardMessage,
    required this.onInitialSetupCompleted,
    required this.onDetailedProfileCompleted,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LaMultiEventBusListener(
      listeners: [
        LaTypedEventBusListenerDefinition<WizardEventGoToPage>(
          onMessage: (WizardEventGoToPage event) {
            pageController.animateToPage(
              event.page,
              duration: 300.milliseconds,
              curve: Curves.easeInOut,
            );
          },
        ),
        LaTypedEventBusListenerDefinition<WizardEvent>(onMessage: onWizardMessage),
        LaTypedEventBusListenerDefinition<WizardInitialSetupCompletedEvent>(
          onMessage: (WizardInitialSetupCompletedEvent event) => onInitialSetupCompleted(event.profile),
        ),
        LaTypedEventBusListenerDefinition<WizardDetailedProfileCompletedEvent>(
          onMessage: (WizardDetailedProfileCompletedEvent event) => onDetailedProfileCompleted(event.profile),
        ),
      ],
      child: child,
    );
  }
}
