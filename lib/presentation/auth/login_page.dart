import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/login_cubit.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/presentation/auth/widgets/login_form_organism.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/ui_components/definitions/la_language_app_bar_action_definition.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/core/ui_components/templates/la_default_page_template.dart';
import 'package:la/setup.dart';

class LoginPage extends StatefulWidget {
  static const Key pageKey = Key("LoginPage_page");
  static const Key emailFieldKey = Key("login_email_field");
  static const Key emailEditableKey = Key("login_email_editable");
  static const Key passwordFieldKey = Key("login_password_field");
  static const Key passwordEditableKey = Key("login_password_editable");
  static const Key passwordVisibilityToggleKey = Key("login_password_visibility_toggle");
  static const Key submitButtonKey = Key("login_submit_button");
  static const Key emailErrorKey = Key("login_email_error");
  static const Key passwordErrorKey = Key("login_password_error");
  static const Key formErrorKey = Key("login_form_error");
  static const Key signUpPromptKey = Key("login_sign_up_prompt");
  static const Key signUpActionKey = Key("login_sign_up_action");

  static const String emailFieldId = "login_email_field";
  static const String passwordFieldId = "login_password_field";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
    return BlocProvider<LoginCubit>(
      create: (BuildContext context) {
        return getIt<LoginCubit>();
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (BuildContext context, LoginState state) {
          return LaMultiEventBusListener(
            listeners: [
              LaTypedEventBusListenerDefinition<LoginNavigateToMainEvent>(
                onMessage: (LoginNavigateToMainEvent event) => _onNavigateToMain(context),
              ),
              LaTypedEventBusListenerDefinition<LoginNavigateToEmailConfirmationEvent>(
                onMessage: (LoginNavigateToEmailConfirmationEvent event) =>
                    _onNavigateToEmailConfirmation(context, event),
              ),
              LaTypedEventBusListenerDefinition<LoginEvent>(onMessage: _onLoginEvent),
            ],
            child: LaDefaultPageTemplate(
              paddingPreset: LaDefaultPageTemplatePadding.medium,
              appBar: LaAppBarOrganism(
                style: AppBarStyle.background,
                action: LaLanguageAppBarActionDefinition(
                  onTap: () => _showLanguagePicker(context),
                  showsIcon: false,
                ),
              ),
              bottomButtons: _bottomButtons(context, state),
              child: LoginFormOrganism(
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

  void _onLoginEvent(LoginEvent event) {
    switch (event) {
      case LoginEvent.ensureEmailVisible:
        _emailFocusNode.requestFocus();
      case LoginEvent.ensurePasswordVisible:
        _passwordFocusNode.requestFocus();
    }
  }

  Future<void> _onNavigateToMain(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).pushNamedAndRemoveUntil(
      PageName.main.route,
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _onNavigateToEmailConfirmation(
    BuildContext context,
    LoginNavigateToEmailConfirmationEvent event,
  ) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(
      PageName.emailConfirmation.route,
      arguments: event.credentials,
    );
  }

  BottomButtonsDefinition _bottomButtons(BuildContext context, LoginState state) {
    final S strings = S.of(context);
    final LoginCubit cubit = context.read<LoginCubit>();
    final bool showAccessoryBar = defaultTargetPlatform == TargetPlatform.iOS && (_emailFocused || _passwordFocused);

    return BottomButtonsDefinition(
      buttons: [
        BottomButtonDefinition(
          key: LoginPage.submitButtonKey,
          text: strings.auth_login_action,
          busy: state.isSubmitting,
          enabled: !state.isSubmitting,
          onTap: cubit.login,
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

  LoginFormDefinition _formDefinition(BuildContext context, LoginState state) {
    final S strings = S.of(context);
    final LoginCubit cubit = context.read<LoginCubit>();

    return LoginFormDefinition(
      title: strings.auth_login_title,
      subtitle: strings.auth_login_subtitle,
      emailFieldId: LoginPage.emailFieldId,
      passwordFieldId: LoginPage.passwordFieldId,
      emailFieldKey: LoginPage.emailFieldKey,
      emailEditableKey: LoginPage.emailEditableKey,
      passwordFieldKey: LoginPage.passwordFieldKey,
      passwordEditableKey: LoginPage.passwordEditableKey,
      passwordVisibilityToggleKey: LoginPage.passwordVisibilityToggleKey,
      emailErrorKey: LoginPage.emailErrorKey,
      passwordErrorKey: LoginPage.passwordErrorKey,
      formErrorKey: LoginPage.formErrorKey,
      emailHeading: strings.auth_email_hint,
      passwordHeading: strings.auth_password_hint,
      emailHint: strings.auth_email_placeholder,
      passwordHint: strings.auth_password_placeholder,
      emailError: state.emailError ? strings.auth_login_email_invalid : null,
      passwordError: _passwordError(strings, state),
      formError: _formError(strings, state.formError),
      signUpPrompt: strings.auth_login_signup_prompt,
      signUpAction: strings.auth_login_signup_action,
      signUpPromptKey: LoginPage.signUpPromptKey,
      signUpActionKey: LoginPage.signUpActionKey,
      onSignUp: _onSignUp,
      busy: state.isSubmitting,
      onEmailChanged: cubit.onEmailChanged,
      onPasswordChanged: cubit.onPasswordChanged,
      emailFocusNode: _emailFocusNode,
      passwordFocusNode: _passwordFocusNode,
      onEmailSubmitted: _advanceToPassword,
      onPasswordSubmitted: cubit.login,
    );
  }

  void _onSignUp() {
    Navigator.of(context).pushNamed(PageName.signUp.route);
  }

  void _showLanguagePicker(BuildContext context) {
    LaPicker.showPicker(
      context,
      entries: PickerEntries(
        title: S.of(context).settings_pick_language,
        entries: _availableLanguages
            .map(
              (Language language) => PickerEntry(
                text: language.properName,
                svg: language.flagIcon,
                onTap: () {
                  context.read<LanguageCubit>().setLanguage(language);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  List<Language> get _availableLanguages {
    return Language.values.where((Language language) => language != Language.invalid).toList();
  }

  String? _passwordError(S strings, LoginState state) {
    if (!state.passwordError) {
      return null;
    }
    if (state.password.isEmpty) {
      return strings.auth_login_password_empty;
    }
    return strings.auth_login_password_too_short;
  }

  String? _formError(S strings, LoginFormError error) {
    switch (error) {
      case LoginFormError.none:
        return null;
      case LoginFormError.invalidCredentials:
        return strings.auth_login_error_invalid_credentials;
      case LoginFormError.network:
        return strings.auth_error_network;
      case LoginFormError.unexpected:
        return strings.auth_error_unexpected;
    }
  }
}
