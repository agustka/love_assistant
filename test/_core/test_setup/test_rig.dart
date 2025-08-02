import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la/presentation/core/widgets/atoms/la_text.dart';
import 'package:la/presentation/core/widgets/import.dart';

Future<void> setupAppDependencies() async {
  await loadAppFonts();
}

extension PumpApp on WidgetTester {
  Future<void> pumpUiComponentWidgetBuilder(Widget widget, {bool darkMode = false}) async {
    await pumpWidget(widget);
    await pumpAndSettle();
  }
}

class LabelGoldenBuilder {
  final List<Widget> _children = [];
  final Widget Function(Widget child)? wrap;
  final bool darkMode;

  LabelGoldenBuilder.column({this.wrap, this.darkMode = false});

  void addScenario(String name, Widget widget) {
    _children.add(LaText(name, style: LaTheme.font.body16));
    _children.add(const SizedBox(height: 8));
    _children.add(wrap?.call(widget) ?? widget);
    _children.add(const SizedBox(height: 16));
  }

  Widget build() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: LaTheme.materialTheme(darkMode ? Brightness.dark : Brightness.light),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _children,
          ),
        ),
      ),
    );
  }
}
