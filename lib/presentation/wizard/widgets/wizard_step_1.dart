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
            ),
            LaBulletPointList(
              title: S.of(context).wizard_greetings,
              entries: [
                S.of(context).wizard_greetings_message_1,
                S.of(context).wizard_greetings_message_2,
                S.of(context).wizard_greetings_message_3,
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: LaPadding.medium),
              child: LaButton(
                text: S.of(context).wizard_start,
                onTap: context.read<WizardCubit>().start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
