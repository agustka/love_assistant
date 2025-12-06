import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';
import 'package:la/presentation/core/widgets/organisms/import.dart';

class WizardStep3 extends StatefulWidget {
  static const String loveLanguageFieldId = "WizardStep3_loveLanguageFieldId";
  static const String toneOfVoiceFieldId = "WizardStep3_toneOfVoiceFieldId";
  static const String partnerHobbiesFieldId = "WizardStep3_partnerHobbiesFieldId";

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
            spacing: LaPaddings.large,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: LaPaddings.huge),
                child: LaBanner(
                  asset: LaTheme.illustrations.womanFloatingBanner,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: LaPaddings.medium,
                  right: LaPaddings.medium,
                  top: LaPaddings.large,
                ),
                child: LaBulletPointList(
                  size: BulletPointListSize.small,
                  title: S.of(context).wizard_partner_more_details(state.partnerName),
                  entries: [
                    BulletPointEntry(
                      text: state.isInitial
                          ? S
                                .of(context)
                                .wizard_partner_loves_message_initial_1(
                                  state.partnerPronoun.getThagufall(state.customPronoun).toLowerCase(),
                                )
                          : S.of(context).wizard_partner_birthday_explanation,
                      emoji: "❤️ ",
                    ),
                    if (!state.isInitial)
                      BulletPointEntry(
                        text: S.of(context).wizard_partner_loves_message_2,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPaddings.medium, right: LaPaddings.medium),
                child: LaMultiSelectPicker<LoveLanguage>(
                  fieldId: WizardStep3.loveLanguageFieldId,
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
                    fieldId: WizardStep3.toneOfVoiceFieldId,
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
                    fieldId: WizardStep3.partnerHobbiesFieldId,
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
    );
  }
}
