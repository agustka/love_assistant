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

class LaBottomDrawerTemplate extends StatelessWidget {
  final BottomDrawerConfig config;

  const LaBottomDrawerTemplate({
    super.key,
    required this.config,
  });

  static Future<void> show({required BuildContext context, required BottomDrawerConfig config}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: LaTheme.background(),
      shape: LaCornerRadius().drawer,
      builder: (BuildContext context) => LaBottomDrawerTemplate(config: config),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (config.heading.isNotEmpty)
          LaPaddingAtom.only(
            left: LaPadding.medium,
            right: LaPadding.medium,
            top: LaPadding.large,
            bottom: LaPadding.small,
            child: LaTextAtom(
              config.heading,
              style: LaTextAtomStyle.body20.bold.onSurface,
            ),
          ),
        LaSeparatedColumnMolecule(
          separatorBuilder: (BuildContext context, int index) => LaPaddingAtom.symmetric(
            horizontal: LaPadding.medium,
            child: const LaDividerAtom(),
          ),
          children: config.entries.map((BottomDrawerEntry entry) => _getEntry(context, entry)).toList(),
        ),
        const LaSizedBoxAtom(height: LaPadding.bottomPadding),
      ],
    );
  }

  Widget _getEntry(BuildContext context, BottomDrawerEntry entry) {
    return LaTapVisualAtom(
      key: entry.key,
      onTap: () {
        if (entry.enabled) {
          entry.onTap.call();
          if (config.dismissOnAction) {
            App.navigatorKey.currentState?.pop();
          }
        }
      },
      child: LaContainerAtom(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: LaPadding.medium,
          bottom: LaPadding.medium,
        ),
        child: LaRow(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LaSizedBoxAtom(width: LaPadding.medium),
            if (entry.icon != null) ...[
              LaIconAtom(
                entry.icon!,
                size: LaSize.large,
                color: entry.enabled ? LaTheme.onSurface() : LaTheme.onSurface().withValues(alpha: 155),
              ),
              const LaSizedBoxAtom(width: LaPadding.medium),
            ],
            LaExpandedAtom(
              child: LaTextAtom(
                entry.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: entry.enabled ? LaTextAtomStyle.body16.bold.onSurface : LaTextAtomStyle.body16.bold.hintText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
