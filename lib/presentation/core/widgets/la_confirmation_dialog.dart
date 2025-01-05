import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/widgets/import.dart';

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
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            spacing: LaPadding.mediumSmall,
            children: [
              if (icon != null) Icon(icon, color: LaTheme.onSurface()),
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
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: LaTheme.surface(),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, size: 40, color: LaTheme.primary()),
              if (icon != null) const SizedBox(height: 8),
              LaText(
                title,
                style: LaTheme.font.body20.bold.onSurface,
              ),
              const SizedBox(height: LaPadding.medium),
              Text(
                message,
                style: LaTheme.font.body16.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: LaPadding.large),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: LaPadding.large),
                  Expanded(
                    child: LaButton(
                      onTap: () {
                        Navigator.of(context).pop(false);
                        FocusScope.of(context).unfocus();
                      },
                      text: confirmText ?? S.of(context).global_confirm,
                    ),
                  ),
                  const SizedBox(width: LaPadding.medium),
                  Expanded(
                    child: LaButton(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        FocusScope.of(context).unfocus();
                      },
                      text: cancelText ?? S.of(context).global_cancel,
                    ),
                  ),
                  const SizedBox(width: LaPadding.large),
                ],
              ),
              const SizedBox(height: LaPadding.medium),
            ],
          ),
        );
      },
    );
  }
}
