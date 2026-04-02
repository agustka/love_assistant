import 'package:flutter/material.dart';

class LaFormAtom extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final Widget child;
  final AutovalidateMode autovalidateMode;

  const LaFormAtom({
    super.key,
    this.formKey,
    required this.child,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: child,
    );
  }
}
