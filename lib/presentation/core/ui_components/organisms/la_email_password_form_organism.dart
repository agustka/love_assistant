import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class LaEmailPasswordFormOrganism extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final String emailHint;
  final String passwordHint;
  final String submitLabel;
  final bool loading;

  const LaEmailPasswordFormOrganism({
    super.key,
    required this.onSubmit,
    required this.emailHint,
    required this.passwordHint,
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

  bool get _canSubmit => _email.trim().isNotEmpty && _password.isNotEmpty && !widget.loading;

  @override
  Widget build(BuildContext context) {
    return LaFormAtom(
      formKey: _formKey,
      child: LaColumnAtom(
        children: [
          LaTextField(
            fieldId: "email",
            hint: widget.emailHint,
            keyboardType: TextInputType.emailAddress,
            onChanged: (String val) => setState(() => _email = val),
          ),
          const LaSizedBoxAtom(height: LaPadding.mediumSmall),
          LaTextField(
            fieldId: "password",
            hint: widget.passwordHint,
            obscureText: true,
            onChanged: (String val) => setState(() => _password = val),
          ),
          const LaSizedBoxAtom(height: LaPadding.medium),
          LaButtonAtom(
            text: widget.submitLabel,
            busy: widget.loading,
            enabled: _canSubmit,
            onTap: () => widget.onSubmit(_email.trim(), _password),
          ),
        ],
      ),
    );
  }
}
