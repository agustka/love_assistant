import 'package:flutter/material.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class BottomDrawerEntry {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final bool enabled;
  final Key? key;

  const BottomDrawerEntry({
    required this.text,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.key,
  });
}

class BottomDrawerConfig {
  final String heading;
  final List<BottomDrawerEntry> entries;
  final bool dismissOnAction;

  const BottomDrawerConfig({
    required this.heading,
    required this.entries,
    this.dismissOnAction = true,
  });
}

class LaBottomDrawer extends StatelessWidget {
  final BottomDrawerConfig config;

  const LaBottomDrawer({
    super.key,
    required this.config,
  });

  static Future<void> show({required BuildContext context, required BottomDrawerConfig config}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LaTheme.background(),
      shape: LaCornerRadius().drawer,
      builder: (BuildContext context) => LaBottomDrawer(config: config),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LaColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (config.heading.isNotEmpty)
          LaPadding.only(
            left: LaPaddings.medium,
            right: LaPaddings.medium,
            top: LaPaddings.large,
            bottom: LaPaddings.small,
            child: LaText(
              config.heading,
              style: LaTheme.font.body20.bold.onSurface,
            ),
          ),
        LaSeparatedColumn(
          separatorBuilder: (BuildContext context, int index) => LaPadding.symmetric(
            horizontal: LaPaddings.medium,
            child: const LaDivider(),
          ),
          children: config.entries.map((BottomDrawerEntry entry) => _getEntry(context, entry)).toList(),
        ),
        const LaSizedBox(height: LaPaddings.bottomPadding),
      ],
    );
  }

  Widget _getEntry(BuildContext context, BottomDrawerEntry entry) {
    return LaTapVisual(
      key: entry.key,
      onTap: () {
        if (entry.enabled) {
          entry.onTap.call();
          if (config.dismissOnAction) {
            App.navigatorKey.currentState?.pop();
          }
        }
      },
      child: LaContainer(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: LaPaddings.medium,
          bottom: LaPaddings.medium,
        ),
        child: LaRow(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LaSizedBox(width: LaPaddings.medium),
            if (entry.icon != null) ...[
              LaIcon(
                entry.icon!,
                size: LaSizes.large,
                color: entry.enabled ? LaTheme.onSurface() : LaTheme.onSurface().withValues(alpha: 155),
              ),
              const LaSizedBox(width: LaPaddings.medium),
            ],
            LaExpanded(
              child: LaText(
                entry.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: LaTheme.font.body16.bold.copyWith(
                  color: entry.enabled ? LaTheme.onSurface() : LaTheme.onSurface().withValues(alpha: 155),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
