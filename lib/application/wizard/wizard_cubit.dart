import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/setup.dart';

part 'wizard_state.dart';

@injectable
class WizardCubit extends BaseCubit<WizardState> {
  WizardCubit() : super(const WizardState.initial());

  Future init() async {}

  void start() {
    getIt<EventBus>().fire(const WizardEventGoToPage(page: 1));
    emit(state.copyWith(page: 1));
  }

  void onNameChanged(String input) {

  }

  void onPronounsChanged(Pronoun? pronoun, String? customInput) {

  }
}
