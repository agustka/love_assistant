import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/core/value_objects/stream_payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart";
import "package:la/setup.dart";
import "package:rxdart/rxdart.dart";

/// In-memory partner profile store for the offline (test) environment.
///
/// Holds the last saved profile so tests can assert what was persisted and so a
/// persisted profile can be staged for the load path. Exposes [failOnSave] and
/// [failOnLoad] so builders can drive the save- and read-failure paths at the
/// boundary without touching real storage.
@InjectableEnv.offline
@LazySingleton(as: IPartnerProfileLocalStore)
class OfflinePartnerProfileLocalStore implements IPartnerProfileLocalStore {
  final BehaviorSubject<StreamPayload<UserPartnerProfile>> _profileSubject = BehaviorSubject();

  UserPartnerProfile? savedProfile;
  bool failOnSave = false;
  bool failOnLoad = false;
  bool failOnRemove = false;

  OfflinePartnerProfileLocalStore();

  @override
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile) async {
    if (failOnSave) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced save failure"));
    }
    savedProfile = profile;
    _profileSubject.add(StreamPayload.success(profile));
    return Payload.success(null);
  }

  @override
  Future<Payload<UserPartnerProfile>> loadPartnerProfile() async {
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced load failure"));
    }
    final UserPartnerProfile? profile = savedProfile;
    if (profile == null) {
      return Payload.success(const UserPartnerProfile.invalid());
    }
    return Payload.success(profile);
  }

  @override
  Stream<StreamPayload<UserPartnerProfile>> watchPartnerProfile() {
    loadPartnerProfile().then((Payload<UserPartnerProfile> payload) {
      _profileSubject.add(StreamPayload.fromPayload(payload));
    });
    return _profileSubject.stream;
  }

  @override
  Future<Payload<bool>> hasPartnerProfile() async {
    if (failOnLoad) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced presence failure"));
    }
    return Payload.success(savedProfile != null);
  }

  @override
  Future<Payload<void>> removePartnerProfile() async {
    if (failOnRemove) {
      return Payload.failure(const Failure("OfflinePartnerProfileLocalStore forced remove failure"));
    }
    savedProfile = null;
    _profileSubject.add(StreamPayload.reset());
    return Payload.success(null);
  }
}
