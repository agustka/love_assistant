import 'package:flutter/material.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/widgets/la_app_bar.dart';
import 'package:la/presentation/core/widgets/la_pager.dart';
import 'package:la/presentation/core/widgets/la_scaffold.dart';

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
      child: LaPager(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 1:
            case 2:
            case 3:
            case 4:
            default:
              return const ColoredBox(color: Colors.pinkAccent);
          }
        },
      ),
    );
  }
}
