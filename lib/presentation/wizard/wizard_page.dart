import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/application/wizard/wizard_cubit.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/domain/core/value_objects/favorite_food_value_object.dart';
import 'package:la/domain/core/value_objects/gift_ideas_value_object.dart';
import 'package:la/domain/core/value_objects/hobby_value_object.dart';
import 'package:la/domain/core/value_objects/love_language_value_object.dart';
import 'package:la/domain/core/value_objects/pronoun_value_object.dart';
import 'package:la/domain/core/value_objects/relationship_type_value_object.dart';
import 'package:la/domain/core/value_objects/tone_of_voice_value_object.dart';
import 'package:la/domain/wizard/entities/user_partner_profile.dart';
import 'package:la/domain/wizard/entities/wizard_config.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/dialogs/import.dart';
import 'package:la/presentation/core/localization/user_locale.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/organisms/import.dart';
import 'package:la/presentation/core/ui_components/templates/import.dart';
import 'package:la/presentation/core/ui_models/la_date_picker_definition.dart';
import 'package:la/presentation/core/ui_models/la_drop_down_definition.dart';
import 'package:la/presentation/core/ui_models/la_image_asset.dart';
import 'package:la/presentation/core/ui_models/la_multi_select_picker_definition.dart';
import 'package:la/presentation/core/ui_models/la_text_field_definition.dart';
import 'package:la/presentation/wizard/widgets/wizard_step_6.dart';
import 'package:la/setup.dart';

part "widgets/wizard_step_1.dart";
part "widgets/wizard_step_2.dart";
part "widgets/wizard_step_3.dart";
part "widgets/wizard_step_4.dart";
part "widgets/wizard_step_5.dart";

class WizardPage extends StatefulWidget {
  static const Key greetingsStepKey = Key("WizardPage_greetingsStep");
  static const Key basicInfoStepKey = Key("WizardPage_basicInfoStep");
  static const Key foodsAndGiftsStepKey = Key("WizardPage_foodsAndGiftsStep");
  static const Key hobbiesStepKey = Key("WizardPage_hobbiesStep");
  static const Key nextButtonKey = Key("WizardPage_nextButton");

  static const String partnerNameFieldId = "WizardStep2_partnerNameFieldId";
  static const String partnerPronounFieldId = "WizardStep2_partnerPronounFieldId";
  static const String partnerPronounFreeFormFieldId = "WizardStep2_partnerPronounFreeFormFieldId";
  static const String partnerBirthdayFieldId = "WizardStep2_partnerBirthdayFieldId";
  static const String partnerAnniversaryFieldId = "WizardStep2_partnerAnniversaryFieldId";

  static const String loveLanguageFieldId = "WizardStep3_loveLanguageFieldId";
  static const String toneOfVoiceFieldId = "WizardStep3_toneOfVoiceFieldId";
  static const String partnerHobbiesFieldId = "WizardStep3_partnerHobbiesFieldId";

  static const String foodPreferencesFieldId = "WizardStep4_foodPreferencesFieldId";
  static const String giftPreferencesFieldId = "WizardStep_giftPreferencesFieldId";

  static const String partnerRelationshipTypeId = "WizardStep5_partnerRelationshipTypeId";

  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  PageController? _controller;

