import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/infrastructure/core/prefs/shared_prefs_keys.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';
import 'package:la/setup.dart';

@InjectableEnv.online
@LazySingleton(as: IPartnerProfileLocalStore)
class PartnerProfileLocalStore implements IPartnerProfileLocalStore {
  final ISharedPrefsWrapper _prefs;

  PartnerProfileLocalStore(this._prefs);

  @override
  Future<Payload<void>> savePartnerProfile(UserPartnerProfile profile) async {
    try {
      final String serialized = jsonEncode(profile.toModel().toJson());
      await _prefs.setString(SharedPrefsKeys.partnerProfile, serialized);
      return Payload.success(null);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.savePartnerProfile");
      return Payload.failure(const Failure("Failed to save partner profile locally"));
    }
  }
}
