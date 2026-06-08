import 'package:injectable/injectable.dart';
import 'package:la/domain/core/entities/dismissible_content_key.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/dismissible_content/store/i_dismissible_content_local_store.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/setup.dart';

@InjectableEnv.online
@LazySingleton(as: IDismissibleContentLocalStore)
class DismissibleContentLocalStore implements IDismissibleContentLocalStore {
  final ISharedPrefsWrapper _prefs;

  DismissibleContentLocalStore(this._prefs);

  @override
  Future<Payload<Map<DismissibleContentKey, bool>>> loadDismissedContent(List<DismissibleContentKey> keys) async {
    try {
      return Payload.success({
        for (final DismissibleContentKey key in keys) key: _prefs.getBool(key.storageKey) ?? false,
      });
    } catch (ex, trace) {
      err(ex, trace: trace, location: "DismissibleContentLocalStore.loadDismissedContent");
      return Payload.failure(const Failure("Failed to load dismissed content locally"));
    }
  }

  @override
  Future<Payload<void>> dismissContent(DismissibleContentKey key) async {
    try {
      await _prefs.setBool(key.storageKey, true);
      return Payload.success(null);
    } catch (ex, trace) {
      err(ex, trace: trace, location: "DismissibleContentLocalStore.dismissContent");
      return Payload.failure(const Failure("Failed to dismiss content locally"));
    }
  }
}
