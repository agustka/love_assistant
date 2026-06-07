import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/ui_components/definitions/la_language_app_bar_action_definition.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';

class LaLanguageAppBarActionOrganism extends StatelessWidget {
  static const Key actionKey = LaLanguageAppBarActionDefinition.actionKey;

  final AppBarStyle style;

  const LaLanguageAppBarActionOrganism({
    super.key,
    this.style = AppBarStyle.background,
  });

  @override
  Widget build(BuildContext context) {
    return LaLanguageAppBarActionDefinition(
      onTap: () => _showLanguagePicker(context),
    ).toWidget(style: style);
  }

  void _showLanguagePicker(BuildContext context) {
    LaPicker.showPicker(
      context,
      entries: PickerEntries(
        title: S.of(context).settings_pick_language,
        entries: _availableLanguages
            .map(
              (Language language) => PickerEntry(
                text: language.properName,
                svg: language.flagIcon,
                onTap: () {
                  context.read<LanguageCubit>().setLanguage(language);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  List<Language> get _availableLanguages {
    return Language.values.where((Language language) => language != Language.invalid).toList();
  }
}
