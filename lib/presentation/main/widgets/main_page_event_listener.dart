part of "../main_page.dart";

class _MainPageEventListener extends StatefulWidget {
  final Future<void> Function() onOpenDetailedProfileWizard;
  final Widget child;

  const _MainPageEventListener({
    required this.onOpenDetailedProfileWizard,
    required this.child,
  });

  @override
  State<_MainPageEventListener> createState() => _MainPageEventListenerState();
}

class _MainPageEventListenerState extends State<_MainPageEventListener> {
  bool _detailedProfileWizardOpening = false;

  @override
  Widget build(BuildContext context) {
    return LaMultiEventBusListener(
      listeners: [
        LaTypedEventBusListenerDefinition<MainOpenDetailedProfileWizardEvent>(
          onMessage: (_) => _openDetailedProfileWizard(),
        ),
      ],
      child: widget.child,
    );
  }

  Future<void> _openDetailedProfileWizard() async {
    if (_detailedProfileWizardOpening) {
      return;
    }

    _detailedProfileWizardOpening = true;
    try {
      await widget.onOpenDetailedProfileWizard();
    } finally {
      _detailedProfileWizardOpening = false;
    }
  }
}
