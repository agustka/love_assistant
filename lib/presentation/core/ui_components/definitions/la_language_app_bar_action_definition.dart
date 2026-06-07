import 'package:flutter/material.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/setup.dart';

final class LaLanguageAppBarActionDefinition extends AppBarActionDefinition {
  static const Key actionKey = Key("la_language_app_bar_action");

  static List<Language> get _availableLanguages {
    return Language.values.where((Language language) => language != Language.invalid).toList();
  }

  LaLanguageAppBarActionDefinition(
    BuildContext context, {
    super.showsIcon = true,
  }) : super(
         key: actionKey,
         icon: LaIcons.language,
         onTap: () {
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
                         getIt<LanguageCubit>().setLanguage(language);
                       },
                     ),
                   )
                   .toList(),
             ),
           );
         },
       );
}
