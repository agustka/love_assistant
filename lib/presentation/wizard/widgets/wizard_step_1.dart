import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep1 extends StatelessWidget {
  const WizardStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
        child: Column(
          spacing: LaPadding.large,
          children: [
            LaEpicImage(
              asset: LaTheme.illustrations.manGreetings,
                widthAsPercentageOfScreen: 0.58,
            ),
            LaBulletPointList(
              size: BulletPointListSize.small,
              title: S.of(context).wizard_greetings,
              entries: [
                S.of(context).wizard_greetings_message_1,
                S.of(context).wizard_greetings_message_2,
                S.of(context).wizard_greetings_message_3,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
