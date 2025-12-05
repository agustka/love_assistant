import 'package:flutter/material.dart';

abstract class WizardStepWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final Widget child;

  const WizardStepWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.isLoading = false,
    this.isFormValid = true,
    this.onNext,
    this.onBack,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title.isNotEmpty) ...{
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...{
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            },
            const SizedBox(height: 32),
          },
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            child,
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
