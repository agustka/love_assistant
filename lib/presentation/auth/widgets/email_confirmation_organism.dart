import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

enum EmailConfirmationMessageTone {
  pending,
  error,
  success,
}

class EmailConfirmationMessage {
  final Key key;
  final String text;
  final EmailConfirmationMessageTone tone;

  const EmailConfirmationMessage({
    required this.key,
    required this.text,
    required this.tone,
  });
}

class EmailConfirmationDefinition {
  final String message;
  final String confirmLabel;
  final String resendLabel;
  final Key confirmButtonKey;
  final Key resendButtonKey;
  final bool isRechecking;
  final bool resendEnabled;
  final EmailConfirmationMessage? recheckMessage;
  final EmailConfirmationMessage? resendMessage;
  final VoidCallback onConfirm;
  final VoidCallback onResend;

  const EmailConfirmationDefinition({
    required this.message,
    required this.confirmLabel,
    required this.resendLabel,
    required this.confirmButtonKey,
    required this.resendButtonKey,
    required this.isRechecking,
    required this.resendEnabled,
    required this.recheckMessage,
    required this.resendMessage,
    required this.onConfirm,
    required this.onResend,
  });
}

class EmailConfirmationOrganism extends StatelessWidget {
  final EmailConfirmationDefinition definition;

  const EmailConfirmationOrganism({
    super.key,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: LaPadding.mediumSmall,
      children: [
        LaTextAtom(
          definition.message,
          style: LaTextAtomStyle.body16.light,
          textAlign: TextAlign.center,
        ),
        LaButtonAtom(
          key: definition.confirmButtonKey,
          text: definition.confirmLabel,
          busy: definition.isRechecking,
          enabled: !definition.isRechecking,
          onTap: definition.onConfirm,
        ),
        LaButtonAtom(
          key: definition.resendButtonKey,
          text: definition.resendLabel,
          buttonStyle: LaButtonStyle.secondary,
          enabled: definition.resendEnabled,
          onTap: definition.onResend,
        ),
        _Message(message: definition.recheckMessage),
        _Message(message: definition.resendMessage),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  final EmailConfirmationMessage? message;

  const _Message({required this.message});

  @override
  Widget build(BuildContext context) {
    final EmailConfirmationMessage? message = this.message;
    if (message == null) {
      return const LaSizedBoxAtom.shrink();
    }

    return LaContainerAtom(
      key: message.key,
      padding: const EdgeInsets.all(LaPadding.mediumSmall),
      decoration: BoxDecoration(
        color: _backgroundColor(message.tone),
        borderRadius: BorderRadius.circular(LaCornerRadius.mediumSmall),
      ),
      child: LaTextAtom(
        message.text,
        style: _textStyle(message.tone),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _backgroundColor(EmailConfirmationMessageTone tone) {
    switch (tone) {
      case EmailConfirmationMessageTone.pending:
        return LaTheme.secondaryContainer();
      case EmailConfirmationMessageTone.error:
        return LaTheme.error();
      case EmailConfirmationMessageTone.success:
        return LaTheme.primary();
    }
  }

  LaTextAtomStyle _textStyle(EmailConfirmationMessageTone tone) {
    switch (tone) {
      case EmailConfirmationMessageTone.pending:
        return LaTextAtomStyle.body14.onSecondaryContainer;
      case EmailConfirmationMessageTone.error:
        return LaTextAtomStyle.body14.onError;
      case EmailConfirmationMessageTone.success:
        return LaTextAtomStyle.body14.onPrimary;
    }
  }
}
