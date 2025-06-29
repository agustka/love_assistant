import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';

class AppBarActionDefinition {
  final IconData icon;
  final void Function() onTap;

  AppBarActionDefinition({required this.icon, required this.onTap});

  Widget toWidget() {
    return LaTapVisual(
      onTap: onTap,
      child: LaPadding.all(
        value: PlatformDetector.isIOS ? 0 : LaPaddings.medium,
        child: LaIcon(
          icon,
          size: 24,
          color: LaTheme.onPrimary(),
        ),
      ),
    );
  }
}

class LaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;
  final AppBarActionDefinition? action;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(kToolbarHeight) : Size.zero;

  const LaAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: takesUpSpace ? LaTheme.chrome : LaTheme.chromeNoSpace,
      actions: action != null ? [action!.toWidget()] : [],
      leading: showBack
          ? InkWell(
              onTap: Navigator.of(context).pop,
              child: LaIcon(Icons.arrow_back, color: LaTheme.onPrimary()),
            )
          : null,
      title: title == null ? null : LaText(title!, style: TextStyle(color: LaTheme.onPrimary())),
      backgroundColor: LaTheme.primary(),
    );
  }

  LaCupertinoAppBar toCupertino() {
    return LaCupertinoAppBar(
      title: title,
      showBack: showBack,
      takesUpSpace: takesUpSpace,
      action: action,
    );
  }
}

class LaCupertinoAppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;
  final AppBarActionDefinition? action;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(44) : Size.zero;

  const LaCupertinoAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    if (!takesUpSpace) {
      return const LaSizedBox.shrink();
    }
    return CupertinoNavigationBar(
      middle: title == null
          ? null
          : LaText(
              title!,
              style: LaTheme.onPrimary().text,
            ),
      backgroundColor: LaTheme.primary(),
      automaticBackgroundVisibility: false,
      trailing: action?.toWidget(),
    );
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
