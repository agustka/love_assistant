import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/la_card.dart';
import 'package:la/presentation/core/widgets/atoms/la_center.dart';

class AuthTemplate extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final Widget? footer;
  final double? maxWidth;

  const AuthTemplate({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.footer,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LaCenter(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
          child: SingleChildScrollView(
            child: LaCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    child,
                    if (footer != null) ...{
                      const SizedBox(height: 24),
                      footer!,
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
