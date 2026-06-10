import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/domain/wizard/repositories/i_partner_profile_repository.dart";
import "package:la/infrastructure/core/error_handling/error_handler.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_remote_store.dart";

@LazySingleton(as: IPartnerProfileRepository)
class PartnerProfileRepository implements IPartnerProfileRepository {
  const PartnerProfileRepository(this._localStore, this._remoteStore);

  final IPartnerProfileLocalStore _localStore;
  final IPartnerProfileRemoteStore _remoteStore;

  @override
  Future<Payload<UserPartnerProfile>> syncAuthenticatedPartnerProfile() async {
    try {
      final Payload<UserPartnerProfile> localPayload = await _localStore.loadPartnerProfile();
      final UserPartnerProfile? localProfile = localPayload.value;

      if (localProfile == null || localProfile.isInvalid) {
        return _remoteStore.loadPartnerProfile();
      }

      final Payload<UserPartnerProfile> savePayload = await _remoteStore.saveInitialPartnerProfile(localProfile);
      if (savePayload.failed) {
        return Payload.success(localProfile);
      }

      final Payload<UserPartnerProfile> remotePayload = await _remoteStore.loadPartnerProfile();
      if (remotePayload.failed) {
        return Payload.success(localProfile);
      }

      final Payload<void> removePayload = await _localStore.removePartnerProfile();
      if (removePayload.failed) {
        err(
          removePayload.failure ?? const Failure("Failed to remove synced partner profile locally"),
          location: "PartnerProfileRepository.syncAuthenticatedPartnerProfile",
        );
      }

      return remotePayload;
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileRepository.syncAuthenticatedPartnerProfile");
      return Payload.failure(const Failure("Failed to sync authenticated partner profile"));
    }
  }
}
