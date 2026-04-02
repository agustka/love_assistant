import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

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
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: LaPadding.small),
        child: CupertinoActionSheet(
          title: LaTextAtom(entries.title, style: LaTextAtomStyle.body17),
          actions: entries.entries
              .map(
                (PickerEntry e) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    e.onTap();
                  },
                  child: LaTextAtom(e.text, style: LaTextAtomStyle.body20),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: LaTextAtom(S.of(context).global_cancel, style: LaTextAtomStyle.body17),
          ),
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
          padding: EdgeInsets.only(top: LaPadding.large, bottom: LaPadding.small + MediaQuery.of(context).padding.bottom),
          child: Wrap(
            children: entries.entries
                .map(
                  (PickerEntry e) => LaListTileMolecule(
                    leading: e.icon == null
                        ? LaSvgAtom(
                            e.svg ?? AppAssets.icons.icTransparent,
                            width: LaSize.large,
                            height: LaSize.large,
                          )
                        : Icon(e.icon),
                    title: LaTextAtom(e.text, style: LaTextAtomStyle.body16),
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
