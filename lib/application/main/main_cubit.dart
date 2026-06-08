import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/stream_payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/domain/wizard/use_cases/watch_local_partner_profile_use_case.dart';
import 'package:la/setup.dart';

part 'main_state.dart';

@Injectable()
class MainCubit extends BaseCubit<MainState> {
  final WatchLocalPartnerProfileUseCase _watchLocalPartnerProfileUseCase;
  StreamSubscription<StreamPayload<UserPartnerProfile>>? _profileSubscription;

  MainCubit(this._watchLocalPartnerProfileUseCase) : super(const MainState.initial());

  void init() {
    emit(state.copyWith(status: MainStatus.loading));
    _profileSubscription?.cancel();
    _profileSubscription = _watchLocalPartnerProfileUseCase.subscribe().listen(_onProfilePayload);
  }

  void onProfileCtaActionTap() {
    if (!state.partnerProfile.incomplete || state.profileCtaActionInProgress) {
      return;
    }

    emit(state.copyWith(profileCtaActionInProgress: true));
    getIt<EventBus>().fire(const MainOpenDetailedProfileWizardEvent());
  }

  void onProfileCtaActionSettled() {
    emit(state.copyWith(profileCtaActionInProgress: false));
  }

  void _onProfilePayload(StreamPayload<UserPartnerProfile> payload) {
    final UserPartnerProfile profile = payload.dataOrNull ?? const UserPartnerProfile.invalid();
    emit(
      state.copyWith(
        status: MainStatus.loaded,
        partnerProfile: profile.valid ? profile : const UserPartnerProfile.invalid(),
        profileCtaActionInProgress: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
