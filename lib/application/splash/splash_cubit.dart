import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/setup.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends BaseCubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future init() async {
    final InitializationService init = getIt<InitializationService>();
    final bool inited = await init.isInited();
    if (!inited) {
      App.navigatorKey.currentState?.pushReplacementNamed(PageName.wizard.route);
    }
  }
}
