import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class EmailConfirmationContentOrganism extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const EmailConfirmationContentOrganism({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    this.errorMessage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LaPaddingAtom.all(
      value: LaPadding.large,
      child: LaColumnAtom(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LaTextAtom(
            title,
            style: LaTextAtomStyle.body24.bold.onSurface,
            textAlign: TextAlign.center,
          ),
          const LaSizedBoxAtom(height: LaPadding.medium),
          LaTextAtom(
            message,
            style: LaTextAtomStyle.body16.onSurface,
            textAlign: TextAlign.center,
          ),
          if (errorMessage case final String errorMessage) ...[
            const LaSizedBoxAtom(height: LaPadding.medium),
            LaTextAtom(
              errorMessage,
              style: LaTextAtomStyle.body14.onError,
              textAlign: TextAlign.center,
            ),
          ],
          const LaSizedBoxAtom(height: LaPadding.large),
          LaButtonAtom(
            onTap: onConfirm,
            text: confirmText,
            busy: isLoading,
          ),
          const LaSizedBoxAtom(height: LaPadding.mediumSmall),
          LaButtonAtom(
            onTap: onCancel,
            text: cancelText,
            buttonStyle: LaButtonStyle.secondary,
          ),
        ],
      ),
    );
  }
}
