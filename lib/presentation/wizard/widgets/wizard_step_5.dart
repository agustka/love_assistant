part of "../wizard_page.dart";

class _WizardStep5 extends StatelessWidget {
  final bool isInitial;
  final String partnerName;
  final Pronoun partnerPronoun;
  final String customPronoun;

  const _WizardStep5({
    required this.isInitial,
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
  });

  @override
  Widget build(BuildContext context) {
    return LaWizardStepOrganism(
      ribbon: LaImageAsset(asset: LaTheme.illustrations.manLoveBanner),
      title: S.of(context).wizard_partner_anniversary_title,
      bulletPoints: [
        BulletPointEntry(
          text: "Help me remember the important milestones in your relationship.",
          emoji: "💞",
        ),
        BulletPointEntry(
          text: " I’ll use this to prepare thoughtful reminders and ideas for celebrating your special day.",
          emoji: "🎉",
        ),
      ],
      dropDownSlot: LaDropDownDefinition<RelationshipType>(
        fieldId: WizardPage.partnerRelationshipTypeId,
        optional: true,
        title: S.of(context).wizard_partner_relationship_type_title,
        hint: S.of(context).wizard_partner_relationship_type_hint,
        explanation: S.of(context).wizard_partner_relationship_type_explanation,
        options: RelationshipType.values.toList()..removeWhere((RelationshipType e) => e == RelationshipType.invalid),
        onItemSelected: context.read<WizardCubit>().onRelationshipTypeChanged,
      ),
      datePickerSlot1: LaDatePickerDefinition(
        fieldId: WizardPage.partnerAnniversaryFieldId,
        optional: true,
        title: S.of(context).wizard_partner_anniversary_title,
        hint: S.of(context).wizard_partner_anniversary_hint,
        explanation: S.of(context).wizard_partner_anniversary_explanation,
        defaultDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        onDateSelected: context.read<WizardCubit>().onAnniversaryChanged,
      ),
    );
  }
}
