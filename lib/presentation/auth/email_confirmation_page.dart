import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/auth/email_confirmation_cubit.dart';
import 'package:la/domain/core/entities/email_password_credentials.dart';
import 'package:la/presentation/auth/widgets/email_confirmation_organism.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/templates/la_auth_template.dart';
import 'package:la/setup.dart';

enum _ResendOutcome {
  succeeded,
  failed,
}

class EmailConfirmationPage extends StatefulWidget {
  static const Key confirmButtonKey = Key("email_confirmation_confirm_button");
  static const Key confirmLoadingKey = Key("email_confirmation_confirm_loading");
  static const Key resendButtonKey = Key("email_confirmation_resend_button");
  static const Key pendingErrorKey = Key("email_confirmation_pending_error");
  static const Key networkErrorKey = Key("email_confirmation_network_error");
  static const Key resendSuccessKey = Key("email_confirmation_resend_success");
  static const Key resendErrorKey = Key("email_confirmation_resend_error");

  const EmailConfirmationPage({super.key});

  @override
  State<EmailConfirmationPage> createState() {
    return _EmailConfirmationPageState();
  }
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
  _ResendOutcome? _resendOutcome;

  @override
  Widget build(BuildContext context) {
    final EmailPasswordCredentials credentials =
        ModalRoute.of(context)?.settings.arguments as EmailPasswordCredentials? ?? EmailPasswordCredentials.empty();

    return BlocProvider<EmailConfirmationCubit>(
      create: (BuildContext context) {
        return getIt<EmailConfirmationCubit>()..init(credentials);
      },
      child: BlocBuilder<EmailConfirmationCubit, EmailConfirmationState>(
        builder: (BuildContext context, EmailConfirmationState state) {
          return LaMultiEventBusListener(
            listeners: [
              LaTypedEventBusListenerDefinition<EmailConfirmationNavigateToMainEvent>(
                onMessage: (EmailConfirmationNavigateToMainEvent event) => _onNavigateToMain(context),
              ),
              LaTypedEventBusListenerDefinition<EmailConfirmationResendSucceededEvent>(
                onMessage: (EmailConfirmationResendSucceededEvent event) => _onResendOutcome(_ResendOutcome.succeeded),
              ),
              LaTypedEventBusListenerDefinition<EmailConfirmationResendFailedEvent>(
                onMessage: (EmailConfirmationResendFailedEvent event) => _onResendOutcome(_ResendOutcome.failed),
              ),
            ],
            child: LaAuthTemplate(
              title: S.of(context).auth_email_confirmation_title,
              child: EmailConfirmationOrganism(
                definition: _definition(context, state),
              ),
            ),
          );
        },
      ),
    );
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

  void _onResendOutcome(_ResendOutcome outcome) {
    if (!mounted) {
      return;
    }
    setState(() {
      _resendOutcome = outcome;
    });
  }

  EmailConfirmationDefinition _definition(BuildContext context, EmailConfirmationState state) {
    final S strings = S.of(context);
    final EmailConfirmationCubit cubit = context.read<EmailConfirmationCubit>();

    return EmailConfirmationDefinition(
      message: strings.auth_email_confirmation_message,
      confirmLabel: strings.auth_email_confirmation_confirmed,
      resendLabel: _resendLabel(strings, state),
      confirmButtonKey: state.isRechecking
          ? EmailConfirmationPage.confirmLoadingKey
          : EmailConfirmationPage.confirmButtonKey,
      resendButtonKey: EmailConfirmationPage.resendButtonKey,
      isRechecking: state.isRechecking,
      resendEnabled: state.resendEnabled,
      recheckMessage: _recheckMessage(strings, state.recheckMessage),
      resendMessage: _resendMessage(strings),
      onConfirm: cubit.recheckEmailConfirmation,
      onResend: () {
        setState(() {
          _resendOutcome = null;
        });
        cubit.resendConfirmationEmail();
      },
    );
  }

  String _resendLabel(S strings, EmailConfirmationState state) {
    if (!state.resendEnabled && state.cooldownRemaining > 0) {
      return strings.auth_email_confirmation_resend_cooldown(state.cooldownRemaining);
    }
    return strings.auth_email_confirmation_resend;
  }

  EmailConfirmationMessage? _recheckMessage(S strings, RecheckMessage message) {
    switch (message) {
      case RecheckMessage.none:
        return null;
      case RecheckMessage.pending:
        return EmailConfirmationMessage(
          key: EmailConfirmationPage.pendingErrorKey,
          text: strings.auth_email_confirmation_pending_error,
          tone: EmailConfirmationMessageTone.pending,
        );
      case RecheckMessage.network:
        return EmailConfirmationMessage(
          key: EmailConfirmationPage.networkErrorKey,
          text: strings.auth_error_network,
          tone: EmailConfirmationMessageTone.error,
        );
      case RecheckMessage.unexpected:
        return EmailConfirmationMessage(
          key: EmailConfirmationPage.networkErrorKey,
          text: strings.auth_error_unexpected,
          tone: EmailConfirmationMessageTone.error,
        );
    }
  }

  EmailConfirmationMessage? _resendMessage(S strings) {
    final _ResendOutcome? outcome = _resendOutcome;
    switch (outcome) {
      case null:
        return null;
      case _ResendOutcome.succeeded:
        return EmailConfirmationMessage(
          key: EmailConfirmationPage.resendSuccessKey,
          text: strings.auth_email_confirmation_resend_success,
          tone: EmailConfirmationMessageTone.success,
        );
      case _ResendOutcome.failed:
        return EmailConfirmationMessage(
          key: EmailConfirmationPage.resendErrorKey,
          text: strings.auth_email_confirmation_resend_error,
          tone: EmailConfirmationMessageTone.error,
        );
    }
  }
}
