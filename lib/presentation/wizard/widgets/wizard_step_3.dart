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
          emoji: "❤️ ",
        ),
        if (!isInitial)
          BulletPointEntry(
            text: S.of(context).wizard_partner_loves_message_2,
          ),
      ],
      multiSelectPickerSlot1: LaMultiSelectPickerDefinition(
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
    );

    /*return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        return SingleChildScrollView(
          child: Column(
            spacing: LaPaddings.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: LaPaddings.medium,
                  right: LaPaddings.medium,
                  top: LaPaddings.large,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                child: LaMultiSelectPicker<LoveLanguage>(
                  fieldId: WizardPage.loveLanguageFieldId,
                  title: S
                      .of(context)
                      .wizard_partner_love_language_title(
                        state.partnerPronoun.getThagufall(state.customPronoun).toLowerCase(),
                      ),
                  explanation: S.of(context).wizard_partner_love_language_explanation,
                  optional: false,
                  options: LoveLanguage.values.toList()
                    ..removeWhere((LoveLanguage e) => e == LoveLanguage.invalid)
                    ..sort((LoveLanguage left, LoveLanguage right) => left.toString().compareTo(right.toString())),
                  onSelectionChanged: (List<LoveLanguage> selectedOptions) {
                    context.read<WizardCubit>().onLoveLanguageChanged(selectedOptions);
                  },
                ),
              ),
              if (state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                  child: LaDropDown<ToneOfVoice>(
                    fieldId: WizardPage.toneOfVoiceFieldId,
                    title: S
                        .of(context)
                        .wizard_partner_tone_of_voice_title(
                          state.partnerPronoun.getTholfall(state.customPronoun).toLowerCase(),
                        ),
                    hint: S.of(context).wizard_partner_tone_of_voice_hint,
                    explanation: S.of(context).wizard_partner_tone_of_voice_explanation,
                    options: ToneOfVoice.values.toList()
                      ..removeWhere((ToneOfVoice e) => e == ToneOfVoice.invalid)
                      ..sort((ToneOfVoice left, ToneOfVoice right) => left.toString().compareTo(right.toString())),
                    onChanged: (dynamic selectedOption, String? custom) {
                      context.read<WizardCubit>().onToneOfVoiceChanged(selectedOption as ToneOfVoice);
                    },
                  ),
                ),
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                  child: LaMultiSelectPicker<Hobby>(
                    fieldId: WizardPage.partnerHobbiesFieldId,
                    title: S.of(context).wizard_partner_hobbies_title(state.partnerName),
                    options: Hobby.values.toList()
                      ..removeWhere((Hobby e) => e == Hobby.invalid)
                      ..sort((Hobby left, Hobby right) => left.toString().compareTo(right.toString())),
                    explanation: S.of(context).wizard_partner_hobbies_explanation,
                    onSelectionChanged: (List<Hobby> selectedOptions) {
                      context.read<WizardCubit>().onHobbiesChanged(selectedOptions);
                    },
                  ),
                ),
              const SizedBox.shrink(),
            ],
          ),
        );
      },
    );*/
  }
}
