import "dart:async";

import "package:injectable/injectable.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/domain/core/repositories/i_auth_repository.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/infrastructure/core/auth/auth_event_type.dart";
import "package:la/infrastructure/core/auth/models/auth_user_model.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/infrastructure/core/error_handling/error_handler.dart";
import "package:supabase_flutter/supabase_flutter.dart";

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._authService);

  final IAuthService _authService;
  StreamSubscription<AuthEventType>? _authStateSubscription;

  @override
  void subscribeToAuthEvents({required Future<dynamic> Function(AuthEventType event) listener}) {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authService.authStateChanges.listen(listener);
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
  Future<Payload<bool>> hasActiveSession() async {
    try {
      final bool active = await _authService.hasActiveSession();
      return Payload.success(active);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "AuthRepository.hasActiveSession");
      return Payload.failure(const Failure("Failed to read auth session"));
    }
  }

  Failure? _firstFailure(EmailPasswordCredentials credentials) {
    return credentials.email.failure ?? credentials.password.failure;
  }

  Failure _mapAuthFailure(Object ex, {required bool isSignUp}) {
    if (ex is! AuthException) {
      return const Failure("An unexpected error occurred. Please try again.");
    }

    final String message = ex.message.toLowerCase();
    final String? statusCode = ex.statusCode;

    if (statusCode == "0" || message.contains("network") || message.contains("connection")) {
      return const Failure("Could not reach the server. Check your internet connection.");
    }

    if (message.contains("invalid email") || message.contains("email address is invalid")) {
      return const Failure("The email address is not valid.");
    }

    if (isSignUp) {
      if (message.contains("password should be at least") || message.contains("weak password")) {
        return const Failure("Password is too short. Please choose a stronger password.");
      }
      if (message.contains("user already registered") || message.contains("email already") || statusCode == "422") {
        return const Failure("An account with this email already exists.");
      }
    } else {
      if (message.contains("invalid login credentials") ||
          message.contains("invalid credentials") ||
          statusCode == "400") {
        return const Failure("Incorrect email or password.");
      }
    }

    return const Failure("Sign in failed. Please try again.");
  }
}
