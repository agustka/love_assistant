import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaListTileMolecule extends StatelessWidget {
  final Widget? leading;
  final LaTextAtom title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const LaListTileMolecule({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isAndroid) {
      return ListTile(
        leading: leading,
        trailing: trailing,
        title: title,
        subtitle: subtitle,
        onTap: onTap,
      );
    }

    return LaTapVisualAtom(
      onTap: onTap,
      child: LaPaddingAtom.symmetric(
        vertical: LaPadding.mediumSmall,
        horizontal: LaPadding.medium,
        child: LaRow(
          children: [
            if (leading != null) ...[
              leading!,
              const LaSizedBoxAtom(width: LaPadding.medium),
            ],
            // Title and Subtitle (expanded to fill space)
            LaExpandedAtom(
              child: LaColumnAtom(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subtitle != null) subtitle!,
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
