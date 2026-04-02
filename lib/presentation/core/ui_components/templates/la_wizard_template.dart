import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/organisms/la_scaffold_organism.dart';

class LaWizardTemplate extends StatelessWidget {
  final Widget body;
  final LaAppBarOrganism? appBar;
  final BottomButtonsDefinition? bottomButtons;

  const LaWizardTemplate({
    super.key,
    required this.body,
    this.appBar,
    this.bottomButtons,
  });

  @override
  Widget build(BuildContext context) {
    return LaGestureDetectorAtom(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LaScaffoldOrganism(
        appBar: appBar,
        bottomButtons: bottomButtons,
        child: body,
      ),
    );
  }
}
