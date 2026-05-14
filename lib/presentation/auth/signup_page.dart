import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/presentation/auth/email_confirmation_dialog.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/l10n.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/setup.dart';

class SignupPage extends StatefulWidget {
  final UserPartnerProfile? partnerProfile;

  const SignupPage({
    super.key,
    this.partnerProfile,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isEmailConfirmationDialogVisible = false;
  BuildContext? _dialogContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (BuildContext context) => getIt<SignupCubit>(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listenWhen: (SignupState previous, SignupState current) => previous.status != current.status,
        listener: _onSignupStateChanged,
        builder: (BuildContext context, SignupState state) {
          return LaDefaultPageTemplate(
            child: LaAuthActionsOrganism(
              definition: LaAuthActionsDefinition(
                title: S.of(context).auth_signup_title,
                subtitle: S.of(context).auth_signup_subtitle,
                emailHint: S.of(context).auth_email_hint,
                passwordHint: S.of(context).auth_password_hint,
                emailSubmitText: S.of(context).auth_signup_email,
                googleText: S.of(context).auth_signup_google,
                appleText: S.of(context).auth_signup_apple,
                prompt: S.of(context).auth_signup_login_prompt,
                actionText: S.of(context).auth_signup_login_action,
                onEmailSubmit: (String email, String password) {
                  context.read<SignupCubit>().signupWithEmailAndPassword(email, password);
                },
                onGoogleTap: () => context.read<SignupCubit>().signupWithGoogle(),
                onAppleTap: () => context.read<SignupCubit>().signupWithApple(),
                onSwitchTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<LoginPage>(
                      builder: (BuildContext context) => LoginPage(partnerProfile: widget.partnerProfile),
                    ),
                  );
                },
                isLoading: state.status == SignupStatus.loading,
                errorMessage: state.status == SignupStatus.failure ? state.errorMessage : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSignupStateChanged(BuildContext context, SignupState state) async {
    if (state.status == SignupStatus.emailConfirmationRequired) {
      if (!_isEmailConfirmationDialogVisible) {
        await _showEmailConfirmationDialog(context);
      }
      return;
    }

    if (state.status == SignupStatus.sessionEstablished) {
      final NavigatorState navigator = Navigator.of(context);
      await _closeEmailConfirmationDialogIfNeeded();
      if (!mounted) {
        return;
      }
      await navigator.pushNamedAndRemoveUntil(PageName.main.route, (Route<dynamic> _) => false);
      return;
    }

    if (state.status == SignupStatus.idle && _isEmailConfirmationDialogVisible) {
      final NavigatorState navigator = Navigator.of(context);
      await _closeEmailConfirmationDialogIfNeeded();
      if (!mounted) {
        return;
      }
      await navigator.pushNamedAndRemoveUntil(PageName.landing.route, (Route<dynamic> _) => false);
    }
  }

  Future<void> _showEmailConfirmationDialog(BuildContext context) async {
    _isEmailConfirmationDialogVisible = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _dialogContext = dialogContext;
        return BlocProvider<SignupCubit>.value(
          value: context.read<SignupCubit>(),
          child: const EmailConfirmationDialog(),
        );
      },
    );

    _dialogContext = null;
    _isEmailConfirmationDialogVisible = false;
  }

  Future<void> _closeEmailConfirmationDialogIfNeeded() async {
    final BuildContext? dialogContext = _dialogContext;
    if (dialogContext == null) {
      return;
    }

    Navigator.of(dialogContext).pop();
    await Future<void>.delayed(Duration.zero);
    _dialogContext = null;
    _isEmailConfirmationDialogVisible = false;
  }
}
