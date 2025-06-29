import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';
import 'package:la/presentation/core/widgets/organisms/import.dart';

class WizardStep4 extends StatefulWidget {
  static const String foodPreferencesFieldId = "WizardStep4_foodPreferencesFieldId";
  static const String giftPreferencesFieldId = "WizardStep_giftPreferencesFieldId";

  final String title;
  final String description;

  const WizardStep4({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<StatefulWidget> createState() {
    return _WizardStep4State();
  }
}

class _WizardStep4State extends State<WizardStep4> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        return SingleChildScrollView(
          child: Column(
            spacing: LaPaddings.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: LaPaddings.huge),
                child: LaBanner(
                  asset: LaTheme.illustrations.manLoveBanner,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium, top: LaPaddings.large),
                child: LaBulletPointList(
                  size: BulletPointListSize.small,
                  title: widget.title,
                  entries: [
                    BulletPointEntry(
                      text: widget.description,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium, top: LaPaddings.large),
                child: LaBulletPointList(
                  size: BulletPointListSize.small,
                  title: S.of(context).wizard_partner_food_and_gifts_title(
                        state.partnerPronoun.getEignarfall(state.customPronoun).toLowerCase(),
                      ),
                  entries: [
                    BulletPointEntry(
                      text: S.of(context).wizard_partner_food_and_gifts_message_1(
                        state.partnerPronoun.getTholfall(state.customPronoun).toLowerCase(),
                      ),
                    ),
                    BulletPointEntry(
                      text: S.of(context).wizard_partner_food_and_gifts_message_2(
                        state.partnerName,
                        state.partnerPronoun.getNefnifall(state.customPronoun).toLowerCase(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                child: LaMultiSelectPicker(
                  fieldId: WizardStep4.foodPreferencesFieldId,
                  title: "What food does your partner like?",
                  options: const [
                    "Chocolate",
                    "Coffee",
                    "Pizza",
                    "Sushi",
                    "Tacos",
                    "Burgers",
                    "Seafood",
                    "Salads",
                    "Pasta",
                    "Fried Foods"
                  ],
                  explanation: S.of(context).wizard_partner_foods_explanation,
                  onSelectionChanged: (List<String> selectedOptions) {
                    context.read<WizardCubit>();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                child: LaMultiSelectPicker(
                  fieldId: WizardStep4.giftPreferencesFieldId,
                  title: "Which gift types does your partner like?",
                  options: const [
                    "Experience",
                    "Sentimental Items",
                    "Practical Gifts",
                    "Luxury Items",
                    "Hobbies & Interests",
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
        );
      },
    );
  }
}
