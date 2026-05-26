import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

/// Configures the offline auth boundary's session state for startup tests.
///
/// [signedIn] stages whether an active session exists. [failOnRead] makes the
/// offline service throw on the session read so the routing fallback can be
/// exercised at the boundary.
class AuthSessionBuilder extends BaseBuilder {
  bool _signedIn = false;
  bool _failOnRead = false;

  AuthSessionBuilder();

  AuthSessionBuilder signedIn() {
    _signedIn = true;
    return this;
  }

  AuthSessionBuilder failOnRead() {
    _failOnRead = true;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _AuthSessionConstructor(signedIn: _signedIn, failOnRead: _failOnRead);
  }
}

class _AuthSessionConstructor extends TestSetupConstructor {
  final bool signedIn;
  final bool failOnRead;

  const _AuthSessionConstructor({required this.signedIn, required this.failOnRead});

  @override
  Future<void> setup() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    service.hasSession = signedIn;
    service.throwOnHasActiveSession = failOnRead;
  }

  @override
  Future<void> tearDown() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    service.hasSession = false;
    service.throwOnHasActiveSession = false;
    await super.tearDown();
  }
}
