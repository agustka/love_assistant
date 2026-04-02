import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

enum AppBarStyle {
  primary,
  background,
}

class AppBarActionDefinition {
  final IconData icon;
  final void Function() onTap;

  AppBarActionDefinition({required this.icon, required this.onTap});

  Widget toWidget({required AppBarStyle style}) {
    return LaTapVisualAtom(
      onTap: onTap,
      child: LaPaddingAtom.all(
        value: PlatformDetector.isIOS ? 0 : LaPadding.medium,
        child: LaIconAtom(
          icon,
          size: LaSize.large,
          color: style.foregroundColor,
        ),
      ),
    );
  }
}

class LaAppBarOrganism extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;
  final AppBarActionDefinition? action;
  final AppBarStyle style;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(kToolbarHeight) : Size.zero;

  const LaAppBarOrganism({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
    this.action,
    this.style = AppBarStyle.primary,
  });

  @override
  Widget build(BuildContext context) {
    return LaAppBarAtom(
      actions: action != null ? [action!.toWidget(style: style)] : [],
      leading: showBack
          ? LaTapVisualAtom(
              onTap: Navigator.of(context).pop,
              child: LaIconAtom(Icons.arrow_back, color: style.foregroundColor),
            )
          : null,
      title: title == null ? null : LaTextAtom(title!, style: style.materialTitleTextStyle),
      backgroundColor: style.backgroundColor,
    );
  }

  LaCupertinoNavigationBarAtom? toCupertino() {
    if (!takesUpSpace) return null;
    return LaCupertinoNavigationBarAtom(
      middle: title == null
          ? null
          : LaTextAtom(
              title!,
              style: style.cupertinoTitleTextStyle,
            ),
      backgroundColor: style.backgroundColor,
      automaticBackgroundVisibility: false,
      trailing: action?.toWidget(style: style),
    );
  }
}

extension _AppBarStyleExtension on AppBarStyle {
  LaTextAtomStyle get materialTitleTextStyle {
    return switch (this) {
      AppBarStyle.primary => LaTextAtomStyle.body20.onPrimary,
      AppBarStyle.background => LaTextAtomStyle.body20.onBackground,
    };
  }

  LaTextAtomStyle get cupertinoTitleTextStyle {
    return switch (this) {
      AppBarStyle.primary => LaTextAtomStyle.body17.onPrimary,
      AppBarStyle.background => LaTextAtomStyle.body17.onBackground,
    };
  }

  Color get backgroundColor {
    switch (this) {
      case AppBarStyle.primary:
        return LaTheme.primary();
      case AppBarStyle.background:
        return LaTheme.background();
    }
  }

  Color get foregroundColor {
    switch (this) {
      case AppBarStyle.primary:
        return LaTheme.onPrimary();
      case AppBarStyle.background:
        return LaTheme.onBackground();
    }
  }
}
