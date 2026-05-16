import 'package:la/infrastructure/core/auth/session/i_cache_clearable.dart';

abstract interface class ICacheLifecycleRepository implements ICacheClearable {
  /// Deletes cache and then loads new data
  Future reload();

  /// Fetches new data without clearing cache first
  Future refresh({required bool forceGet});
}
