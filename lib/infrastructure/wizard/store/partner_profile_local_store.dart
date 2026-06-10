import "dart:convert";

import "package:injectable/injectable.dart";
import "package:la/domain/core/value_objects/failures/failure.dart";
import "package:la/domain/core/value_objects/payload.dart";
import "package:la/domain/core/value_objects/stream_payload.dart";
import "package:la/domain/wizard/entities/user_partner_profile.dart";
import "package:la/infrastructure/core/error_handling/error_handler.dart";
import "package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart";
import "package:la/infrastructure/core/prefs/shared_prefs_keys.dart";
import "package:la/infrastructure/wizard/models/user_partner_profile_model.dart";
import "package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart";
import "package:la/setup.dart";
import "package:rxdart/rxdart.dart";

@InjectableEnv.online
@LazySingleton(as: IPartnerProfileLocalStore)
class PartnerProfileLocalStore implements IPartnerProfileLocalStore {
  final ISharedPrefsWrapper _prefs;
  final BehaviorSubject<StreamPayload<UserPartnerProfile>> _profileSubject = BehaviorSubject();

  PartnerProfileLocalStore(this._prefs);

  @override
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile) async {
    try {
      final String serialized = jsonEncode(profile.toModel().toJson());
      await _prefs.setString(SharedPrefsKeys.partnerProfile, serialized);
      _profileSubject.add(StreamPayload.success(profile));
      return Payload.success(null);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.savePartnerProfile");
      return Payload.failure(const Failure("Failed to save partner profile locally"));
    }
  }

  @override
  Future<Payload<UserPartnerProfile>> loadPartnerProfile() async {
    try {
      final String? serialized = _prefs.getString(SharedPrefsKeys.partnerProfile);
      if (serialized == null) {
        return Payload.success(const UserPartnerProfile.invalid());
      }
      final Map<String, dynamic> json = jsonDecode(serialized) as Map<String, dynamic>;
      final UserPartnerProfileModel model = UserPartnerProfileModel.fromJson(json);
      return Payload.success(UserPartnerProfile.fromModel(model));
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.loadPartnerProfile");
      return Payload.failure(const Failure("Failed to load partner profile locally"));
    }
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
    try {
      return Payload.success(_prefs.containsKey(SharedPrefsKeys.partnerProfile));
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.hasPartnerProfile");
      return Payload.failure(const Failure("Failed to read partner profile presence"));
    }
  }

  @override
  Future<Payload<void>> removePartnerProfile() async {
    try {
      await _prefs.remove(SharedPrefsKeys.partnerProfile);
      _profileSubject.add(StreamPayload.reset());
      return Payload.success(null);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.removePartnerProfile");
      return Payload.failure(const Failure("Failed to remove partner profile locally"));
    }
  }
}
