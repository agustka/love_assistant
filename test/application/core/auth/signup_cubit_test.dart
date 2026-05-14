import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:la/application/core/auth/signup_cubit.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SignupCubit', () {
    late _FakeAuthRepository authRepository;
    late SignupCubit cubit;
    late StreamSubscription<SignupState> subscription;
    late List<SignupState> emittedStates;

    setUp(() {
      authRepository = _FakeAuthRepository();
      cubit = SignupCubit(authRepository);
      emittedStates = <SignupState>[];
      subscription = cubit.stream.listen(emittedStates.add);
    });

    tearDown(() async {
      await subscription.cancel();
      await cubit.close();
      await authRepository.dispose();
    });

    test('emits emailConfirmationRequired when signup succeeds without a session', () async {
      authRepository.signupResult = false;

      await cubit.signupWithEmailAndPassword('test@example.com', 'password123');
      await _settleStream();

      expect(
        emittedStates,
        <SignupState>[
          const SignupState(
            status: SignupStatus.loading,
            isCheckingEmailConfirmation: false,
          ),
          const SignupState(
            status: SignupStatus.emailConfirmationRequired,
            isCheckingEmailConfirmation: false,
          ),
        ],
      );
    });

    test('emits sessionEstablished when signup succeeds with an active session', () async {
      authRepository.signupResult = true;

      await cubit.signupWithEmailAndPassword('test@example.com', 'password123');
      await _settleStream();

      expect(
        emittedStates,
        <SignupState>[
          const SignupState(
            status: SignupStatus.loading,
            isCheckingEmailConfirmation: false,
          ),
          const SignupState(
            status: SignupStatus.sessionEstablished,
            isCheckingEmailConfirmation: false,
          ),
        ],
      );
    });

    test('keeps confirmation flow open with inline error when no session is detected yet', () async {
      authRepository.signupResult = false;
      await cubit.signupWithEmailAndPassword('test@example.com', 'password123');
      await _settleStream();

      emittedStates.clear();

      await cubit.checkEmailConfirmed();
      await _settleStream();

      expect(
        emittedStates,
        <SignupState>[
          const SignupState(
            status: SignupStatus.emailConfirmationRequired,
            isCheckingEmailConfirmation: true,
          ),
          const SignupState(
            status: SignupStatus.emailConfirmationRequired,
            errorMessage: SignupCubit.emailConfirmationPendingErrorCode,
            isCheckingEmailConfirmation: false,
          ),
        ],
      );
    });

    test('emits sessionEstablished when a confirmed user is available', () async {
      authRepository.signupResult = false;
      await cubit.signupWithEmailAndPassword('test@example.com', 'password123');
      await _settleStream();
      authRepository.setCurrentUser(_testUser());
      await _settleStream();

      emittedStates.clear();

      await cubit.checkEmailConfirmed();
      await _settleStream();

      expect(
        emittedStates,
        <SignupState>[
          const SignupState(
            status: SignupStatus.emailConfirmationRequired,
            isCheckingEmailConfirmation: true,
          ),
          const SignupState(
            status: SignupStatus.sessionEstablished,
            isCheckingEmailConfirmation: false,
          ),
        ],
      );
    });

    test('resets to initial state when confirmation is cancelled', () async {
      authRepository.signupResult = false;
      await cubit.signupWithEmailAndPassword('test@example.com', 'password123');
      await _settleStream();

      emittedStates.clear();
      cubit.cancelConfirmation();
      await _settleStream();

      expect(emittedStates, <SignupState>[const SignupState.initial()]);
    });
  });
}

Future<void> _settleStream() async {
  await Future<void>.delayed(Duration.zero);
}

class _FakeAuthRepository implements IAuthRepository {
  final BehaviorSubject<User?> _userSubject = BehaviorSubject<User?>.seeded(null);

  bool signupResult = false;

  @override
  ValueStream<User?> get user$ => _userSubject.stream;

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {
    _userSubject.add(null);
  }

  @override
  Future<bool> signupWithEmailAndPassword(String email, String password) async {
    return signupResult;
  }

  void setCurrentUser(User? user) {
    _userSubject.add(user);
  }

  Future<void> dispose() async {
    await _userSubject.close();
  }
}

User _testUser() {
  return const User(
    id: 'user-1',
    appMetadata: <String, dynamic>{},
    userMetadata: <String, dynamic>{},
    aud: 'authenticated',
    email: 'test@example.com',
    createdAt: '2026-04-04T12:00:00.000Z',
    emailConfirmedAt: '2026-04-04T12:05:00.000Z',
  );
}
