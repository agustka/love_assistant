import 'package:flutter/material.dart';
import 'package:la/domain/wizard/entities/wizard_config.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardPresenter {
  static String getStepTitle(BuildContext context, WizardStepType type, {String? gender}) {
    switch (type) {
      case WizardStepType.greetings:
        return S.of(context).wizard_greetings;
      case WizardStepType.basicInfo:
        return S.of(context).wizard_partner_profile_title;
      case WizardStepType.dates:
        return S.of(context).wizard_partner_more_details;
      case WizardStepType.preferences:
        return S.of(context).wizard_partner_loves_title(gender ?? "");
      case WizardStepType.hobbies:
        return S.of(context).wizard_partner_hobbies_title(gender ?? "");
      case WizardStepType.anniversary:
        return S.of(context).wizard_partner_anniversary_title;
    }
  }

  static String getStepDescription(BuildContext context, WizardStepType type) {
    switch (type) {
      case WizardStepType.greetings:
        return S.of(context).wizard_greetings_message_1;
      case WizardStepType.basicInfo:
        return S.of(context).wizard_partner_profile_message_1;
      case WizardStepType.dates:
        return S.of(context).wizard_partner_birthday_explanation;
      case WizardStepType.preferences:
        return S.of(context).wizard_partner_loves_message_1;
      case WizardStepType.hobbies:
        return S.of(context).wizard_partner_hobbies_explanation;
      case WizardStepType.anniversary:
        return S.of(context).wizard_partner_anniversary_explanation;
    }
  }
}
