import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/setup.dart';

import '../../test_setup.dart';
import '../base_builder.dart';

/// Seeds values into the offline [ISharedPrefsWrapper] for a test.
class SharedPrefsBuilder extends BaseBuilder {
  final Map<String, Object> _values = {};

  SharedPrefsBuilder();

  SharedPrefsBuilder setValue({required String key, required Object value}) {
    _values[key] = value;
    return this;
  }

  @override
  TestSetupConstructor build() {
    return _SharedPrefsConstructor(Map<String, Object>.from(_values));
  }
}

class _SharedPrefsConstructor extends TestSetupConstructor {
  final Map<String, Object> values;

  const _SharedPrefsConstructor(this.values);

  @override
  Future<void> setup() async {
    final ISharedPrefsWrapper prefs = getIt<ISharedPrefsWrapper>();
    for (final MapEntry<String, Object> entry in values.entries) {
      final Object value = entry.value;
      if (value is bool) {
        await prefs.setBool(entry.key, value);
      } else if (value is int) {
        await prefs.setInt(entry.key, value);
      } else if (value is double) {
        await prefs.setDouble(entry.key, value);
      } else if (value is DateTime) {
        await prefs.setDateTime(entry.key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(entry.key, value);
      } else {
        await prefs.setString(entry.key, value.toString());
      }
    }
  }

  @override
  Future<void> tearDown() async {
    final ISharedPrefsWrapper prefs = getIt<ISharedPrefsWrapper>();
    for (final String key in values.keys) {
      await prefs.remove(key);
    }
    await super.tearDown();
  }
}
