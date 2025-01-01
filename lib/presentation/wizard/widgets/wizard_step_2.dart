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

class _WizardStep2State extends State<WizardStep2> with AutomaticKeepAliveClientMixin {
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
                  optional: false,
                  title: S.of(context).wizard_partner_profile_name_title,
                  hint: S.of(context).wizard_partner_profile_name_hint,
                  error: state.missingName,
                  errorText: S.of(context).wizard_partner_profile_name_missing,
                  onChanged: (String input) { context.read<WizardCubit>().onNameChanged(input);},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaDropDown<Pronoun>(
                  optional: false,
                  title: S.of(context).wizard_partner_pronouns_title,
                  hint: S.of(context).wizard_partner_pronouns_hint,
                  customHint: S.of(context).global_enter_custom,
                  options: const [Pronoun.sheHer, Pronoun.heHim, Pronoun.theyThem],
                  freeFormOption: Pronoun.custom,
                  error: state.missingPronoun,
                  errorText: S.of(context).wizard_partner_profile_pronoun_missing,
                  onChanged: (dynamic selected, String? customInput) {
                    context.read<WizardCubit>().onPronounsChanged(selected as Pronoun, customInput);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaDatePicker(
                  optional: false,
                  title: S.of(context).wizard_partner_birthday_title,
                  hint: S.of(context).wizard_partner_birthday_hint,
                  firstDate: DateTime(1900),
                  defaultDate: DateTime(1990),
                  lastDate: DateTime.now(),
                  error: state.missingBirthday,
                  errorText: S.of(context).wizard_partner_profile_birthday_missing,
                  onDateSelected: (DateTime selectedDate) {
                    context.read<WizardCubit>().onBirthdayChanged(selectedDate);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaDatePicker(
                  title: S.of(context).wizard_partner_anniversary_title,
                  hint: S.of(context).wizard_partner_anniversary_hint,
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
  }
}
