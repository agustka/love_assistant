part of "../wizard_page.dart";

class _WizardStep4 extends StatelessWidget {
  final bool isInitial;
  final String partnerName;
  final Pronoun partnerPronoun;
  final String customPronoun;

  const _WizardStep4({
    required this.isInitial,
    required this.partnerName,
    required this.partnerPronoun,
    required this.customPronoun,
  });

  @override
  Widget build(BuildContext context) {
    return LaWizardStepOrganism(
      ribbon: LaImageAsset(asset: LaTheme.illustrations.manLoveBanner),
      title: isInitial ? _getInitialTitle(context) : _getPostSetupTitle(context),
      bulletPoints: isInitial ? _getInitialBulletPoints(context) : _getPostSetupBulletPoints(context),
      multiSelectPickerSlot1: LaMultiSelectPickerDefinition(
        fieldId: WizardPage.foodPreferencesFieldId,
        title: S.of(context).wizard_partner_food_likes_title(partnerName),
        optional: true,
        options: FavoriteFood.values.toList()
          ..removeWhere((FavoriteFood e) => e == FavoriteFood.invalid),
        explanation: S.of(context).wizard_partner_foods_explanation,
        onSelectionChanged: context.read<WizardCubit>().onFavoriteFoodsChanged,
      ),
    );

    return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        /*return SingleChildScrollView(
          child: Column(
            spacing: LaPaddings.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                child: LaMultiSelectPicker(
                  fieldId: WizardPage.giftPreferencesFieldId,
                  title: "Which gift types does your partner like?",
                  options: const [
                    "Experience",
                    "Sentimental",
                    "Practical Gifts",
                    "Luxury Items",
                    "Hobbies",
                    "Food & Drinks",
                    "Surprise Me",
                  ],
                  explanation: S.of(context).wizard_partner_gift_types_explanation,
                  onSelectionChanged: (List<String> selectedOptions) {
                    context.read<WizardCubit>();
                  },
                ),
              ),
              const SizedBox.shrink(),
            ],
          ),
        );*/
      },
    );
  }

  List<BulletPointEntry> _getInitialBulletPoints(BuildContext context) {
    return [
      BulletPointEntry(
        text: S.of(context).wizard_partner_loves_message_1(partnerName),
        emoji: "💖",
      ),
    ];
  }

  String _getInitialTitle(BuildContext context) {
    return S
        .of(context)
        .wizard_partner_loves_title(
          partnerPronoun.getNefnifall(customPronoun).toLowerCase(),
        );
  }

  String _getPostSetupTitle(BuildContext context) {
    return S
        .of(context)
        .wizard_partner_food_and_gifts_title(
          partnerPronoun.getEignarfall(customPronoun).toLowerCase(),
        );
  }

  List<BulletPointEntry> _getPostSetupBulletPoints(BuildContext context) {
    return [
      BulletPointEntry(
        text: S
            .of(context)
            .wizard_partner_food_and_gifts_message_1(
              partnerPronoun.getTholfall(customPronoun).toLowerCase(),
            ),
        emoji: "🎁",
      ),
      BulletPointEntry(
        text: S
            .of(context)
            .wizard_partner_food_and_gifts_message_2(
              partnerName,
              partnerPronoun.getNefnifall(customPronoun).toLowerCase(),
            ),
        emoji: "🎯",
      ),
    ];
  }
}
