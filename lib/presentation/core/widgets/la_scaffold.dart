import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaScaffold extends StatelessWidget {
  final LaAppBar? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BottomButtonsDefinition? bottomButtons;
  final Widget child;

  const LaScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomButtons,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar?.toCupertino(),
        child: _cupertinoChild(child),
      );
    }
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomButtons == null
          ? null
          : LaBottomButtons(
              buttons: bottomButtons!,
              shouldPushOnKeyboard: bottomButtons?.shouldPushOnKeyboard ?? true,
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
        LaBottomButtons(
          buttons: bottomButtons!,
          shouldPushOnKeyboard: bottomButtons?.shouldPushOnKeyboard ?? true,
        ),
      ],
    );
  }
}
