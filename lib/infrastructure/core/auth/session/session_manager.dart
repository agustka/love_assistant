import 'package:injectable/injectable.dart';
import 'package:la/application/core/analytics/analytics_helper.dart';
import 'package:la/domain/core/analytics/base/event.dart';
import 'package:la/domain/core/repositories/i_auth_repository.dart';
import 'package:la/infrastructure/core/auth/auth_event_type.dart';
import 'package:la/infrastructure/core/auth/session/i_cache_clearable.dart';
import 'package:la/infrastructure/core/auth/session/i_cache_lifecycle_repository.dart';
import 'package:la/infrastructure/core/auth/session/i_purgeable_service.dart';
import 'package:la/infrastructure/core/cache/i_hive_cache.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';

@Singleton()
class SessionManager with AnalyticsHelper {
  final ISharedPrefsWrapper _prefs;
  final IAuthRepository _authRepository;

  final IHiveCache _hiveCache;

  bool _isLoggingOut = false;
  bool _reloadOnUnlock = false;

  bool get isLoggingOut => _isLoggingOut;

  List<IPurgeableService> get _services => [
    _hiveCache,
  ];

  List<ICacheLifecycleRepository> get _repos => [];

  List<ICacheLifecycleRepository> get _excludeFromUnlockRefresh => [];

  List<ICacheClearable> get _cacheClearableRepos => [];

  SessionManager(
    this._prefs,
    this._authRepository,
    this._hiveCache,
  );

  void initialize() {
    _authRepository.subscribeToAuthEvents(listener: _handleAuthEvent);
  }

  Future<void> _handleAuthEvent(AuthEventType event) async {
    switch (event) {
      case AuthEventType.login:
        await _refreshAllData(forceGet: true);
      case AuthEventType.unlock:
        if (_reloadOnUnlock) {
          await _reloadAllData();
          _reloadOnUnlock = false;
        } else {
          await _refreshAfterUnlock();
        }
      case AuthEventType.loginStart:
        await _clearAllData(preserveSharedPrefs: false);
      default:
        break;
    }
  }

  Future<void> _reloadAllData() async {
    final Iterable<Future> operations = _repos.map((ICacheLifecycleRepository e) => e.reload());
    await Future.wait(operations);
  }

  Future<void> _refreshAfterUnlock() async {
    final Iterable<Future> operations = _repos.map((ICacheLifecycleRepository e) {
      if (_excludeFromUnlockRefresh.contains(e)) {
        return Future.value();
      }
      return e.refresh(forceGet: false);
    });
    await Future.wait(operations);
  }

  Future<void> _refreshAllData({required bool forceGet}) async {
    final Iterable<Future> operations = _repos.map((ICacheLifecycleRepository e) => e.refresh(forceGet: forceGet));
    await Future.wait(operations);
  }

  Future<void> _clearAllData({required bool preserveSharedPrefs}) async {
    final Iterable<Future> operations = _repos.map((ICacheLifecycleRepository e) => e.clear());
    await Future.wait(operations);

    final Iterable<Future> clearOnlyOperations = _cacheClearableRepos.map((ICacheClearable e) => e.clear());
    await Future.wait(clearOnlyOperations);

    final Iterable<Future> purgeOperations = _services.map((IPurgeableService e) => e.purge());
    await Future.wait(purgeOperations);

    if (!preserveSharedPrefs) {
      await _prefs.clearUserData();
    }
  }

  //We should probably move all user switch operations / cleanups in here as well
  Future<void> logout() async {
    _isLoggingOut = true;
    try {
      log(AuthEvent.appLogOut());

      await _clearAllData(preserveSharedPrefs: false);

      // Finish session - token and user data is not available after this point
      await _authRepository.logout();
    } catch (e, stackTrace) {
      err("Error during logout: $e", location: "SessionManager.logout", trace: stackTrace);
    } finally {
      _isLoggingOut = false;
    }
  }
}
