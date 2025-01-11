import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
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
                  title: S.of(context).wizard_partner_loves_title(
                        state.partnerName,
                      ),
                  entries: [
                    BulletPointEntry(
                      text: state.isInitial
                          ? S.of(context).wizard_partner_loves_message_initial_1(
                                state.partnerPronoun.getPossessive(state.customPronoun).toLowerCase(),
                              )
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
                child: LaMultiSelectPicker<LoveLanguage>(
                  title: S.of(context).wizard_partner_love_language_title(
                        state.partnerPronoun.getNominative(state.customPronoun).toLowerCase(),
                      ),
                  explanation: S.of(context).wizard_partner_love_language_explanation,
                  optional: false,
                  options: LoveLanguage.values.toList()
                    ..removeWhere((LoveLanguage e) => e == LoveLanguage.invalid)
                    ..sort((LoveLanguage left, LoveLanguage right) => left.toString().compareTo(right.toString())),
                  error: state.loveLanguageMissing,
                  onSelectionChanged: (List<LoveLanguage> selectedOptions) {
                    context.read<WizardCubit>().onLoveLanguageChanged(selectedOptions);
                  },
                ),
              ),
              if (state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                  child: LaDropDown<ToneOfVoice>(
                    title: S.of(context).wizard_partner_tone_of_voice_title(
                          state.partnerPronoun.getNominative(state.customPronoun).toLowerCase(),
                        ),
                    hint: S.of(context).wizard_partner_tone_of_voice_hint,
                    explanation: S.of(context).wizard_partner_tone_of_voice_explanation,
                    options: ToneOfVoice.values.toList()
                      ..removeWhere((ToneOfVoice e) => e == ToneOfVoice.invalid)
                      ..sort((ToneOfVoice left, ToneOfVoice right) => left.toString().compareTo(right.toString())),
                    error: state.loveLanguageMissing,
                    onChanged: (dynamic selectedOption, String? custom) {
                      context.read<WizardCubit>().onToneOfVoiceChanged(selectedOption as ToneOfVoice);
                    },
                  ),
                ),
              if (!state.isInitial)
                Padding(
                  padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                  child: LaMultiSelectPicker<Hobby>(
                    title: S.of(context).wizard_partner_hobbies_title(state.partnerName),
                    options: Hobby.values.toList()
                      ..removeWhere((Hobby e) => e == Hobby.invalid)
                      ..sort((Hobby left, Hobby right) => left.toString().compareTo(right.toString())),
                    explanation: S.of(context).wizard_partner_hobbies_explanation,
                    error: state.loveLanguageMissing,
                    onSelectionChanged: (List<Hobby> selectedOptions) {
                      context.read<WizardCubit>().onHobbiesChanged(selectedOptions);
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
