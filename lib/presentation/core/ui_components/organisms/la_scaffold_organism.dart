import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';

class LaScaffoldOrganism extends StatelessWidget {
  final LaAppBarOrganism? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BottomButtonsDefinition? bottomButtons;
  final Widget child;

  const LaScaffoldOrganism({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomButtons,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    if (PlatformDetector.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar?.toCupertino(),
        child: _cupertinoChild(child),
      );
    }
    return Scaffold(
      appBar: appBar,
      backgroundColor: LaTheme.background(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: LaTheme.background(),
          systemNavigationBarIconBrightness: LaTheme.brightness?.invert,
        ),
        child: bottomButtons == null
            ? Container(
                color: LaTheme.background(),
                height: MediaQuery.of(context).padding.bottom,
              )
            : LaBottomButtonsMolecule(
                buttons: bottomButtons!.copyWith(bottomPadding: bottomSafe),
                shouldPushOnKeyboard: bottomButtons?.shouldPushOnKeyboard ?? true,
              ),
      ),
      body: child,
    );
  }

  Widget _cupertinoChild(Widget child) {
    if (bottomButtons == null) {
      return child;
    }
    return Column(
      children: [
        Expanded(child: child),
        LaBottomButtonsMolecule(
          buttons: bottomButtons!,
          shouldPushOnKeyboard: bottomButtons?.shouldPushOnKeyboard ?? true,
        ),
      ],
    );
  }
}
