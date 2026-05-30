import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/sign_up_cubit.dart';
import 'package:la/presentation/auth/widgets/sign_up_form_organism.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/setup.dart';

class SignUpPage extends StatefulWidget {
  static const Key pageKey = Key("SignUpPage_page");
  static const Key emailFieldKey = Key("sign_up_email_field");
  static const Key passwordFieldKey = Key("sign_up_password_field");
  static const Key passwordVisibilityToggleKey = Key("sign_up_password_visibility_toggle");
  static const Key submitButtonKey = Key("sign_up_submit_button");
  static const Key emailErrorKey = Key("sign_up_email_error");
  static const Key passwordErrorKey = Key("sign_up_password_error");
  static const Key formErrorKey = Key("sign_up_form_error");

  static const String emailFieldId = "sign_up_email_field";
  static const String passwordFieldId = "sign_up_password_field";

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool _emailFocused = false;
  bool _passwordFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _emailFocusNode.addListener(_onFocusChanged);
    _passwordFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChanged);
    _passwordFocusNode.removeListener(_onFocusChanged);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
            child: LaDefaultPageTemplate(
              key: SignUpPage.pageKey,
              padding: const EdgeInsets.symmetric(horizontal: LaPadding.medium, vertical: LaPadding.medium),
              appBar: const LaAppBarOrganism(
                style: AppBarStyle.background,
              ),
              bottomButtons: _bottomButtons(context, state),
              child: SignUpFormOrganism(
                definition: _formDefinition(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onFocusChanged() {
    setState(() {
      _emailFocused = _emailFocusNode.hasFocus;
      _passwordFocused = _passwordFocusNode.hasFocus;
    });
  }

  void _advanceToPassword() {
    _passwordFocusNode.requestFocus();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
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

  BottomButtonsDefinition _bottomButtons(BuildContext context, SignUpState state) {
    final S strings = S.of(context);
    final SignUpCubit cubit = context.read<SignUpCubit>();

    // The iOS accessory toolbar sits below the submit button (just above the keyboard) via
    // belowButtonsWidget, so the on-screen order (top → bottom) is: submit button, toolbar, keyboard.
    //
    // Platform detection uses defaultTargetPlatform (not PlatformDetector.isIOS / dart:io)
    // so the toolbar is exercisable under a test platform override. This is a spec-mandated
    // departure from the codebase's PlatformDetector convention — do not revert to PlatformDetector.
    final bool showAccessoryBar =
        defaultTargetPlatform == TargetPlatform.iOS && (_emailFocused || _passwordFocused);

    return BottomButtonsDefinition(
      buttons: [
        BottomButtonDefinition(
          key: SignUpPage.submitButtonKey,
          text: strings.auth_signup_action,
          busy: state.isSubmitting,
          enabled: !state.isSubmitting,
          onTap: cubit.signUp,
        ),
      ],
      belowButtonsWidget: showAccessoryBar
          ? LaKeyboardAccessoryBarMolecule(
              actionLabel: _emailFocused ? strings.wizard_next : strings.global_done,
              onActionPressed: _emailFocused ? _advanceToPassword : _dismissKeyboard,
            )
          : null,
    );
  }

  SignUpFormDefinition _formDefinition(BuildContext context, SignUpState state) {
    final S strings = S.of(context);
    final SignUpCubit cubit = context.read<SignUpCubit>();

    return SignUpFormDefinition(
      title: strings.auth_signup_title,
      subtitle: strings.auth_signup_subtitle,
      emailFieldId: SignUpPage.emailFieldId,
      passwordFieldId: SignUpPage.passwordFieldId,
      emailFieldKey: SignUpPage.emailFieldKey,
      passwordFieldKey: SignUpPage.passwordFieldKey,
      passwordVisibilityToggleKey: SignUpPage.passwordVisibilityToggleKey,
      emailErrorKey: SignUpPage.emailErrorKey,
      passwordErrorKey: SignUpPage.passwordErrorKey,
      formErrorKey: SignUpPage.formErrorKey,
      emailHeading: strings.auth_email_hint,
      passwordHeading: strings.auth_password_hint,
      emailHint: strings.auth_email_placeholder,
      passwordHint: strings.auth_password_placeholder,
      passwordStrength: state.passwordStrength,
      emailError: state.emailError ? strings.auth_signup_email_invalid : null,
      passwordError: _passwordError(strings, state),
      formError: _formError(strings, state.formError),
      busy: state.isSubmitting,
      onEmailChanged: cubit.onEmailChanged,
      onPasswordChanged: cubit.onPasswordChanged,
      emailFocusNode: _emailFocusNode,
      passwordFocusNode: _passwordFocusNode,
      onEmailSubmitted: _advanceToPassword,
      onPasswordSubmitted: cubit.signUp,
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
