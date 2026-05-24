class SharedPrefsKeys {
  const SharedPrefsKeys._();

  static const String preferredBrightness = "kskb73_8dsh";
  static const String preferredLocale = "u3bf_6d3jsg3_ujf";
  static const String partnerProfile = "pp_3kf9_d8sh2";

  static List<String> getKeepKeysWithPartialName() {
    return [];
  }

  static List<String> getKeepKeys() {
    return [
      SharedPrefsKeys.preferredBrightness,
      SharedPrefsKeys.preferredLocale,
    ];
  }
}
