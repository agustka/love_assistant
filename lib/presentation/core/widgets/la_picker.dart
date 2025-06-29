import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart' hide LaPadding;
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/molecules/import.dart';

class PickerEntries {
  final String title;
  final List<PickerEntry> entries;

  PickerEntries({this.title = "", required this.entries});
}

class PickerEntry {
  final String text;
  final IconData? icon;
  final String? svg;
  final void Function() onTap;

  PickerEntry({required this.text, this.icon, this.svg, required this.onTap});
}

class LaPicker {
  static void showPicker(BuildContext context, {required PickerEntries entries}) {
    if (PlatformDetector.isIOS) {
      _showCupertinoPicker(context, entries);
    } else {
      _showMaterialPicker(context, entries);
    }
  }

  static void _showCupertinoPicker(BuildContext context, PickerEntries entries) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: LaText(entries.title, style: LaTheme.font.body17),
        actions: entries.entries
            .map(
              (PickerEntry e) => CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  e.onTap();
                },
                child: LaText(e.text, style: LaTheme.font.body20),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: LaText(S.of(context).global_cancel, style: LaTheme.font.body17),
        ),
      ),
    );
  }

  static void _showMaterialPicker(BuildContext context, PickerEntries entries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LaTheme.background(),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: LaPaddings.large, bottom: LaPaddings.small),
          child: Wrap(
            children: entries.entries
                .map(
                  (PickerEntry e) => LaListTile(
                    leading: e.icon == null
                        ? LaSvg(
                            e.svg ?? AppAssets.icons.icTransparent,
                            width: LaSizes.large,
                            height: 24,
                          )
                        : Icon(e.icon),
                    title: LaText(e.text, style: LaTheme.font.body16),
                    onTap: () {
                      Navigator.pop(context);
                      e.onTap();
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
