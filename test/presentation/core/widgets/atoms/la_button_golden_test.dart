import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la/presentation/core/widgets/atoms/la_button.dart';

void main() {
  testGoldens('LaButton 1', (WidgetTester tester) async {
    // Load a real font
    TestWidgetsFlutterBinding.ensureInitialized();
    final fontLoader = FontLoader('Roboto')
      ..addFont(TestFonts.robotoRegular);
    fontLoader.load();

    final builder = GoldenBuilder.grid(
      columns: 3,
      widthToHeightRatio: 2.0,
    )
      ..addScenario(
        'default',
        LaButton(
          onTap: () {},
          text: 'Default Button',
        ),
      )
      ..addScenario(
        'secondary',
        LaButton(
          onTap: () {},
          text: 'Secondary Button',
          buttonStyle: LaButtonStyle.secondary,
        ),
      )
      ..addScenario(
        'icon',
        LaButton(
          onTap: () {},
          text: 'Icon Button',
          icon: Icons.add,
        ),
      )
      ..addScenario(
        'disabled',
        LaButton(
          onTap: () {},
          text: 'Disabled Button',
          enabled: false,
        ),
      )
      ..addScenario(
        'busy',
        LaButton(
          onTap: () {},
          text: 'Busy Button',
          busy: true,
        ),
      )
      ..addScenario(
        'max_lines',
        LaButton(
          onTap: () {},
          text: 'Button with multiple lines of text that should wrap properly',
          maxLines: 2,
        ),
      )
      ..addScenario(
        'icon_text',
        LaButton(
          onTap: () {},
          text: 'Icon Text Button',
          icon: Icons.add,
        ),
      )
      ..addScenario(
        'all_variations',
        LaButton(
          onTap: () {},
          text: 'All Variations',
          icon: Icons.add,
          enabled: false,
          busy: true,
          buttonStyle: LaButtonStyle.secondary,
          maxLines: 2,
          semanticLabel: 'All variations button',
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.green,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        home: Material(child: child),
      ),
    );

    await screenMatchesGolden(tester, 'la_button');
  });

  testGoldens('LaButton 2', (WidgetTester tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1.5)
      ..addScenario(
        'default',
        LaButton(
          onTap: () {},
          text: 'Default Button',
        ),
      )
      ..addScenario(
        'mini',
        LaButton(
          onTap: () {},
          text: 'Mini Button',
          size: LaButtonSize.mini,
        ),
      )
      ..addScenario(
        'secondary',
        LaButton(
          onTap: () {},
          text: 'Secondary Button',
          buttonStyle: LaButtonStyle.secondary,
        ),
      )
      ..addScenario(
        'icon',
        LaButton(
          onTap: () {},
          text: 'Icon Button',
          icon: Icons.add,
        ),
      )
      ..addScenario(
        'disabled',
        LaButton(
          onTap: () {},
          text: 'Disabled Button',
          enabled: false,
        ),
      )
      ..addScenario(
        'busy',
        LaButton(
          onTap: () {},
          text: 'Busy Button',
          busy: true,
        ),
      )
      ..addScenario(
        'max_lines',
        LaButton(
          onTap: () {},
          text: 'Button with multiple lines of text that should wrap properly',
          maxLines: 2,
        ),
      )
      ..addScenario(
        'icon_text',
        LaButton(
          onTap: () {},
          text: 'Icon Text Button',
          icon: Icons.add,
        ),
      )
      ..addScenario(
        'all_variations',
        LaButton(
          onTap: () {},
          text: 'All Variations',
          icon: Icons.add,
          enabled: false,
          busy: true,
          buttonStyle: LaButtonStyle.secondary,
          size: LaButtonSize.mini,
          maxLines: 2,
          semanticLabel: 'All variations button',
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: (child) => MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.green,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        home: Material(child: child),
      ),
    );

    await screenMatchesGolden(tester, 'la_button');
  });
}
