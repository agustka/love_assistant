import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button_atom.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaEmailPasswordFormOrganism extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final String submitLabel;
  final bool loading;

  const LaEmailPasswordFormOrganism({
    super.key,
    required this.onSubmit,
    required this.submitLabel,
    this.loading = false,
  });

  @override
  State<LaEmailPasswordFormOrganism> createState() => _LaEmailPasswordFormOrganismState();
}

class _LaEmailPasswordFormOrganismState extends State<LaEmailPasswordFormOrganism> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          const SizedBox(height: LaPaddings.mediumSmall),
          LaTextField(
            fieldId: 'password',
            hint: 'Password',
            obscureText: true,
            onChanged: (val) => _password = val,
          ),
          const SizedBox(height: LaPaddings.medium),
          LaButtonAtom(
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
