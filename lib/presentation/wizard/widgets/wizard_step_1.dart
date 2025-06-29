import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';
import 'package:la/presentation/core/widgets/organisms/import.dart';

class WizardStep1 extends StatelessWidget {
  final String title;
  final String description;

  const WizardStep1({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LaPaddings.medium),
        child: Column(
          spacing: LaPaddings.large,
          children: [
            LaEpicImage(
              asset: LaTheme.illustrations.manGreetings,
              widthAsPercentageOfScreen: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: LaPaddings.large),
              child: LaBulletPointList(
                size: BulletPointListSize.small,
                title: title,
                entries: [
                  BulletPointEntry(
                    text: description,
                    //emoji: "✨",
                    //icon: LaIcons.personAdd,
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
