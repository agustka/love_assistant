import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

class WizardStep1 extends StatelessWidget {
  const WizardStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium),
        child: Stack(
          children: [
            LaIconCircle(icon: AppAssets.icons.flags.flagIs),
            Column(
              spacing: LaPadding.large,
              children: [
                LaEpicImage(
                  asset: LaTheme.illustrations.manGreetings,
                  title: S.of(context).wizard_greetings,
                  message: S.of(context).wizard_greetings_message,
                ),
                LaText(S.of(context).wizard_greetings_privacy, style: LaTheme.font.body12.light, textAlign: TextAlign.center,),
                LaButton(text: "Begin", onTap: (){}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
