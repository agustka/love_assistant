part of "../wizard_page.dart";

class _WizardStep1 extends StatelessWidget {
  const _WizardStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return LaWizardStepOrganism(
      image: LaImageAsset(asset: LaTheme.illustrations.manGreetings),
      title: S.of(context).wizard_greetings,
      bulletPoints: [
        BulletPointEntry(
          text: S.of(context).wizard_greetings_message_1,
          emoji: "✨",
          // icon: LaIcons.personAdd,
        ),
        BulletPointEntry(
          text: S.of(context).wizard_greetings_message_2,
          emoji: "💌",
          //icon: LaIcons.edit,
        ),
      ],
    );
  }
}
