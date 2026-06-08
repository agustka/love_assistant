import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/domain/wizard/use_cases/get_local_partner_profile_use_case.dart';
import 'package:la/setup.dart';

part 'main_state.dart';

@Injectable()
class MainCubit extends BaseCubit<MainState> {
  final GetLocalPartnerProfileUseCase _getLocalPartnerProfileUseCase;

  MainCubit(this._getLocalPartnerProfileUseCase) : super(const MainState.initial());

  Future<void> init() async {
    emit(state.copyWith(status: MainStatus.loading, profileCtaDismissed: false));

    final Payload<UserPartnerProfile> payload = await _getLocalPartnerProfileUseCase.execute();
    payload.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            status: MainStatus.loaded,
            partnerProfile: const UserPartnerProfile.invalid(),
            profileCtaActionInProgress: false,
          ),
        );
      },
      (UserPartnerProfile profile) {
        emit(
          state.copyWith(
            status: MainStatus.loaded,
            partnerProfile: profile.valid ? profile : const UserPartnerProfile.invalid(),
            profileCtaActionInProgress: false,
          ),
        );
      },
    );
  }

  void onProfileCtaDismissTap() {
    emit(state.copyWith(profileCtaDismissed: true, profileCtaActionInProgress: false));
  }

  void onProfileCtaActionTap() {
    if (!state.showProfileCompletionCta || state.profileCtaActionInProgress) {
      return;
    }

    emit(state.copyWith(profileCtaActionInProgress: true));
    getIt<EventBus>().fire(const MainOpenDetailedProfileWizardEvent());
  }

  void onProfileCtaActionSettled() {
    emit(state.copyWith(profileCtaActionInProgress: false));
  }
}
