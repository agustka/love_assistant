import 'package:injectable/injectable.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';
import 'package:la/setup.dart';

/// In-memory partner profile store for the offline (test) environment.
///
/// Holds the last saved profile so tests can assert what was persisted and so a
/// persisted profile can be staged for the load path. Exposes [failOnSave] and
/// [failOnLoad] so builders can drive the save- and read-failure paths at the
/// boundary without touching real storage.
@InjectableEnv.offline
@LazySingleton(as: IPartnerProfileLocalStore)
class OfflinePartnerProfileLocalStore implements IPartnerProfileLocalStore {
  UserPartnerProfile? savedProfile;
  bool failOnSave = false;
  bool failOnLoad = false;

  OfflinePartnerProfileLocalStore();

  @override
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile) async {
    if (failOnSave) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced save failure"));
    }
    savedProfile = profile;
    return Payload.success(null);
  }

  @override
  Future<Payload<UserPartnerProfile?>> loadPartnerProfile() async {
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced load failure"));
    }
    return Payload.success(savedProfile);
  }

  @override
  Future<Payload<bool>> hasPartnerProfile() async {
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced presence failure"));
    }
    return Payload.success(savedProfile != null);
  }
}
