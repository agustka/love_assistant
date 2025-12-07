import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/domain/wizard/entities/wizard_config.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/setup.dart';

part 'wizard_state.dart';

@Injectable()
class WizardCubit extends BaseCubit<WizardState> {
  final WizardConfig _config;

  WizardCubit() : _config = WizardConfig.initial, super(WizardState.initial());

  Future init() async {
    final bool isInitial = !getIt<InitializationService>().profileCreated;
    final WizardConfig config = isInitial ? WizardConfig.initial : WizardConfig.detailed;
    emit(state.copyWith(status: WizardStatus.loaded, isInitial: isInitial, config: config));
  }

  void next(int currentPage, {bool confirmed = false}) {
    final WizardStep currentStep = _config.visibleSteps[currentPage];
    final int nextStepIndex = currentPage + 1;

    if (nextStepIndex >= _config.visibleSteps.length) {
      // Handle completion
      return;
    }

    if (!_validateCurrentStep(currentStep)) {
      final bool missingName = state.partnerName.isEmpty;
      final bool missingPronoun = !state.partnerPronoun.hasPronoun(state.customPronoun);
      final bool missingBirthday = state.partnerBirthday.year <= 1800;
      if (currentStep.index == 1) {
        if (missingName) {
          getIt<EventBus>().fire(WizardEvent.missingName);
        }
        if (missingPronoun) {
          getIt<EventBus>().fire(WizardEvent.missingPronoun);
        }
        if (missingBirthday && !state.isInitial) {
          getIt<EventBus>().fire(WizardEvent.missingBirthday);
        }
      }
      return;
    }

    // Handle special cases for anniversary validation
    if (currentStep.index == 1 && !confirmed && !state.isInitial) {
      if (state.partnerAnniversary.year == 1800) {
        getIt<EventBus>().fire(WizardEvent.confirmNoAnniversary);
        return;
      }
    }

    getIt<EventBus>().fire(WizardEventGoToPage(page: nextStepIndex));
  }

  bool _validateCurrentStep(WizardStep step) {
    switch (step.index) {
      case 0:
        return true; // Always valid for the greetings screen
      case 1:
        return state.partnerName.isNotEmpty &&
            state.partnerPronoun != Pronoun.invalid &&
            (state.partnerPronoun != Pronoun.custom ||
                state.customPronoun.isNotEmpty);
      case 2:
        if (_config.mode == .initial) {
          return true;
        }
        return state.partnerBirthday.year > 1800;
      case 3:
        return true; // Always valid for preferences step
      case 4:
        return true; // Hobbies step is optional
      default:
        return true;
    }
  }

  void onNameChanged(String input) {
    emit(state.copyWith(partnerName: input.trim(), missingName: false));
  }

  void onPronounsChanged(dynamic pronoun, String? customInput) {
    emit(
      state.copyWith(
        partnerPronoun: pronoun as Pronoun,
        customPronoun: customInput,
      ),
    );
  }

  void onBirthdayChanged(DateTime selectedDate) {
    emit(state.copyWith(partnerBirthday: selectedDate));
  }

  void onAnniversaryChanged(DateTime selectedDate) {
    emit(state.copyWith(partnerAnniversary: selectedDate));
  }

  void onLoveLanguageChanged(List<dynamic> selectedOptions) {
    emit(state.copyWith(partnerLoveLanguages: selectedOptions as List<LoveLanguage>));
  }

  void onToneOfVoiceChanged(ToneOfVoice toneOfVoice) {
    emit(state.copyWith(partnerToneOfVoice: toneOfVoice));
  }

  void onHobbiesChanged(List<Hobby> selectedOptions) {
    emit(state.copyWith(partnerHobbies: selectedOptions));
  }
}
