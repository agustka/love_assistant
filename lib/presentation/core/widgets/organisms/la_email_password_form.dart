import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/atoms/la_text_field.dart';
import 'package:la/presentation/core/widgets/atoms/la_button.dart';

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
            validator: (val) => val != null && val.contains('@') ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 12),
          LaTextField(
            fieldId: 'password',
            hint: 'Password',
            obscureText: true,
            onChanged: (val) => _password = val,
            validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 characters',
          ),
          const SizedBox(height: 16),
          LaButton(
            label: widget.submitLabel,
            onPressed: widget.loading
                ? null
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