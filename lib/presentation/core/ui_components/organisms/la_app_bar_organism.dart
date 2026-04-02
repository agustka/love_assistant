import 'package:flutter/cupertino.dart';
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
        value: PlatformDetector.isIOS ? 0 : LaPaddings.medium,
        child: LaIconAtom(
          icon,
          size: LaSizes.large,
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
    return AppBar(
      actions: action != null ? [action!.toWidget(style: style)] : [],
      leading: showBack
          ? InkWell(
              onTap: Navigator.of(context).pop,
              child: LaIconAtom(Icons.arrow_back, color: style.foregroundColor),
            )
          : null,
      title: title == null ? null : LaTextAtom(title!, style: TextStyle(color: style.foregroundColor)),
      backgroundColor: style.backgroundColor,
    );
  }

  LaCupertinoAppBar toCupertino() {
    return LaCupertinoAppBar(
      title: title,
      showBack: showBack,
      takesUpSpace: takesUpSpace,
      action: action,
      style: style,
    );
  }
}

class LaCupertinoAppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;
  final AppBarStyle style;
  final AppBarActionDefinition? action;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(44) : Size.zero;

  const LaCupertinoAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
    this.action,
    this.style = AppBarStyle.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (!takesUpSpace) {
      return const LaSizedBoxAtom.shrink();
    }
    return CupertinoNavigationBar(
      middle: title == null
          ? null
          : LaTextAtom(
              title!,
              style: style.foregroundColor.text,
            ),
      backgroundColor: style.backgroundColor,
      automaticBackgroundVisibility: false,
      trailing: action?.toWidget(style: style),
    );
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}

extension _AppBarStyleExtension on AppBarStyle {
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
