import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/la_picker.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_1.dart';
import 'package:la/setup.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  @override
  Widget build(BuildContext context) {
    final List<Language> langs = Language.values.toList();
    langs.removeWhere((Language e) => e == Language.invalid);

    return BlocProvider<WizardCubit>(
      create: (BuildContext context) {
        return getIt<WizardCubit>()..init();
      },
      child: LaScaffold(
        appBar: LaAppBar(
          title: S.of(context).wizard_title,
          showBack: false,
          action: AppBarActionDefinition(
            icon: LaIcons.language,
            onTap: () {
              LaPicker.showPicker(
                context,
                entries: PickerEntries(
                  title: S.of(context).settings_pick_language,
                  entries: langs
                      .map(
                        (Language e) => PickerEntry(
                          text: e.properName,
                          svg: e.flagIcon,
                          onTap: () => context.read<LanguageCubit>().setLanguage(e),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
        child: Center(
          child: LaPager(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return const WizardStep1();
                case 1:
                  return LaEpicImage(asset: LaTheme.illustrations.womanReading);
                case 2:
                  return LaEpicImage(asset: AppAssets.animations.progress, type: LaEpicImageType.animation);
                case 3:
                  return LaEpicImage(asset: LaTheme.illustrations.manLove);
                case 4:
                default:
                  return const ColoredBox(color: Colors.pinkAccent);
              }
            },
          ),
        ),
      ),
    );
  }
}
