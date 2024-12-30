import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/la_app_bar.dart';

class LaScaffold extends StatelessWidget {
  final LaAppBar? appBar;
  final Widget child;

  const LaScaffold({super.key, this.appBar, required this.child});

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar?.toCupertino(),
        child: child,
      );
    }
    return Scaffold(
      appBar: appBar,
      body: child,
    );
  }
}
