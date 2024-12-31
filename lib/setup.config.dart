// GENERATED CODE - DO NOT MODIFY BY HAND

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
import 'package:la/infrastructure/core/cache/hive_cache.dart' as _i681;
import 'package:la/infrastructure/core/cache/i_hive_cache.dart' as _i339;
import 'package:la/infrastructure/core/event/event_bus_module.dart' as _i16;
import 'package:la/infrastructure/core/initialization/initialization_service.dart'
    as _i984;
import 'package:la/infrastructure/core/time/i_poll_and_debounce.dart' as _i651;
import 'package:la/infrastructure/core/time/poll_and_debounce.dart' as _i187;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final eventBusModule = _$EventBusModule();
    gh.factory<_i247.SplashCubit>(() => _i247.SplashCubit());
    gh.factory<_i953.LanguageCubit>(() => _i953.LanguageCubit());
    gh.factory<_i167.WizardCubit>(() => _i167.WizardCubit());
    gh.singleton<_i984.InitializationService>(
        () => _i984.InitializationService());
    gh.singleton<_i1017.EventBus>(() => eventBusModule.eventBus);
    gh.lazySingleton<_i339.IHiveCache>(() => const _i681.HiveCache());
    gh.factory<_i651.IPollAndDebounce>(() => _i187.PollAndDebounce());
    return this;
  }
}

class _$EventBusModule extends _i16.EventBusModule {}
