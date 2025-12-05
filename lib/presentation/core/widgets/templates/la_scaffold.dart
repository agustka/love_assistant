import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';
import 'package:la/presentation/core/widgets/organisms/import.dart';

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
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    if (PlatformDetector.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar?.toCupertino(),
        child: _cupertinoChild(child),
      );
    }
    return Scaffold(
      appBar: appBar,
      extendBody: true,
      backgroundColor: LaTheme.background(),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomSheet: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: LaTheme.background(),
          systemNavigationBarIconBrightness: LaTheme.brightness?.invert,
        ),
        child: bottomButtons == null
            ? Container(
                color: LaTheme.background(),
                height: MediaQuery.of(context).padding.bottom,
              )
            : LaBottomButtons(
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
        LaBottomButtons(
          buttons: bottomButtons!,
          shouldPushOnKeyboard: bottomButtons?.shouldPushOnKeyboard ?? true,
        ),
      ],
    );
  }
}
