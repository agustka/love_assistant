import 'package:flutter/material.dart';
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
            Padding(
              padding: const EdgeInsets.only(top: LaPadding.large),
              child: LaBulletPointList(
                size: BulletPointListSize.small,
                title: S.of(context).wizard_greetings,
                entries: [
                  BulletPointEntry(
                    text: S.of(context).wizard_greetings_message_1,
                    //emoji: "✨",
                    //icon: LaIcons.personAdd,
                  ),
                  BulletPointEntry(
                    text: S.of(context).wizard_greetings_message_2,
                    //emoji: "🔔",
                    //icon: LaIcons.notification,
                  ),
                  BulletPointEntry(
                    text: S.of(context).wizard_greetings_message_3,
                    //emoji: "🔓",
                    //icon: LaIcons.lockOpen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
