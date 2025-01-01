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
                      text: S.of(context).wizard_partner_loves_message_1,
                      //emoji: "📝",
                      //icon: LaIcons.contact,
                    ),
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
              const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
