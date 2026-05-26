import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/auth/use_cases/has_active_session_use_case.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/splash/entities/startup_destination.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/domain/wizard/use_cases/get_local_partner_profile_use_case.dart';
import 'package:la/presentation/core/app.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends BaseCubit<SplashState> {
  final GetLocalPartnerProfileUseCase _getLocalPartnerProfileUseCase;
  final HasActiveSessionUseCase _hasActiveSessionUseCase;

  SplashCubit(
    this._getLocalPartnerProfileUseCase,
    this._hasActiveSessionUseCase,
  ) : super(const SplashState.initial());

  Future init() async {
    final Payload<UserPartnerProfile?> profilePayload = await _getLocalPartnerProfileUseCase.execute();
    final bool profileReadOk = profilePayload.succeeded;
    final UserPartnerProfile? profile = profilePayload.value;
    final bool profilePresent = profileReadOk && profile != null;

    final bool signedIn = profilePresent && await _hasActiveSession();

    final StartupDestination destination = StartupDestination.resolve(
      profileReadOk: profileReadOk,
      profilePresent: profilePresent,
      signedIn: signedIn,
    );

    await Future.delayed(1300.milliseconds);
    _navigate(destination, profile);
  }

  Future<bool> _hasActiveSession() async {
    final Payload<bool> sessionPayload = await _hasActiveSessionUseCase.execute();
    return sessionPayload.getOr(false);
  }

  void _navigate(StartupDestination destination, UserPartnerProfile? profile) {
    final NavigatorState? navigator = App.navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    switch (destination) {
      case StartupDestination.wizard:
        navigator.pushReplacementNamed(PageName.wizard.route);
      case StartupDestination.main:
        navigator.pushReplacementNamed(PageName.main.route);
      case StartupDestination.landing:
        navigator.pushReplacementNamed(PageName.wizard.route);
        navigator.pushNamed(PageName.landing.route, arguments: profile);
    }
  }
}
