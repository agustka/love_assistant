import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep3 extends StatefulWidget {
  const WizardStep3({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WizardStep3State();
  }
}

class _WizardStep3State extends State<WizardStep3> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<WizardCubit, WizardState>(
      builder: (BuildContext context, WizardState state) {
        return SingleChildScrollView(
          child: Column(
            spacing: LaPadding.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: LaPadding.huge),
                child: LaBanner(
                  asset: LaTheme.illustrations.womanFloatingBanner,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium, top: LaPadding.large),
                child: LaBulletPointList(
                  size: BulletPointListSize.small,
                  title: S.of(context).wizard_partner_loves_title,
                  entries: [
                    BulletPointEntry(
                      text: state.isInitial
                          ? S.of(context).wizard_partner_loves_message_initial_1
                          : S.of(context).wizard_partner_loves_message_1,
                      //emoji: "📝",
                      //icon: LaIcons.contact,
                    ),
                    if (!state.isInitial)
                      BulletPointEntry(
                        text: S.of(context).wizard_partner_loves_message_2,
                        //emoji: "💌",
                        //icon: LaIcons.edit,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaMultiSelectPicker(
                  title: "What does your partner like?",
                  explanation: S.of(context).wizard_partner_love_language_explanation,
                  optional: false,
                  options: [
                    "Quality Time",
                    "Words of Affirmation",
                    "Acts of Service",
                    "Physical Touch",
                    "Receiving Gifts"
                  ],
                  error: state.loveLanguageMissing,
                  onSelectionChanged: (List<String> selectedOptions) {
                    context.read<WizardCubit>();
                  },
                ),
              ),
              if (state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                  child: LaDropDown<String>(
                    title: "What tone of voice should I use?",
                    options: [
                      "Playful",
                      "Romantic",
                      "Casual",
                      "Formal",
                    ],
                    explanation: S.of(context).wizard_partner_tone_of_voice_explanation,
                    hint: "Select tone of voice",
                    error: state.loveLanguageMissing,
                    onChanged: (dynamic selectedOptions, String? custom) {
                      context.read<WizardCubit>();
                    },
                  ),
                ),
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                  child: LaMultiSelectPicker(
                    title: "Does your partner have any hobbies?",
                    options: [
                      "Reading",
                      "Cooking",
                      "Traveling",
                      "Gaming",
                      "Fitness",
                      "Music",
                      "Crafting",
                      "Gardening",
                      "Movies & TV",
                      "Fishing",
                      "Sports"
                    ],
                    explanation: S.of(context).wizard_partner_hobbies_explanation,
                    error: state.loveLanguageMissing,
                    onSelectionChanged: (List<String> selectedOptions) {
                      context.read<WizardCubit>();
                    },
                  ),
                ),
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                  child: LaMultiSelectPicker(
                    title: "What food does your partner like?",
                    options: [
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
                    error: state.loveLanguageMissing,
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