  double _page = 0;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WizardCubit>(
      create: (BuildContext context) {
        return getIt<WizardCubit>()..init();
      },
      child: BlocBuilder<WizardCubit, WizardState>(
        builder: (BuildContext context, WizardState state) {
          if (state.status == WizardStatus.loading) {
            return LaWizardTemplate(
              body: LaPagerOrganism(
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) => _buildStep(state, index),
              ),
            );
          }

          final PageController controller = _ensureController(state.targetStep);

          return _WizardPageEventListener(
            pageController: controller,
            onWizardMessage: (WizardEvent message) => _onWizardMessage(context, message),
            onInitialSetupCompleted: (UserPartnerProfile profile) => _onInitialSetupCompleted(context, profile),
            child: LaWizardTemplate(
              appBar: LaAppBarOrganism(
                style: AppBarStyle.background,
                showBack: false,
                action: _getAppBarAction(),
              ),
              bottomButtons: _getBottomButtons(context, state),
              body: LaPagerOrganism(
                itemCount: state.config.stepCount,
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) => _buildStep(state, index),
              ),
            ),
          );
        },
      ),
    );
  }

  PageController _ensureController(int initialPage) {
    if (_controller != null) {
      return _controller!;
    }

    final PageController controller = PageController(initialPage: initialPage);
    controller.addListener(() {
      setState(() {
        _page = controller.page ?? 0;
      });
    });
    _page = initialPage.toDouble();
    _controller = controller;
    return controller;
  }

  Future<void> _onInitialSetupCompleted(BuildContext context, UserPartnerProfile profile) async {
    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(PageName.landing.route, arguments: profile);
  }

  List<Language> get _availableLanguages {
    return Language.values.where((Language language) => language != Language.invalid).toList();
  }

  Widget _buildStep(WizardState state, int index) {
    final WizardStep step = state.config.visibleSteps[index];

    switch (step.type) {
      case WizardStepType.greetings:
        return const _WizardStep1(key: WizardPage.greetingsStepKey);
      case WizardStepType.basicInfo:
        return _WizardStep2(
          key: WizardPage.basicInfoStepKey,
          isInitial: state.isInitial,
          partnerName: state.partnerName,
          partnerPronoun: state.partnerPronoun,
          customPronoun: state.customPronoun,
          partnerBirthday: state.partnerBirthday,
        );
      case WizardStepType.personalPreferences:
        return _WizardStep3(
          isInitial: state.isInitial,
          partnerName: state.partnerName,
          partnerPronoun: state.partnerPronoun,
          customPronoun: state.customPronoun,
          loveLanguages: state.partnerLoveLanguages,
          toneOfVoice: state.partnerToneOfVoice,
          hobbies: state.partnerHobbies,
        );
      case WizardStepType.foodsAndGifts:
        return _WizardStep4(
          key: WizardPage.foodsAndGiftsStepKey,
          isInitial: state.isInitial,
          partnerName: state.partnerName,
          partnerPronoun: state.partnerPronoun,
          customPronoun: state.customPronoun,
          favoriteFoods: state.partnerFavoriteFoods,
          giftCategories: state.partnerGiftCategories,
        );
      case WizardStepType.anniversary:
        return _WizardStep5(
          isInitial: state.isInitial,
          partnerName: state.partnerName,
          partnerPronoun: state.partnerPronoun,
          customPronoun: state.customPronoun,
        );
      case WizardStepType.hobbies:
        return const WizardStep6(key: WizardPage.hobbiesStepKey);
    }
  }

  Future<void> _onWizardMessage(BuildContext context, WizardEvent event) async {
    final WizardState state = context.read<WizardCubit>().state;

    switch (event) {
      case WizardEvent.missingName:
        getIt<EventBus>().fire(
          LaFormFieldErrorEvent(
            fieldId: WizardPage.partnerNameFieldId,
            message: S.of(context).wizard_partner_profile_name_missing,
          ),
        );
      case WizardEvent.missingPronoun:
        final String fieldId = state.partnerPronoun == Pronoun.custom
            ? WizardPage.partnerPronounFreeFormFieldId
            : WizardPage.partnerPronounFieldId;
        getIt<EventBus>().fire(
          LaFormFieldErrorEvent(
            fieldId: fieldId,
            message: S.of(context).wizard_partner_profile_pronoun_missing,
          ),
        );
      case WizardEvent.missingBirthday:
        getIt<EventBus>().fire(
          LaFormFieldErrorEvent(
            fieldId: WizardPage.partnerBirthdayFieldId,
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
          context.read<WizardCubit>().next(
            _controller?.page?.round() ?? 0,
            confirmed: true,
          );
        }
    }
  }

  AppBarActionDefinition _getAppBarAction() {
    return AppBarActionDefinition(
      icon: LaIcons.language,
      onTap: () {
        LaPicker.showPicker(
          context,
          entries: PickerEntries(
            title: S.of(context).settings_pick_language,
            entries: _availableLanguages
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
    );
  }

  BottomButtonsDefinition _getBottomButtons(BuildContext context, WizardState state) {
    return BottomButtonsDefinition(
      loading: state.status == WizardStatus.loading,
      buttons: [
        BottomButtonDefinition(
          key: WizardPage.nextButtonKey,
          text: S.of(context).wizard_next,
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read<WizardCubit>().next((_controller?.page ?? 0).round());
          },
        ),
        if (_page > 0)
          BottomButtonDefinition(
            text: S.of(context).wizard_previous,
            onTap: () {
              FocusScope.of(context).unfocus();
              _controller?.animateToPage(
                (_page - 1).round(),
                duration: 300.milliseconds,
                curve: Curves.easeIn,
              );
            },
          ),
      ],
    );
  }
}

class _WizardPageEventListener extends StatelessWidget {
  final PageController pageController;
  final Future<void> Function(WizardEvent event) onWizardMessage;
  final Future<void> Function(UserPartnerProfile profile) onInitialSetupCompleted;
  final Widget child;

  const _WizardPageEventListener({
    required this.pageController,
    required this.onWizardMessage,
    required this.onInitialSetupCompleted,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LaEventBusListener<WizardEventGoToPage>(
      onMessage: (WizardEventGoToPage event) {
        pageController.animateToPage(
          event.page,
          duration: 300.milliseconds,
          curve: Curves.easeInOut,
        );
      },
      child: LaEventBusListener<WizardEvent>(
        onMessage: onWizardMessage,
        child: LaEventBusListener<WizardInitialSetupCompletedEvent>(
          onMessage: (WizardInitialSetupCompletedEvent event) => onInitialSetupCompleted(event.profile),
          child: child,
        ),
      ),
    );
  }
}
