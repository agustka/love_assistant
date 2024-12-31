import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/la_drop_down.dart';

class WizardStep2 extends StatefulWidget {
  const WizardStep2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WizardStep2State();
  }
}

class _WizardStep2State extends State<WizardStep2> {
  final TextEditingController _controller = TextEditingController();

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
              hintText: S.of(context).wizard_partner_profile_name_hint,
              controller: _controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
            child: GenericPicker(
              title: "Pronouns",
              options: ['He/Him', 'She/Her', 'They/Them'],
              freeFormOptionLabel: "Custom",
              onChanged: (selected, customInput) {
                print("Selected Pronoun: $selected");
                print("Custom Pronoun: $customInput");
              },
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
