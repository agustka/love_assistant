import "dart:async";

import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/auth_failure_reason.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/infrastructure/core/error_handling/error_handler.dart";
import "package:supabase_flutter/supabase_flutter.dart";

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._authService);

  final IAuthService _authService;
  StreamSubscription<AuthEventType>? _authStateSubscription;
  Stream<AuthEventType>? _broadcastAuthEvents;

  @override
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener}) {
    _authStateSubscription?.cancel();
    _authStateSubscription = observeAuthEvents().listen(listener);
  }

  @override
  Stream<AuthEventType> observeAuthEvents() {
    _broadcastAuthEvents ??= _authService.authStateChanges.asBroadcastStream();
    return _broadcastAuthEvents!;
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.logout");
    }
  }

  @override
  Future<Payload<AuthUserModel>> signUp(EmailPasswordCredentials credentials) async {
    final Failure? invalid = _firstFailure(credentials);
    if (invalid != null) {
      return Payload.failure(invalid);
    }
    try {
      final AuthUserModel model = await _authService.signUpWithEmailAndPassword(credentials);
      if (model.isNewUser == false) {
        return Payload.failure(_duplicateEmailFailure());
      }
      return Payload.success(model);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.signUp");
      return Payload.failure(_mapAuthFailure(ex, isSignUp: true));
    }
  }

  @override
  Future<Payload<AuthUserModel>> signIn(EmailPasswordCredentials credentials) async {
    final Failure? invalid = _firstFailure(credentials);
    if (invalid != null) {
      return Payload.failure(invalid);
    }
    try {
      final AuthUserModel model = await _authService.signInWithEmailAndPassword(credentials);
      return Payload.success(model);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.signIn");
      return Payload.failure(_mapAuthFailure(ex, isSignUp: false));
    }
  }

  @override
  Future<Payload<AuthUserModel>> recheckEmailConfirmation(EmailPasswordCredentials credentials) async {
    final Failure? invalid = _firstFailure(credentials);
    if (invalid != null) {
      return Payload.failure(invalid);
    }
    try {
      final AuthUserModel model = await _authService.recheckEmailConfirmation(credentials);
      if (model.emailConfirmed != true) {
        return Payload.failure(_notYetConfirmedFailure());
      }
      return Payload.success(model);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.recheckEmailConfirmation");
      return Payload.failure(_mapRecheckFailure(ex));
    }
  }

  @override
  Future<Payload<void>> resendConfirmationEmail(EmailPasswordCredentials credentials) async {
    final Failure? invalid = credentials.email.failure;
    if (invalid != null) {
      return Payload.failure(invalid);
    }
    try {
      await _authService.resendConfirmationEmail(credentials);
      return Payload.success(null);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.resendConfirmationEmail");
      return Payload.failure(_mapResendFailure(ex));
    }
  }

  Failure? _firstFailure(EmailPasswordCredentials credentials) {
    return credentials.email.failure ?? credentials.password.failure;
  }

  Failure<AuthFailureReason> _duplicateEmailFailure() {
    return const Failure(
      "An account with this email already exists.",
      reference: AuthFailureReason.emailAlreadyRegistered,
    );
  }

  Failure<AuthFailureReason> _notYetConfirmedFailure() {
    return const Failure(
      "I haven't seen your email confirmed yet. Check your inbox and try again.",
      reference: AuthFailureReason.notYetConfirmed,
    );
  }

  bool _isNetworkError(Object ex) {
    if (ex is! AuthException) {
      return false;
    }
    final String message = ex.message.toLowerCase();
    return ex.statusCode == "0" || message.contains("network") || message.contains("connection");
  }

  Failure<AuthFailureReason> _mapRecheckFailure(Object ex) {
    if (_isNetworkError(ex)) {
      return const Failure(
        "Could not reach the server. Check your internet connection.",
        reference: AuthFailureReason.networkError,
      );
    }
    return const Failure(
      "An unexpected error occurred. Please try again.",
      reference: AuthFailureReason.unexpectedError,
    );
  }

  Failure<AuthFailureReason> _mapResendFailure(Object ex) {
    if (ex is AuthException) {
      final String message = ex.message.toLowerCase();
      if (ex.statusCode == "429" || message.contains("rate limit") || message.contains("rate_limit")) {
        return const Failure(
          "Couldn't resend right now. Try again in a moment.",
          reference: AuthFailureReason.rateLimited,
        );
      }
    }
    if (_isNetworkError(ex)) {
      return const Failure(
        "Could not reach the server. Check your internet connection.",
        reference: AuthFailureReason.networkError,
      );
    }
    return const Failure(
      "An unexpected error occurred. Please try again.",
      reference: AuthFailureReason.unexpectedError,
    );
  }

  Failure<AuthFailureReason> _mapAuthFailure(Object ex, {required bool isSignUp}) {
    if (ex is! AuthException) {
      return const Failure(
        "An unexpected error occurred. Please try again.",
        reference: AuthFailureReason.unexpectedError,
      );
    }

    final String message = ex.message.toLowerCase();
    final String? statusCode = ex.statusCode;

    if (statusCode == "0" || message.contains("network") || message.contains("connection")) {
      return const Failure(
        "Could not reach the server. Check your internet connection.",
        reference: AuthFailureReason.networkError,
      );
    }

    if (message.contains("invalid email") || message.contains("email address is invalid")) {
      return const Failure(
        "The email address is not valid.",
        reference: AuthFailureReason.invalidEmail,
      );
    }

    if (isSignUp) {
      if (message.contains("password should be at least") || message.contains("weak password")) {
        return const Failure(
          "Password is too short. Please choose a stronger password.",
          reference: AuthFailureReason.weakOrShortPassword,
        );
      }
      if (message.contains("user already registered") || message.contains("email already") || statusCode == "422") {
        return _duplicateEmailFailure();
      }
    } else {
      if (message.contains("invalid login credentials") ||
          message.contains("invalid credentials") ||
          statusCode == "400") {
        return const Failure(
          "Incorrect email or password.",
          reference: AuthFailureReason.invalidCredentials,
        );
      }
    }

    return const Failure(
      "An unexpected error occurred. Please try again.",
      reference: AuthFailureReason.unexpectedError,
    );
  }
}
