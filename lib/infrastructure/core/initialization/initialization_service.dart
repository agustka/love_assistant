import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/prefs/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class InitializationService {
  bool profileCreated = false;

  Future init() async {

  }

  Future<bool> isInited() async {
    return false;
  }

  Future<Brightness?> getPreferredBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefsKeys.preferredBrightness)) {
      final String? pref = prefs.getString(SharedPrefsKeys.preferredBrightness);
      final Iterable<Brightness> brightness = Brightness.values.where((Brightness e) => e.name == pref);
      if (brightness.isNotEmpty) {
        return brightness.first;
      }
    }

    return null;
  }

  Future<Locale?> getPreferredLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(SharedPrefsKeys.preferredLocale)) {
      final String? pref = prefs.getString(SharedPrefsKeys.preferredLocale);
      final List<String> parts = (pref ?? "").split("-");
      if (parts.length != 2) {
        return null;
      }
      return Locale.fromSubtags(languageCode: parts.first, countryCode: parts.last);
    }

    return null;
  }
}
