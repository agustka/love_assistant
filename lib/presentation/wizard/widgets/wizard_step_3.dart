part of "../wizard_page.dart";

class _WizardStep3 extends StatelessWidget {
  final bool isInitial;
  final String partnerName;
  final Pronoun partnerPronoun;
  final String customPronoun;

  const _WizardStep3({
    required this.isInitial,
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
  });

  @override
  Widget build(BuildContext context) {
    return LaWizardStepOrganism(
      ribbon: LaImageAsset(asset: LaTheme.illustrations.womanFloatingBanner),
      title: S.of(context).wizard_partner_more_details(partnerName),
      bulletPoints: [
        BulletPointEntry(
          text: isInitial
              ? S
                    .of(context)
                    .wizard_partner_loves_message_initial_1(
                      partnerPronoun.getThagufall(customPronoun).toLowerCase(),
                    )
              : S.of(context).wizard_partner_birthday_explanation,
          emoji: "❤️",
        ),
        if (!isInitial)
          BulletPointEntry(
            text: S.of(context).wizard_partner_loves_message_2,
          ),
      ],
      multiSelectPickerSlot1: !isInitial
          ? null
          : LaMultiSelectPickerDefinition(
              fieldId: WizardPage.loveLanguageFieldId,
              title: S
                  .of(context)
                  .wizard_partner_love_language_title(
                    partnerPronoun.getThagufall(customPronoun).toLowerCase(),
                  ),
              explanation: S.of(context).wizard_partner_love_language_explanation,
              optional: false,
              options: LoveLanguage.values.toList()
                ..removeWhere((LoveLanguage e) => e == LoveLanguage.invalid)
                ..sort((LoveLanguage left, LoveLanguage right) => left.toString().compareTo(right.toString())),
              onSelectionChanged: context.read<WizardCubit>().onLoveLanguageChanged,
            ),
      multiSelectPickerSlot2: isInitial ? null : LaMultiSelectPickerDefinition(
        fieldId: WizardPage.partnerHobbiesFieldId,
        title: S.of(context).wizard_partner_hobbies_title(partnerName),
        optional: true,
        options: Hobby.values.toList()
          ..removeWhere((Hobby e) => e == Hobby.invalid)
          ..sort((Hobby left, Hobby right) => left.toString().compareTo(right.toString())),
        explanation: S.of(context).wizard_partner_hobbies_explanation,
        onSelectionChanged: context.read<WizardCubit>().onHobbiesChanged,
      ),
      dropDownSlot: LaDropDownDefinition(
        fieldId: WizardPage.toneOfVoiceFieldId,
        title: S
            .of(context)
            .wizard_partner_tone_of_voice_title(
              partnerPronoun.getTholfall(customPronoun).toLowerCase(),
            ),
        optional: true,
        hint: S.of(context).wizard_partner_tone_of_voice_hint,
        explanation: S.of(context).wizard_partner_tone_of_voice_explanation,
        options: ToneOfVoice.values.toList()
          ..removeWhere((ToneOfVoice e) => e == ToneOfVoice.invalid)
          ..sort((ToneOfVoice left, ToneOfVoice right) => left.toString().compareTo(right.toString())),
        onItemSelected: (dynamic selectedOption, String? custom) {
          context.read<WizardCubit>().onToneOfVoiceChanged(selectedOption as ToneOfVoice);
        },
      ),
    );
  }
}
