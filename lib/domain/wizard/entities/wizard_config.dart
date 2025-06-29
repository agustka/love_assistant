enum WizardMode {
  initial,
  detailed;

  bool get isInitial => this == WizardMode.initial;
  bool get isDetailed => this == WizardMode.detailed;
}

enum WizardStepType {
  greetings,
  basicInfo,
  dates,
  preferences,
  hobbies,
  anniversary,
}

class WizardStep {
  final int index;
  final WizardStepType type;
  final bool required;
  final bool visibleInInitial;
  final bool visibleInDetailed;

  const WizardStep({
    required this.index,
    required this.type,
    required this.required,
    required this.visibleInInitial,
    required this.visibleInDetailed,
  });

  bool isVisibleInMode(WizardMode mode) {
    switch (mode) {
      case WizardMode.initial:
        return visibleInInitial;
      case WizardMode.detailed:
        return visibleInDetailed;
    }
  }
}

class WizardConfig {
  final List<WizardStep> steps;
  final WizardMode mode;

  const WizardConfig({
    required this.mode,
    required this.steps,
  });

  List<WizardStep> get visibleSteps =>
      steps.where((step) => step.isVisibleInMode(mode)).toList();

  int get stepCount => visibleSteps.length;

  static const initial = WizardConfig(
    mode: WizardMode.initial,
    steps: [
      WizardStep(
        index: 0,
        type: WizardStepType.greetings,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 1,
        type: WizardStepType.basicInfo,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 2,
        type: WizardStepType.dates,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 3,
        type: WizardStepType.preferences,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
    ],
  );

  static const detailed = WizardConfig(
    mode: WizardMode.detailed,
    steps: [
      WizardStep(
        index: 0,
        type: WizardStepType.greetings,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 1,
        type: WizardStepType.basicInfo,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 2,
        type: WizardStepType.dates,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 3,
        type: WizardStepType.preferences,
        required: true,
        visibleInInitial: true,
        visibleInDetailed: true,
      ),
      WizardStep(
        index: 4,
        type: WizardStepType.hobbies,
        required: false,
        visibleInInitial: false,
        visibleInDetailed: true,
      ),
    ],
  );
}
