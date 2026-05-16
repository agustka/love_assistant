abstract class ISharedPrefsWrapper {
  Object? get(String key);

  bool containsKey(String key);

  int? getInt(String key);

  bool? getBool(String key);

  DateTime? getDateTime(String key);

  String? getString(String key);

  List<String>? getStringList(String key);

  Future setString(String key, String value);

  Future setStringList(String key, List<String> value);

  Future setBool(String key, bool value);

  Future setInt(String key, int value);

  Future setDouble(String key, double value);

  Future setDateTime(String key, DateTime dateTime);

  void reload();

  Future clearUserData();

  Future remove(String key);

  List<String> getKeys();
}
