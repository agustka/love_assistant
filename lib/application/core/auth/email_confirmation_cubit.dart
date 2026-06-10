import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/auth/use_cases/create_confirmation_email_use_case.dart';
import 'package:la/domain/core/auth/use_cases/get_email_confirmation_use_case.dart';
import 'package:la/domain/core/auth/use_cases/watch_auth_events_use_case.dart';
import 'package:la/domain/core/entities/email_password_credentials.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/core/value_objects/stream_payload.dart';
import "package:la/domain/wizard/use_cases/sync_authenticated_partner_profile_use_case.dart";
import 'package:la/infrastructure/core/auth/auth_event_type.dart';
import 'package:la/infrastructure/core/auth/auth_failure_reason.dart';
import 'package:la/infrastructure/core/auth/models/auth_user_model.dart';
import 'package:la/setup.dart';

part 'email_confirmation_state.dart';

@injectable
class EmailConfirmationCubit extends BaseCubit<EmailConfirmationState> {
  static const Duration _resendCooldown = Duration(seconds: 45);
  static const Duration _cooldownTick = Duration(seconds: 1);

  final GetEmailConfirmationUseCase _getEmailConfirmationUseCase;
  final CreateConfirmationEmailUseCase _createConfirmationEmailUseCase;
  final WatchAuthEventsUseCase _watchAuthEventsUseCase;
  final SyncAuthenticatedPartnerProfileUseCase _syncAuthenticatedPartnerProfileUseCase;

  StreamSubscription<StreamPayload<AuthEventType>>? _authEventsSubscription;
  Timer? _cooldownTimer;

  EmailConfirmationCubit(
    this._getEmailConfirmationUseCase,
    this._createConfirmationEmailUseCase,
    this._watchAuthEventsUseCase,
    this._syncAuthenticatedPartnerProfileUseCase,
  ) : super(EmailConfirmationState.initial());

  void init(EmailPasswordCredentials credentials) {
    emit(state.copyWith(credentials: credentials));
    _authEventsSubscription?.cancel();
    _authEventsSubscription = _watchAuthEventsUseCase.subscribe().listen(_receiveAuthEvent);
  }

  Future<void> recheckEmailConfirmation() async {
    final EmailPasswordCredentials credentials = state.credentials;
    if (state.status == EmailConfirmationStatus.rechecking || credentials.isInvalid) {
      return;
    }

    emit(state.copyWith(status: EmailConfirmationStatus.rechecking, recheckMessage: RecheckMessage.none));

    final Payload<AuthUserModel> result = await _getEmailConfirmationUseCase.execute(credentials);

    if (result.succeeded) {
      emit(state.copyWith(status: EmailConfirmationStatus.confirmed));
      await _syncAuthenticatedPartnerProfileUseCase.execute();
      getIt<EventBus>().fire(const EmailConfirmationNavigateToMainEvent());
      return;
    }

    _handleRecheckFailure(result.failure?.reference);
  }

  Future<void> resendConfirmationEmail() async {
    final EmailPasswordCredentials credentials = state.credentials;
    if (!state.resendEnabled || credentials.isInvalid) {
      return;
    }

    emit(state.copyWith(resendEnabled: false));

    final Payload<void> result = await _createConfirmationEmailUseCase.execute(credentials);

    if (result.succeeded) {
      getIt<EventBus>().fire(const EmailConfirmationResendSucceededEvent());
      _startResendCooldown();
      return;
    }

    emit(state.copyWith(resendEnabled: true));
    getIt<EventBus>().fire(const EmailConfirmationResendFailedEvent());
  }

  Future<void> _receiveAuthEvent(StreamPayload<AuthEventType> payload) async {
    final AuthEventType? event = payload.dataOrNull;
    if (event == null) {
      return;
    }
    if (event == AuthEventType.login && state.status != EmailConfirmationStatus.confirmed) {
      emit(state.copyWith(status: EmailConfirmationStatus.confirmed));
      await _syncAuthenticatedPartnerProfileUseCase.execute();
      getIt<EventBus>().fire(const EmailConfirmationNavigateToMainEvent());
    }
  }

  void _handleRecheckFailure(Object? reference) {
    final AuthFailureReason reason = reference is AuthFailureReason ? reference : AuthFailureReason.unexpectedError;
    switch (reason) {
      case AuthFailureReason.notYetConfirmed:
        emit(state.copyWith(status: EmailConfirmationStatus.idle, recheckMessage: RecheckMessage.pending));
      case AuthFailureReason.networkError:
        emit(state.copyWith(status: EmailConfirmationStatus.idle, recheckMessage: RecheckMessage.network));
      case AuthFailureReason.invalidEmail:
      case AuthFailureReason.weakOrShortPassword:
      case AuthFailureReason.emailAlreadyRegistered:
      case AuthFailureReason.invalidCredentials:
      case AuthFailureReason.rateLimited:
      case AuthFailureReason.unexpectedError:
        emit(state.copyWith(status: EmailConfirmationStatus.idle, recheckMessage: RecheckMessage.unexpected));
    }
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    emit(state.copyWith(resendEnabled: false, cooldownRemaining: _resendCooldown.inSeconds));
    _cooldownTimer = Timer.periodic(_cooldownTick, (Timer timer) {
      final int remaining = state.cooldownRemaining - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(resendEnabled: true, cooldownRemaining: 0));
        return;
      }
      emit(state.copyWith(cooldownRemaining: remaining));
    });
  }

  @override
  Future<void> close() {
    _authEventsSubscription?.cancel();
    _cooldownTimer?.cancel();
    return super.close();
  }
}
