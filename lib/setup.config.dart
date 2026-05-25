// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:event_bus/event_bus.dart' as _i1017;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:la/application/core/language/language_cubit.dart' as _i953;
import 'package:la/application/splash/splash_cubit.dart' as _i247;
import 'package:la/application/wizard/wizard_cubit.dart' as _i167;
import 'package:la/domain/core/repositories/i_auth_repository.dart' as _i742;
import 'package:la/domain/wizard/use_cases/save_local_partner_profile_use_case.dart'
    as _i1010;
import 'package:la/infrastructure/core/analytics/repository/i_logging_repository.dart'
    as _i1013;
import 'package:la/infrastructure/core/analytics/repository/logging_repository.dart'
    as _i845;
import 'package:la/infrastructure/core/auth/device_id_provider.dart' as _i700;
import 'package:la/infrastructure/core/auth/repository/auth_repository.dart'
    as _i755;
import 'package:la/infrastructure/core/auth/repository/offline/offline_auth_repository.dart'
    as _i302;
import 'package:la/infrastructure/core/auth/service/auth_service.dart' as _i266;
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart'
    as _i663;
import 'package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart'
    as _i817;
import 'package:la/infrastructure/core/auth/session/session_manager.dart'
    as _i693;
import 'package:la/infrastructure/core/cache/hive_cache.dart' as _i681;
import 'package:la/infrastructure/core/cache/i_hive_cache.dart' as _i339;
import 'package:la/infrastructure/core/event/event_bus_module.dart' as _i16;
import 'package:la/infrastructure/core/initialization/initialization_service.dart'
    as _i984;
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart'
    as _i306;
import 'package:la/infrastructure/core/prefs/offline/offline_shared_prefs_wrapper.dart'
    as _i449;
import 'package:la/infrastructure/core/prefs/shared_prefs_wrapper.dart'
    as _i784;
import 'package:la/infrastructure/core/supabase/supabase_module.dart' as _i1048;
import 'package:la/infrastructure/core/time/i_poll_and_debounce.dart' as _i651;
import 'package:la/infrastructure/core/time/poll_and_debounce.dart' as _i187;
import 'package:la/infrastructure/wizard/store/i_partner_profile_local_store.dart'
    as _i667;
import 'package:la/infrastructure/wizard/store/offline/offline_partner_profile_local_store.dart'
    as _i261;
import 'package:la/infrastructure/wizard/store/partner_profile_local_store.dart'
    as _i1018;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

const String _offline = 'offline';
const String _online = 'online';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final eventBusModule = _$EventBusModule();
    final supabaseModule = _$SupabaseModule();
    final sharedPreferencesModule = _$SharedPreferencesModule();
    gh.factory<_i953.LanguageCubit>(() => _i953.LanguageCubit());
    gh.factory<_i247.SplashCubit>(() => _i247.SplashCubit());
    gh.singleton<_i1017.EventBus>(() => eventBusModule.eventBus);
    gh.singleton<_i984.InitializationService>(
      () => _i984.InitializationService(),
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => supabaseModule.supabaseClient);
    gh.lazySingleton<_i306.ISharedPrefsWrapper>(
      () => _i449.OfflineSharedPrefsWrapper(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i663.IAuthService>(
      () => _i266.AuthService(gh<_i454.SupabaseClient>()),
      registerFor: {_online},
    );
    gh.lazySingleton<_i339.IHiveCache>(() => const _i681.HiveCache());
    gh.factory<_i651.IPollAndDebounce>(() => _i187.PollAndDebounce());
    gh.lazySingleton<_i667.IPartnerProfileLocalStore>(
      () => _i261.OfflinePartnerProfileLocalStore(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i742.IAuthRepository>(
      () => _i302.OfflineAuthRepository(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i663.IAuthService>(
      () => _i817.OfflineAuthService(),
      registerFor: {_offline},
    );
    gh.lazySingleton<_i1013.ILoggingRepository>(
      () => _i845.LoggingRepository(),
      dispose: (i) => i.dispose(),
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.sharedPreferences,
      registerFor: {_online},
      preResolve: true,
    );
    gh.singleton<_i700.DeviceIdProvider>(
      () => _i700.DeviceIdProvider(gh<_i339.IHiveCache>()),
    );
    gh.lazySingleton<_i742.IAuthRepository>(
      () => _i755.AuthRepository(gh<_i663.IAuthService>()),
      registerFor: {_online},
    );
    gh.lazySingleton<_i306.ISharedPrefsWrapper>(
      () => _i784.SharedPrefsWrapper(gh<_i460.SharedPreferences>()),
      registerFor: {_online},
    );
    gh.lazySingleton<_i667.IPartnerProfileLocalStore>(
      () => _i1018.PartnerProfileLocalStore(gh<_i306.ISharedPrefsWrapper>()),
      registerFor: {_online},
    );
    gh.factory<_i1010.SaveLocalPartnerProfileUseCase>(
      () => _i1010.SaveLocalPartnerProfileUseCase(
        gh<_i667.IPartnerProfileLocalStore>(),
      ),
    );
    gh.singleton<_i693.SessionManager>(
      () => _i693.SessionManager(
        gh<_i306.ISharedPrefsWrapper>(),
        gh<_i742.IAuthRepository>(),
        gh<_i339.IHiveCache>(),
      ),
    );
    gh.factory<_i167.WizardCubit>(
      () => _i167.WizardCubit(gh<_i1010.SaveLocalPartnerProfileUseCase>()),
    );
    return this;
  }
}

class _$EventBusModule extends _i16.EventBusModule {}

class _$SupabaseModule extends _i1048.SupabaseModule {}

class _$SharedPreferencesModule extends _i784.SharedPreferencesModule {}
