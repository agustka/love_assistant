import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/setup.dart';

part 'wizard_state.dart';

@injectable
class WizardCubit extends BaseCubit<WizardState> {
  WizardCubit() : super(WizardState.initial());

  Future init() async {
    final bool isInitial = !getIt<InitializationService>().profileCreated;
    emit(state.copyWith(isInitial: isInitial));
  }

  void next(int currentPage, {bool confirmed = false}) {
    if (currentPage == 0) {
      getIt<EventBus>().fire(const WizardEventGoToPage(page: 1));
    } else if (currentPage == 1) {
      bool hasError = state.partnerName.isEmpty || state.partnerPronoun == Pronoun.invalid;
      if (!state.isInitial) {
        hasError = hasError || state.partnerBirthday.year == 1800;
      }
      bool missingCustomPronoun = false;
      if (state.partnerPronoun == Pronoun.custom && state.customPronoun.isEmpty) {
        hasError = true;
        missingCustomPronoun = true;
      }

      if (state.isInitial &&
          state.partnerName.isNotEmpty &&
          state.partnerPronoun != Pronoun.invalid &&
          !missingCustomPronoun) {
        getIt<EventBus>().fire(const WizardEventGoToPage(page: 2));
      } else if (state.partnerName.isNotEmpty &&
          state.partnerPronoun != Pronoun.invalid &&
          !missingCustomPronoun &&
          state.partnerBirthday.year > 1800 &&
          (state.partnerAnniversary.year > 1800 || confirmed)) {
        getIt<EventBus>().fire(const WizardEventGoToPage(page: 2));
      }

      if (state.partnerAnniversary.year == 1800 && !confirmed && !hasError && !state.isInitial) {
        getIt<EventBus>().fire(WizardEvent.confirmNoAnniversary);
      }

      emit(
        state.copyWith(
          missingName: state.partnerName.isEmpty,
          missingPronoun: state.partnerPronoun == Pronoun.invalid,
          missingCustomPronoun: missingCustomPronoun,
          missingBirthday: state.partnerBirthday.year == 1800,
        ),
      );
    }
  }

  void onNameChanged(String input) {
    emit(state.copyWith(partnerName: input, missingName: false));
  }

  void onPronounsChanged(Pronoun pronoun, String? customInput) {
    emit(
      state.copyWith(
        partnerPronoun: pronoun,
        missingPronoun: false,
        customPronoun: customInput,
        missingCustomPronoun: false,
      ),
    );
  }

  void onBirthdayChanged(DateTime selectedDate) {
    emit(state.copyWith(partnerBirthday: selectedDate, missingBirthday: false));
  }

  void onAnniversaryChanged(DateTime selectedDate) {
    emit(state.copyWith(partnerAnniversary: selectedDate));
  }

  void onLoveLanguageChanged(List<LoveLanguage> selectedOptions) {
    emit(state.copyWith(partnerLoveLanguages: selectedOptions));
  }
}
