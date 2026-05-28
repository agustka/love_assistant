import 'package:flutter/material.dart';
import 'package:la/domain/core/auth/value_objects/password_strength_evaluator.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class SignUpFormDefinition {
  final String emailFieldId;
  final String passwordFieldId;
  final Key emailFieldKey;
  final Key passwordFieldKey;
  final Key submitButtonKey;
  final Key emailErrorKey;
  final Key passwordErrorKey;
  final Key? formErrorKey;
  final String emailHint;
  final String passwordHint;
  final String submitLabel;
  final PasswordStrength passwordStrength;
  final String? emailError;
  final String? passwordError;
  final String? formError;
  final bool busy;
  final void Function(String input) onEmailChanged;
  final void Function(String input) onPasswordChanged;
  final VoidCallback onSubmit;

  const SignUpFormDefinition({
    required this.emailFieldId,
    required this.passwordFieldId,
    required this.emailFieldKey,
    required this.passwordFieldKey,
    required this.submitButtonKey,
    required this.emailErrorKey,
    required this.passwordErrorKey,
    required this.formErrorKey,
    required this.emailHint,
    required this.passwordHint,
    required this.submitLabel,
    required this.passwordStrength,
    required this.emailError,
    required this.passwordError,
    required this.formError,
    required this.busy,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
  });
}

class SignUpFormOrganism extends StatelessWidget {
  final SignUpFormDefinition definition;

  const SignUpFormOrganism({
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
        LaTextField(
          key: definition.emailFieldKey,
          fieldId: definition.emailFieldId,
          hint: definition.emailHint,
          keyboardType: TextInputType.emailAddress,
          enabled: !definition.busy,
          showCard: false,
          onChanged: definition.onEmailChanged,
        ),
        _FieldError(key: definition.emailErrorKey, message: definition.emailError),
        LaTextField(
          key: definition.passwordFieldKey,
          fieldId: definition.passwordFieldId,
          hint: definition.passwordHint,
          obscureText: true,
          enabled: !definition.busy,
          showCard: false,
          onChanged: definition.onPasswordChanged,
        ),
        LaPasswordStrengthMolecule(strength: definition.passwordStrength),
        _FieldError(key: definition.passwordErrorKey, message: definition.passwordError),
        LaButtonAtom(
          key: definition.submitButtonKey,
          text: definition.submitLabel,
          busy: definition.busy,
          enabled: !definition.busy,
          onTap: definition.onSubmit,
        ),
        _FormError(key: definition.formErrorKey, message: definition.formError),
      ],
    );
  }
}

class _FieldError extends StatelessWidget {
  final String? message;

  const _FieldError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String? text = message;
    if (text == null) {
      return const LaSizedBoxAtom.shrink();
    }
    return LaPaddingAtom.only(
      left: LaPadding.extraSmall,
      child: LaTextAtom(
        text,
        style: LaTextAtomStyle.body12.primary,
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  final String? message;

  const _FormError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String? text = message;
    if (text == null) {
      return const LaSizedBoxAtom.shrink();
    }
    return LaContainerAtom(
      padding: const EdgeInsets.all(LaPadding.mediumSmall),
      decoration: BoxDecoration(
        color: LaTheme.error(),
        borderRadius: BorderRadius.circular(LaCornerRadius.mediumSmall),
      ),
      child: LaTextAtom(
        text,
        style: LaTextAtomStyle.body14.onError,
        textAlign: TextAlign.center,
      ),
    );
  }
}
