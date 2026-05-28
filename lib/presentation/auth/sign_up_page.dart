import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/sign_up_cubit.dart';
import 'package:la/presentation/auth/widgets/sign_up_form_organism.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_auth_template.dart';
import 'package:la/setup.dart';

class SignUpPage extends StatelessWidget {
  static const Key pageKey = Key("SignUpPage_page");
  static const Key emailFieldKey = Key("sign_up_email_field");
  static const Key passwordFieldKey = Key("sign_up_password_field");
  static const Key submitButtonKey = Key("sign_up_submit_button");
  static const Key emailErrorKey = Key("sign_up_email_error");
  static const Key passwordErrorKey = Key("sign_up_password_error");
  static const Key formErrorKey = Key("sign_up_form_error");

  static const String emailFieldId = "sign_up_email_field";
  static const String passwordFieldId = "sign_up_password_field";

  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (BuildContext context) {
        return getIt<SignUpCubit>();
      },
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (BuildContext context, SignUpState state) {
          return LaEventBusListener<SignUpNavigateToConfirmationEvent>(
            onMessage: (SignUpNavigateToConfirmationEvent event) => _onNavigateToConfirmation(context, event),
            child: LaAuthTemplate(
              key: SignUpPage.pageKey,
              title: S.of(context).auth_signup_title,
              subtitle: S.of(context).auth_signup_subtitle,
              child: SignUpFormOrganism(
                definition: _formDefinition(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onNavigateToConfirmation(BuildContext context, SignUpNavigateToConfirmationEvent event) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(
      PageName.emailConfirmation.route,
      arguments: event.credentials,
    );
  }

  SignUpFormDefinition _formDefinition(BuildContext context, SignUpState state) {
    final S strings = S.of(context);
    final SignUpCubit cubit = context.read<SignUpCubit>();

    return SignUpFormDefinition(
      emailFieldId: SignUpPage.emailFieldId,
      passwordFieldId: SignUpPage.passwordFieldId,
      emailFieldKey: SignUpPage.emailFieldKey,
      passwordFieldKey: SignUpPage.passwordFieldKey,
      submitButtonKey: SignUpPage.submitButtonKey,
      emailErrorKey: SignUpPage.emailErrorKey,
      passwordErrorKey: SignUpPage.passwordErrorKey,
      formErrorKey: SignUpPage.formErrorKey,
      emailHint: strings.auth_email_hint,
      passwordHint: strings.auth_password_hint,
      submitLabel: strings.auth_signup_action,
      passwordStrength: state.passwordStrength,
      emailError: state.emailError ? strings.auth_signup_email_invalid : null,
      passwordError: _passwordError(strings, state),
      formError: _formError(strings, state.formError),
      busy: state.isSubmitting,
      onEmailChanged: cubit.onEmailChanged,
      onPasswordChanged: cubit.onPasswordChanged,
      onSubmit: cubit.signUp,
    );
  }

  String? _passwordError(S strings, SignUpState state) {
    if (!state.passwordError) {
      return null;
    }
    if (state.password.isEmpty) {
      return strings.auth_signup_password_empty;
    }
    return strings.auth_signup_password_too_short;
  }

  String? _formError(S strings, SignUpFormError error) {
    switch (error) {
      case SignUpFormError.none:
        return null;
      case SignUpFormError.emailAlreadyRegistered:
        return strings.auth_signup_error_email_exists;
      case SignUpFormError.network:
        return strings.auth_error_network;
      case SignUpFormError.unexpected:
        return strings.auth_error_unexpected;
    }
  }
}
