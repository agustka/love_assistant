import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep2 extends StatefulWidget {
  static const String partnerNameFieldId = "WizardStep2_partnerNameFieldId";
  static const String partnerPronounFieldId = "WizardStep2_partnerPronounFieldId";
  static const String partnerBirthdayFieldId = "WizardStep2_partnerBirthdayFieldId";
  static const String partnerAnniversaryFieldId = "WizardStep2_partnerAnniversaryFieldId";

  final String title;
  final String description;

  const WizardStep2({
    super.key,
    required this.title,
    required this.description,
  });

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
                  title: widget.title,
                  entries: [
                    BulletPointEntry(
                      text: widget.description,
                      //emoji: "📝",
                      //icon: LaIcons.contact,
                    ),
                    if (!state.isInitial)
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
                  fieldId: WizardStep2.partnerNameFieldId,
                  optional: false,
                  title: S.of(context).wizard_partner_profile_name_title,
                  hint: S.of(context).wizard_partner_profile_name_hint,
                  maxLength: 90,
                  onChanged: (String input) {
                    context.read<WizardCubit>().onNameChanged(input);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
                child: LaDropDown<Pronoun>(
                  fieldId: WizardStep2.partnerPronounFieldId,
                  optional: false,
                  title: S.of(context).wizard_partner_pronouns_title,
                  hint: S.of(context).wizard_partner_pronouns_hint,
                  customHint: S.of(context).global_enter_custom,
                  options: const [Pronoun.sheHer, Pronoun.heHim, Pronoun.theyThem],
                  freeFormOption: Pronoun.custom,
                  onChanged: (dynamic selected, String? customInput) {
                    context.read<WizardCubit>().onPronounsChanged(selected as Pronoun, customInput);
                  },
                ),
              ),
              if (!state.isInitial)
              Padding(
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
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
                padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
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
  }
}
