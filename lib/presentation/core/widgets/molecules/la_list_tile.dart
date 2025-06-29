import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaListTile extends StatelessWidget {
  final Widget? leading;
  final LaText title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const LaListTile({
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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: LaPadding.symmetric(
        vertical: LaPaddings.mediumSmall,
        horizontal: LaPaddings.medium,
        child: LaRow(
          children: [
            if (leading != null) ...[
              leading!,
              const LaSizedBox(width: LaPaddings.medium),
            ],
            // Title and Subtitle (expanded to fill space)
            LaExpanded(
              child: LaColumn(
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
