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
import 'package:la/application/core/auth/login_cubit.dart' as _i323;
import 'package:la/application/core/auth/signup_cubit.dart' as _i197;
import 'package:la/application/core/language/language_cubit.dart' as _i953;
import 'package:la/application/splash/splash_cubit.dart' as _i247;
import 'package:la/application/wizard/wizard_cubit.dart' as _i167;
import 'package:la/domain/core/repositories/i_auth_repository.dart' as _i742;
import 'package:la/infrastructure/core/auth/device_id_provider.dart' as _i700;
import 'package:la/infrastructure/core/auth/repository/auth_repository.dart'
    as _i755;
import 'package:la/infrastructure/core/auth/service/auth_service.dart' as _i266;
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart'
    as _i663;
import 'package:la/infrastructure/core/cache/hive_cache.dart' as _i681;
import 'package:la/infrastructure/core/cache/i_hive_cache.dart' as _i339;
import 'package:la/infrastructure/core/event/event_bus_module.dart' as _i16;
import 'package:la/infrastructure/core/initialization/initialization_service.dart'
    as _i984;
import 'package:la/infrastructure/core/time/i_poll_and_debounce.dart' as _i651;
import 'package:la/infrastructure/core/time/poll_and_debounce.dart' as _i187;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final eventBusModule = _$EventBusModule();
    gh.factory<_i953.LanguageCubit>(() => _i953.LanguageCubit());
    gh.factory<_i247.SplashCubit>(() => _i247.SplashCubit());
    gh.factory<_i167.WizardCubit>(() => _i167.WizardCubit());
    gh.singleton<_i1017.EventBus>(() => eventBusModule.eventBus);
    gh.singleton<_i984.InitializationService>(
      () => _i984.InitializationService(),
    );
    gh.lazySingleton<_i339.IHiveCache>(() => const _i681.HiveCache());
    gh.factory<_i651.IPollAndDebounce>(() => _i187.PollAndDebounce());
    gh.lazySingleton<_i663.IAuthService>(
      () => _i266.AuthService(gh<_i454.SupabaseClient>()),
    );
    gh.singleton<_i700.DeviceIdProvider>(
      () => _i700.DeviceIdProvider(gh<_i339.IHiveCache>()),
    );
    gh.lazySingleton<_i742.IAuthRepository>(
      () => _i755.AuthRepository(gh<_i663.IAuthService>()),
    );
    gh.factory<_i323.LoginCubit>(
      () => _i323.LoginCubit(gh<_i742.IAuthRepository>()),
    );
    gh.factory<_i197.SignupCubit>(
      () => _i197.SignupCubit(gh<_i742.IAuthRepository>()),
    );
    return this;
  }
}

class _$EventBusModule extends _i16.EventBusModule {}
