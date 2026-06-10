import 'package:flutter/material.dart';
import 'package:la/domain/core/auth/value_objects/password_strength_evaluator.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';

class SignUpFormDefinition {
  final String title;
  final String subtitle;
  final String emailFieldId;
  final String passwordFieldId;
  final Key emailFieldKey;
  final Key emailEditableKey;
  final Key passwordFieldKey;
  final Key passwordEditableKey;
  final Key passwordVisibilityToggleKey;
  final Key emailErrorKey;
  final Key passwordErrorKey;
  final Key? formErrorKey;
  final String emailHeading;
  final String passwordHeading;
  final String emailHint;
  final String passwordHint;
  final PasswordStrength passwordStrength;
  final String? emailError;
  final String? passwordError;
  final String? formError;
  final bool busy;
  final void Function(String input) onEmailChanged;
  final void Function(String input) onPasswordChanged;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;
  final void Function()? onEmailSubmitted;
  final void Function()? onPasswordSubmitted;

  const SignUpFormDefinition({
    required this.title,
    required this.subtitle,
    required this.emailFieldId,
    required this.passwordFieldId,
    required this.emailFieldKey,
    required this.emailEditableKey,
    required this.passwordFieldKey,
    required this.passwordEditableKey,
    required this.passwordVisibilityToggleKey,
    required this.emailErrorKey,
    required this.passwordErrorKey,
    required this.formErrorKey,
    required this.emailHeading,
    required this.passwordHeading,
    required this.emailHint,
    required this.passwordHint,
    required this.passwordStrength,
    required this.emailError,
    required this.passwordError,
    required this.formError,
    required this.busy,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.emailFocusNode,
    this.passwordFocusNode,
    this.onEmailSubmitted,
    this.onPasswordSubmitted,
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
      spacing: LaPadding.large,
      children: [
        _Heading(title: definition.title, subtitle: definition.subtitle),
        _EmailCard(definition: definition),
        _PasswordCard(definition: definition),
        _FormError(key: definition.formErrorKey, message: definition.formError),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Heading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        LaTextAtom(
          title,
          style: LaTextAtomStyle.body24.bold,
          textAlign: TextAlign.center,
        ),
        const LaSizedBoxAtom(height: LaPadding.small),
        LaTextAtom(
          subtitle,
          style: LaTextAtomStyle.body16.light,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmailCard extends StatelessWidget {
  final SignUpFormDefinition definition;

  const _EmailCard({required this.definition});

  @override
  Widget build(BuildContext context) {
    return LaTextField(
      key: definition.emailFieldKey,
      fieldId: definition.emailFieldId,
      editableKey: definition.emailEditableKey,
      title: definition.emailHeading,
      hint: definition.emailHint,
      optional: false,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: false,
      enabled: !definition.busy,
      onChanged: definition.onEmailChanged,
      focusNode: definition.emailFocusNode,
      autofocus: true,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => definition.onEmailSubmitted?.call(),
      belowField: definition.emailError != null
          ? _FieldError(key: definition.emailErrorKey, message: definition.emailError)
          : null,
    );
  }
}

class _PasswordCard extends StatelessWidget {
  final SignUpFormDefinition definition;

  const _PasswordCard({required this.definition});

  @override
  Widget build(BuildContext context) {
    return LaTextField(
      key: definition.passwordFieldKey,
      fieldId: definition.passwordFieldId,
      editableKey: definition.passwordEditableKey,
      title: definition.passwordHeading,
      hint: definition.passwordHint,
      optional: false,
      obscureText: true,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: false,
      obscureTextToggle: true,
      obscureTextToggleKey: definition.passwordVisibilityToggleKey,
      enabled: !definition.busy,
      onChanged: definition.onPasswordChanged,
      focusNode: definition.passwordFocusNode,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => definition.onPasswordSubmitted?.call(),
      belowField: LaColumnAtom(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const LaSizedBoxAtom(height: LaPadding.small),
          LaPasswordStrengthMolecule(strength: definition.passwordStrength),
          _FieldError(key: definition.passwordErrorKey, message: definition.passwordError),
        ],
      ),
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
      top: LaPadding.small,
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
