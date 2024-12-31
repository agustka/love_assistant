import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:la/application/core/base_cubit.dart';
import 'package:la/infrastructure/core/initialization/initialization_service.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/setup.dart';

part 'language_state.dart';

@injectable
class LanguageCubit extends BaseCubit<LanguageState> {
  LanguageCubit() : super(const LanguageState.initial());

  void setLanguage(Language language) {
    emit(state.copyWith(language: language));
  }
}
