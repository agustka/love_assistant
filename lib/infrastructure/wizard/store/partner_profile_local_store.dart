import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/infrastructure/core/prefs/shared_prefs_keys.dart';
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart';

@LazySingleton(as: IPartnerProfileLocalStore)
class PartnerProfileLocalStore implements IPartnerProfileLocalStore {
  final ISharedPrefsWrapper _prefs;

  PartnerProfileLocalStore(this._prefs);

  @override
  Future<void> savePartnerProfile(UserPartnerProfile profile) async {
    try {
      final String serialized = jsonEncode(_toJson(profile));
      await _prefs.setString(SharedPrefsKeys.partnerProfile, serialized);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "PartnerProfileLocalStore.savePartnerProfile");
      rethrow;
    }
  }

  Map<String, dynamic> _toJson(UserPartnerProfile profile) {
    return {
      "partnerName": profile.partnerName,
      "partnerPronoun": profile.partnerPronoun.name,
      "customPronoun": profile.customPronoun,
      "partnerBirthday": profile.partnerBirthday?.toIso8601String(),
      "partnerLoveLanguages": profile.partnerLoveLanguages.map((e) => e.name).toList(),
      "partnerToneOfVoice": profile.partnerToneOfVoice.name,
      "partnerFavoriteFoods": profile.partnerFavoriteFoods.map((e) => e.name).toList(),
      "partnerGiftCategories": profile.partnerGiftCategories.map((e) => e.name).toList(),
    };
  }
}
