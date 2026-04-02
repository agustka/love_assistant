import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    bool isCupertino = false,
  }) async {
    if (PlatformDetector.isIOS) {
      return await _showCupertinoDialog(
            context: context,
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            icon: icon,
          ) ??
          false;
    } else {
      return await _showMaterialDialog(
            context: context,
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            icon: icon,
          ) ??
          false;
    }
  }

  static Future<bool?> _showMaterialDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: LaCornerRadius().dialog,
          title: LaRow(
            children: [
              if (icon != null) LaIconAtom(icon, color: LaTheme.onSurface()),
              if (icon != null) const LaSizedBoxAtom(width: LaPadding.mediumSmall),
              LaTextAtom(title, style: LaTextAtomStyle.body24.bold.onSurface),
            ],
          ),
          content: LaTextAtom(
            message,
            style: LaTextAtomStyle.body16.light.onSurface,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                FocusScope.of(context).unfocus();
              },
              child: LaTextAtom(
                confirmText ?? S.of(context).global_confirm,
                style: LaTextAtomStyle.body16.primary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                FocusScope.of(context).unfocus();
              },
              child: LaTextAtom(
                cancelText ?? S.of(context).global_cancel,
                style: LaTextAtomStyle.body16.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> _showCupertinoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) async {
    return await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return LaContainerAtom(
          padding: const EdgeInsets.all(LaPadding.medium),
          decoration: BoxDecoration(
            color: LaTheme.surface(),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
          ),
          child: LaColumnAtom(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) LaIconAtom(icon, size: LaSize.huge, color: LaTheme.primary()),
              if (icon != null) const LaSizedBoxAtom(height: LaSize.small),
              LaTextAtom(
                title,
                style: LaTextAtomStyle.body20.bold.onSurface,
              ),
              const LaSizedBoxAtom(height: LaPadding.medium),
              LaTextAtom(
                message,
                style: LaTextAtomStyle.body16.onSurface,
                textAlign: TextAlign.center,
              ),
              const LaSizedBoxAtom(height: LaPadding.large),
              LaRow(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LaSizedBoxAtom(width: LaPadding.large),
                  LaExpandedAtom(
                    child: LaButtonAtom(
                      onTap: () {
                        Navigator.of(context).pop(false);
                        FocusScope.of(context).unfocus();
                      },
                      text: confirmText ?? S.of(context).global_confirm,
                    ),
                  ),
                  const LaSizedBoxAtom(width: LaPadding.medium),
                  LaExpandedAtom(
                    child: LaButtonAtom(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        FocusScope.of(context).unfocus();
                      },
                      text: cancelText ?? S.of(context).global_cancel,
                    ),
                  ),
                  const LaSizedBoxAtom(width: LaPadding.large),
                ],
              ),
              const LaSizedBoxAtom(height: LaPadding.medium),
            ],
          ),
        );
      },
    );
  }
}
