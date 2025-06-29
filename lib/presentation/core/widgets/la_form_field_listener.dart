import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/import.dart';
import 'package:la/presentation/core/widgets/import.dart';

class LaFormFieldListener extends StatelessWidget {
  final Widget child;
  final String fieldId;
  final FocusNode? focus;

  const LaFormFieldListener({super.key, this.focus, required this.fieldId, required this.child});

  @override
  Widget build(BuildContext context) {
    return LaEventBusListener(
      onMessage: (LaFormFieldErrorEvent event) {
        if (event.fieldId == fieldId) {
          focus?.requestFocus();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: LaCornerRadius().drawer,
              content: LaText(event.message, style: LaTheme.font.body14.onError),
              behavior: SnackBarBehavior.floating,
              backgroundColor: LaTheme.error(),
            ),
          );
        }
      },
      child: child,
    );
  }
}

@immutable
class LaFormFieldErrorEvent {
  final String fieldId;
  final String message;

  const LaFormFieldErrorEvent({required this.fieldId, required this.message});
}
