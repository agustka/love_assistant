import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_scaffold.dart';

class WizardTemplate<T> extends StatelessWidget {
  final int pageCount;
  final Widget Function(BuildContext context, int index) pageBuilder;
  final PageController? pageController;
  final void Function(T message)? onMessage;
  final AppBarActionDefinition? appBarAction;
  final BottomButtonsDefinition? bottomButtons;

  const WizardTemplate({
    super.key,
    required this.pageCount,
    required this.pageBuilder,
    this.pageController,
    this.onMessage,
    this.appBarAction,
    this.bottomButtons,
  });

  @override
  Widget build(BuildContext context) {
    return LaEventBusListener<T>(
      onMessage: onMessage ?? (_) {},
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LaScaffold(
          appBar: LaAppBar(
            style: AppBarStyle.background,
            showBack: false,
            action: appBarAction,
          ),
          bottomButtons: bottomButtons,
          child: LaPager(
            itemCount: pageCount,
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: pageBuilder,
          ),
        ),
      ),
    );
  }
}
