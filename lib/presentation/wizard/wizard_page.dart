import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/wizard/entities/wizard_config.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/presentation/core/widgets/la_form_field_listener.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_1.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_2.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_3.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_4.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_5.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_6.dart';
import 'package:la/presentation/wizard/wizard_presenter.dart';
import 'package:la/setup.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  late final PageController _controller;

  double _page = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController();
    _controller.addListener(() {
      setState(() {
        _page = _controller.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Language> langs = Language.values.toList();
    langs.removeWhere((Language e) => e == Language.invalid);

    return LaEventBusListener<WizardEventGoToPage>(
      onMessage: (WizardEventGoToPage event) {
        _controller.animateToPage(event.page, duration: 300.milliseconds, curve: Curves.easeInOut);
      },
      child: BlocProvider<WizardCubit>(
        create: (BuildContext context) {
          return getIt<WizardCubit>()..init();
        },
        child: BlocBuilder<WizardCubit, WizardState>(
          builder: (BuildContext context, WizardState state) {
            return LaEventBusListener<WizardEvent>(
              onMessage: (WizardEvent event) async {
                switch (event) {
                  case WizardEvent.missingName:
                    getIt<EventBus>().fire(
                      LaFormFieldErrorEvent(
                        fieldId: WizardStep2.partnerNameFieldId,
                        message: S.of(context).wizard_partner_profile_name_missing,
                      ),
                    );
                  case WizardEvent.missingPronoun:
                    getIt<EventBus>().fire(
                      LaFormFieldErrorEvent(
                        fieldId: WizardStep2.partnerPronounFieldId,
                        message: S.of(context).wizard_partner_profile_pronoun_missing,
                      ),
                    );
                  case WizardEvent.missingBirthday:
                    getIt<EventBus>().fire(
                      LaFormFieldErrorEvent(
                        fieldId: WizardStep2.partnerBirthdayFieldId,
                        message: S.of(context).wizard_partner_profile_birthday_missing,
                      ),
                    );
                  case WizardEvent.confirmNoAnniversary:
                    final bool result = await LaConfirmationDialog.show(
                      context: context,
                      title: S.of(context).wizard_partner_anniversary_skip_title,
                      message: S.of(context).wizard_partner_anniversary_skip_message,
                      confirmText: S.of(context).wizard_partner_anniversary_skip_yes_confirm,
                      cancelText: S.of(context).wizard_partner_anniversary_skip_no_cancel,
                    );
                    if (!result && context.mounted) {
                      context.read<WizardCubit>().next(_controller.page?.round() ?? 0, confirmed: true);
                    }
                }
              },
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
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
                  bottomButtons: BottomButtonsDefinition(
                    loading: state.status == WizardStatus.loading,
                    buttons: [
                      BottomButtonDefinition(
                        text: S.of(context).wizard_next,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          context.read<WizardCubit>().next((_controller.page ?? 0).round());
                        },
                      ),
                      if (_page > 0)
                        BottomButtonDefinition(
                          text: S.of(context).wizard_previous,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _controller.animateToPage(
                              (_page - 1).round(),
                              duration: 300.milliseconds,
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                    ],
                  ),
                  child: BlocBuilder<WizardCubit, WizardState>(
                    builder: (BuildContext context, WizardState state) {
                      return LaPager(
                        itemCount: state.config.stepCount,
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final WizardStep step = state.config.visibleSteps[index];
                          final String stepTitle = WizardPresenter.getStepTitle(
                            context,
                            step.type,
                            gender: state.partnerPronoun.getNefnifall(state.customPronoun),
                          );
                          final String stepDescription = WizardPresenter.getStepDescription(context, step.type);

                          switch (step.type) {
                            case WizardStepType.greetings:
                              return WizardStep1(title: stepTitle, description: stepDescription);
                            case WizardStepType.basicInfo:
                              return WizardStep2(title: stepTitle, description: stepDescription);
                            case WizardStepType.dates:
                              return WizardStep3(title: stepTitle, description: stepDescription);
                            case WizardStepType.preferences:
                              return WizardStep4(title: stepTitle, description: stepDescription);
                            case WizardStepType.anniversary:
                              return WizardStep5(title: stepTitle, description: stepDescription);
                            case WizardStepType.hobbies:
                              return WizardStep6(title: stepTitle, description: stepDescription);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
