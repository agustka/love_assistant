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
              if (icon != null) LaIcon(icon, color: LaTheme.onSurface()),
              if (icon != null) const LaSizedBox(width: LaPaddings.mediumSmall),
              LaText(title, style: LaTheme.font.body24.bold.onSurface),
            ],
          ),
          content: LaText(
            message,
            style: LaTheme.font.body16.light.onSurface,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                FocusScope.of(context).unfocus();
              },
              child: LaText(
                confirmText ?? S.of(context).global_confirm,
                style: LaTheme.font.body16.primary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                FocusScope.of(context).unfocus();
              },
              child: LaText(
                cancelText ?? S.of(context).global_cancel,
                style: LaTheme.font.body16.primary,
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
        return LaContainer(
          padding: const EdgeInsets.all(LaPaddings.medium),
          decoration: BoxDecoration(
            color: LaTheme.surface(),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(LaCornerRadius.large)),
          ),
          child: LaColumn(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) LaIcon(icon, size: LaSizes.huge, color: LaTheme.primary()),
              if (icon != null) const LaSizedBox(height: LaSizes.small),
              LaText(
                title,
                style: LaTheme.font.body20.bold.onSurface,
              ),
              const LaSizedBox(height: LaPaddings.medium),
              LaText(
                message,
                style: LaTheme.font.body16.onSurface,
                textAlign: TextAlign.center,
              ),
              const LaSizedBox(height: LaPaddings.large),
              LaRow(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LaSizedBox(width: LaPaddings.large),
                  LaExpanded(
                    child: LaButton(
                      onTap: () {
                        Navigator.of(context).pop(false);
                        FocusScope.of(context).unfocus();
                      },
                      text: confirmText ?? S.of(context).global_confirm,
                    ),
                  ),
                  const LaSizedBox(width: LaPaddings.medium),
                  LaExpanded(
                    child: LaButton(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        FocusScope.of(context).unfocus();
                      },
                      text: cancelText ?? S.of(context).global_cancel,
                    ),
                  ),
                  const LaSizedBox(width: LaPaddings.large),
                ],
              ),
              const LaSizedBox(height: LaPaddings.medium),
            ],
          ),
        );
      },
    );
  }
}
