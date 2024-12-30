import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/theme/la_theme.dart';

class LaCupertinoAppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(kToolbarHeight) : Size.zero;

  const LaCupertinoAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!takesUpSpace) {
      return const SizedBox.shrink();
    }
    return CupertinoNavigationBar(
      middle: title == null
          ? null
          : Text(
              title!,
              style: LaTheme.onPrimary().text,
            ),
      backgroundColor: LaTheme.primary(),
      automaticBackgroundVisibility: false,
    );
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return false;
  }
}

class LaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool takesUpSpace;

  @override
  Size get preferredSize => takesUpSpace ? const Size.fromHeight(kToolbarHeight) : Size.zero;

  const LaAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.takesUpSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: App.chrome,
      leading: showBack
          ? InkWell(
              onTap: Navigator.of(context).pop,
              child: Icon(Icons.arrow_back, color: LaTheme.onPrimary()),
            )
          : null,
      title: title == null ? null : Text(title!, style: TextStyle(color: LaTheme.onPrimary())),
      backgroundColor: LaTheme.primary(),
    );
  }

  LaCupertinoAppBar toCupertino() {
    return LaCupertinoAppBar(
      title: title,
      showBack: showBack,
      takesUpSpace: takesUpSpace,
    );
  }
}
