import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaEmailPasswordForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final String submitLabel;
  final bool loading;

  const LaEmailPasswordForm({
    super.key,
    required this.onSubmit,
    required this.submitLabel,
    this.loading = false,
  });

  @override
  State<LaEmailPasswordForm> createState() => _LaEmailPasswordFormState();
}

class _LaEmailPasswordFormState extends State<LaEmailPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LaTextField(
            fieldId: 'email',
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => _email = val,
          ),
          const SizedBox(height: 12),
          LaTextField(
            fieldId: 'password',
            hint: 'Password',
            obscureText: true,
            onChanged: (val) => _password = val,
          ),
          const SizedBox(height: 16),
          LaButton(
            text: widget.submitLabel,
            onTap: widget.loading
                ? () {}
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onSubmit(_email, _password);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
