import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep2 extends StatefulWidget {
  const WizardStep2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WizardStep2State();
  }
}

class _WizardStep2State extends State<WizardStep2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: LaPadding.large,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: LaPadding.huge),
            child: LaBanner(
              asset: LaTheme.illustrations.womanRunningBanner,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium, top: LaPadding.large),
            child: LaBulletPointList(
              size: BulletPointListSize.small,
              title: S.of(context).wizard_partner_profile_title,
              entries: [
                BulletPointEntry(
                  text: S.of(context).wizard_partner_profile_message_1,
                  //emoji: "📝",
                  //icon: LaIcons.contact,
                ),
                BulletPointEntry(
                  text: S.of(context).wizard_partner_profile_message_2,
                  //emoji: "💌",
                  //icon: LaIcons.edit,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
            child: LaTextField(
              title: S.of(context).wizard_partner_profile_name_title,
              hint: S.of(context).wizard_partner_profile_name_hint,
              onChanged: (String input) => context.read<WizardCubit>().onNameChanged(input),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
            child: LaDropDown<Pronoun>(
              title: "How should we refer to your partner?",
              hint: "Select your partner's pronouns",
              customHint: "Enter custom value",
              options: const [Pronoun.sheHer, Pronoun.heHim, Pronoun.theyThem],
              freeFormOption: Pronoun.custom,
              onChanged: (dynamic selected, String? customInput) =>
                  context.read<WizardCubit>().onPronounsChanged(selected as Pronoun, customInput),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
            child: LaDatePicker(
              title: "Select Birthday",
              hint: "Pick a date",
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onDateSelected: (DateTime selectedDate) {
                print("Selected Birthday: ${selectedDate.toIso8601String()}");
              },
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
