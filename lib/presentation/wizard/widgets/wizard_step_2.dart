part of "../wizard_page.dart";

class _WizardStep2 extends StatelessWidget {
  final bool isInitial;

  const _WizardStep2({required this.isInitial});

  @override
  Widget build(BuildContext context) {
    return LaWizardStepOrganism(
      ribbon: LaImageAsset(asset: LaTheme.illustrations.womanRunningBanner),
      title: S.of(context).wizard_partner_profile_title,
      bulletPoints: [
        BulletPointEntry(
          text: isInitial
              ? S.of(context).wizard_partner_profile_message_1_shortened
              : S.of(context).wizard_partner_profile_message_1_extended,
          emoji: "📝",
          //icon: LaIcons.contact,
        ),
        if (!isInitial)
          BulletPointEntry(
            text: S.of(context).wizard_partner_profile_message_2,
            //emoji: "💌",
            //icon: LaIcons.edit,
          ),
      ],
      textFieldSlot: LaTextFieldDefinition(
        fieldId: WizardPage.partnerNameFieldId,
        optional: false,
        title: S.of(context).wizard_partner_profile_name_title,
        hint: S.of(context).wizard_partner_profile_name_hint,
        maxLength: 90,
        onTextChanged: context.read<WizardCubit>().onNameChanged,
      ),
      dropDownSlot: LaDropDownDefinition<Pronoun>(
        fieldId: WizardPage.partnerPronounFieldId,
        freeFormFieldId: WizardPage.partnerPronounFreeFormFieldId,
        optional: false,
        title: S.of(context).wizard_partner_pronouns_title,
        hint: S.of(context).wizard_partner_pronouns_hint,
        customHint: S.of(context).global_enter_custom,
        options: const [Pronoun.sheHer, Pronoun.heHim, Pronoun.theyThem],
        freeFormOption: Pronoun.custom,
        onItemSelected: context.read<WizardCubit>().onPronounsChanged,
      ),
    );

    /*
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        return SingleChildScrollView(
          child: Column(
            spacing: LaPaddings.large,
            children: [
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                  child: LaDatePicker(
                    fieldId: WizardStep2.partnerBirthdayFieldId,
                    optional: false,
                    title: S.of(context).wizard_partner_birthday_title,
                    hint: S.of(context).wizard_partner_birthday_hint,
                    explanation: S.of(context).wizard_partner_birthday_explanation,
                    firstDate: DateTime(1900),
                    defaultDate: DateTime(1990),
                    lastDate: DateTime.now(),
                    onDateSelected: (DateTime selectedDate) {
                      context.read<WizardCubit>().onBirthdayChanged(selectedDate);
                    },
                  ),
                ),
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                  child: LaDatePicker(
                    fieldId: WizardStep2.partnerAnniversaryFieldId,
                    title: S.of(context).wizard_partner_anniversary_title,
                    hint: S.of(context).wizard_partner_anniversary_hint,
                    explanation: S.of(context).wizard_partner_anniversary_explanation,
                    defaultDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    onDateSelected: (DateTime selectedDate) {
                      context.read<WizardCubit>().onAnniversaryChanged(selectedDate);
                    },
                  ),
                ),
              const SizedBox.shrink(),
            ],
          ),
        );
      },
    );

     */
  }
}
