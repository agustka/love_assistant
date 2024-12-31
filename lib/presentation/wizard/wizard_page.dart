import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_1.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  @override
  Widget build(BuildContext context) {
    return LaScaffold(
      appBar: LaAppBar(title: S.of(context).wizard_title, showBack: false),
      child: Center(
        child: LaPager(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return const WizardStep1();
              case 1:
                return LaEpicImage(asset: LaTheme.illustrations.womanReading);
              case 2:
                return LaEpicImage(asset: AppAssets.animations.progress, type: LaEpicImageType.animation);
              case 3:
                return LaEpicImage(asset: LaTheme.illustrations.manLove);
              case 4:
              default:
                return const ColoredBox(color: Colors.pinkAccent);
            }
          },
        ),
      ),
    );
  }
}
