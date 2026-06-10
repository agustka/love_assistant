import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/wizard/models/initial_partner_profile_data_model.dart";
import "package:la/infrastructure/wizard/models/user_partner_profile_model.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_remote_store.dart";
import "package:la/setup.dart";

@InjectableEnv.offline
@LazySingleton(as: IPartnerProfileRemoteStore)
class OfflinePartnerProfileRemoteStore implements IPartnerProfileRemoteStore {
  UserPartnerProfile? savedProfile;
  bool failOnLoad = false;
  bool failOnSave = false;
  bool unauthenticated = false;
  bool malformedProfileData = false;

  OfflinePartnerProfileRemoteStore();

  @override
  Future<Payload<UserPartnerProfile>> loadPartnerProfile() async {
    if (unauthenticated) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced unauthenticated failure"));
    }
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced load failure"));
    }
    if (malformedProfileData) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced malformed data failure"));
    }
    final UserPartnerProfile? profile = savedProfile;
    if (profile == null) {
      return Payload.success(const UserPartnerProfile.invalid());
    }
    return Payload.success(profile);
  }

  @override
  Future<Payload<UserPartnerProfile>> saveInitialPartnerProfile(UserPartnerProfile profile) async {
    if (unauthenticated) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced unauthenticated failure"));
    }
    if (failOnSave) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced save failure"));
    }
    if (malformedProfileData) {
      return Payload.failure(const Failure("OfflinePartnerProfileRemoteStore forced malformed data failure"));
    }

    final Map<String, dynamic> existingProfileData =
        savedProfile?.toModel().toJson() ?? const UserPartnerProfile.invalid().toModel().toJson();
    final Map<String, dynamic> initialProfileData = InitialPartnerProfileDataModel.fromUserPartnerProfileModel(
      profile.toModel(),
    ).toJson();
    final UserPartnerProfileModel mergedModel = UserPartnerProfileModel.fromJson({
      ...existingProfileData,
      ...initialProfileData,
    });
    savedProfile = UserPartnerProfile.fromModel(mergedModel);
    return Payload.success(savedProfile!);
  }
}
