import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep4 extends StatefulWidget {
  const WizardStep4({super.key});

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
            spacing: LaPadding.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: LaPadding.huge),
                child: LaBanner(
                  asset: LaTheme.illustrations.manLoveBanner,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium, top: LaPadding.large),
                child: LaBulletPointList(
                  size: BulletPointListSize.small,
                  title: "Segðu mér aðeins meira", //"Tell Me More About Your Partner",
                  entries: [
                    BulletPointEntry(
                      text: "Help me craft thoughtful suggestions by sharing their gift preferences and dislikes.",
                      //emoji: "📝",
                      //icon: LaIcons.contact,
                    ),
                    BulletPointEntry(
                      text: "This ensures I recommend things they’ll love and avoid what they don’t.",
                      //emoji: "💌",
                      //icon: LaIcons.edit,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaDropDown<String>(
                  title: "What tone of voice should I use?",
                  options: [
                    "Playful", "Romantic", "Casual", "Formal",
                  ],
                  explanation: S.of(context).wizard_partner_tone_of_voice_explanation,
                  hint: "Select tone of voice",
                  error: state.loveLanguageMissing,
                  onChanged: (dynamic selectedOptions, String? custom) {
                    context.read<WizardCubit>();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaMultiSelectPicker(
                  title: "Which gift types does your partner like?",
                  options: [
                    "Experience",
                    "Sentimental Items",
                    "Practical Gifts",
                    "Luxury Items",
                    "Hobbies & Interests",
                    "Food & Drinks",
                    "Surprise Me",
                  ],
                  explanation: S.of(context).wizard_partner_gift_types_explanation,
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
