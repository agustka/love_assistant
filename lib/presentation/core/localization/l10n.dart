// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hjálp í ást`
  String get app_name {
    return Intl.message(
      'Hjálp í ást',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Hætta við`
  String get global_cancel {
    return Intl.message(
      'Hætta við',
      name: 'global_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Staðfesta`
  String get global_confirm {
    return Intl.message(
      'Staðfesta',
      name: 'global_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Meira`
  String get global_more {
    return Intl.message(
      'Meira',
      name: 'global_more',
      desc: '',
      args: [],
    );
  }

  /// `Búið`
  String get global_done {
    return Intl.message(
      'Búið',
      name: 'global_done',
      desc: '',
      args: [],
    );
  }

  /// `Þín eigin`
  String get global_enter_custom {
    return Intl.message(
      'Þín eigin',
      name: 'global_enter_custom',
      desc: '',
      args: [],
    );
  }

  /// `Veldu dagsetningu`
  String get global_pick_date {
    return Intl.message(
      'Veldu dagsetningu',
      name: 'global_pick_date',
      desc: '',
      args: [],
    );
  }

  /// `Valkvæmt`
  String get global_optional {
    return Intl.message(
      'Valkvæmt',
      name: 'global_optional',
      desc: '',
      args: [],
    );
  }

  /// `Nauðsynlegt`
  String get global_required {
    return Intl.message(
      'Nauðsynlegt',
      name: 'global_required',
      desc: '',
      args: [],
    );
  }

  /// `Þetta atriði þarf að vera útfyllt`
  String get global_generic_field_error {
    return Intl.message(
      'Þetta atriði þarf að vera útfyllt',
      name: 'global_generic_field_error',
      desc: '',
      args: [],
    );
  }

  /// `dd. MMMM`
  String get date_format_month_and_day {
    return Intl.message(
      'dd. MMMM',
      name: 'date_format_month_and_day',
      desc: '',
      args: [],
    );
  }

  /// `Uppsetning`
  String get wizard_title {
    return Intl.message(
      'Uppsetning',
      name: 'wizard_title',
      desc: '',
      args: [],
    );
  }

  /// `Veldu tungumál`
  String get settings_pick_language {
    return Intl.message(
      'Veldu tungumál',
      name: 'settings_pick_language',
      desc: '',
      args: [],
    );
  }

  /// `Velkomin(n)!`
  String get wizard_greetings {
    return Intl.message(
      'Velkomin(n)!',
      name: 'wizard_greetings',
      desc: '',
      args: [],
    );
  }

  /// `Við skulum byrja á að kanna hvað það er sem maki eða félagi þinn hefur áhuga á.`
  String get wizard_greetings_message_1 {
    return Intl.message(
      'Við skulum byrja á að kanna hvað það er sem maki eða félagi þinn hefur áhuga á.',
      name: 'wizard_greetings_message_1',
      desc: '',
      args: [],
    );
  }

  /// `Þannig getur þú fengið hugmyndir, áminningar og sérsniðin skilaboð sem passa betur.`
  String get wizard_greetings_message_2 {
    return Intl.message(
      'Þannig getur þú fengið hugmyndir, áminningar og sérsniðin skilaboð sem passa betur.',
      name: 'wizard_greetings_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Þú þarft ekki að stofna reikning til að hefjast handa.`
  String get wizard_greetings_message_3 {
    return Intl.message(
      'Þú þarft ekki að stofna reikning til að hefjast handa.',
      name: 'wizard_greetings_message_3',
      desc: '',
      args: [],
    );
  }

  /// `Byrjum`
  String get wizard_start {
    return Intl.message(
      'Byrjum',
      name: 'wizard_start',
      desc: '',
      args: [],
    );
  }

  /// `Næsta`
  String get wizard_next {
    return Intl.message(
      'Næsta',
      name: 'wizard_next',
      desc: '',
      args: [],
    );
  }

  /// `Aðeins um þína sérstöku persónu`
  String get wizard_partner_profile_title {
    return Intl.message(
      'Aðeins um þína sérstöku persónu',
      name: 'wizard_partner_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Byrjum á grunnatriðum eins og nafni og mikilvægum dagsetningum.`
  String get wizard_partner_profile_message_1 {
    return Intl.message(
      'Byrjum á grunnatriðum eins og nafni og mikilvægum dagsetningum.',
      name: 'wizard_partner_profile_message_1',
      desc: '',
      args: [],
    );
  }

  /// `Þá get ég skipulagt sérstök tilefni og sérsniðið skilaboð betur.`
  String get wizard_partner_profile_message_2 {
    return Intl.message(
      'Þá get ég skipulagt sérstök tilefni og sérsniðið skilaboð betur.',
      name: 'wizard_partner_profile_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Hvað heitir sérstaka persónan þín?`
  String get wizard_partner_profile_name_title {
    return Intl.message(
      'Hvað heitir sérstaka persónan þín?',
      name: 'wizard_partner_profile_name_title',
      desc: '',
      args: [],
    );
  }

  /// `Nafn félaga þíns`
  String get wizard_partner_profile_name_hint {
    return Intl.message(
      'Nafn félaga þíns',
      name: 'wizard_partner_profile_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Nafn er nauðsynlegt`
  String get wizard_partner_profile_name_missing {
    return Intl.message(
      'Nafn er nauðsynlegt',
      name: 'wizard_partner_profile_name_missing',
      desc: '',
      args: [],
    );
  }

  /// `Hvernig á að ávarpa félaga þinn?`
  String get wizard_partner_pronouns_title {
    return Intl.message(
      'Hvernig á að ávarpa félaga þinn?',
      name: 'wizard_partner_pronouns_title',
      desc: '',
      args: [],
    );
  }

  /// `Fornafn er nauðsynlegt`
  String get wizard_partner_profile_pronoun_missing {
    return Intl.message(
      'Fornafn er nauðsynlegt',
      name: 'wizard_partner_profile_pronoun_missing',
      desc: '',
      args: [],
    );
  }

  /// `Veldu fornafn`
  String get wizard_partner_pronouns_hint {
    return Intl.message(
      'Veldu fornafn',
      name: 'wizard_partner_pronouns_hint',
      desc: '',
      args: [],
    );
  }

  /// `Hvenær á félagi þinn afmæli?`
  String get wizard_partner_birthday_title {
    return Intl.message(
      'Hvenær á félagi þinn afmæli?',
      name: 'wizard_partner_birthday_title',
      desc: '',
      args: [],
    );
  }

  /// `Afmæli er nauðsynlegt`
  String get wizard_partner_profile_birthday_missing {
    return Intl.message(
      'Afmæli er nauðsynlegt',
      name: 'wizard_partner_profile_birthday_missing',
      desc: '',
      args: [],
    );
  }

  /// `Veldu afmælisdagsetningu`
  String get wizard_partner_birthday_hint {
    return Intl.message(
      'Veldu afmælisdagsetningu',
      name: 'wizard_partner_birthday_hint',
      desc: '',
      args: [],
    );
  }

  /// `Einhver stór dagsetning?`
  String get wizard_partner_anniversary_title {
    return Intl.message(
      'Einhver stór dagsetning?',
      name: 'wizard_partner_anniversary_title',
      desc: '',
      args: [],
    );
  }

  /// `Gifting, trúlofun osfr.`
  String get wizard_partner_anniversary_hint {
    return Intl.message(
      'Gifting, trúlofun osfr.',
      name: 'wizard_partner_anniversary_hint',
      desc: '',
      args: [],
    );
  }

  /// `Sleppa stórviðburði?`
  String get wizard_partner_anniversary_skip_title {
    return Intl.message(
      'Sleppa stórviðburði?',
      name: 'wizard_partner_anniversary_skip_title',
      desc: '',
      args: [],
    );
  }

  /// `Ertu viss um að þú viljir sleppa dagsetningu stórviðurðar (gifting, trúlofun osfr.)?`
  String get wizard_partner_anniversary_skip_message {
    return Intl.message(
      'Ertu viss um að þú viljir sleppa dagsetningu stórviðurðar (gifting, trúlofun osfr.)?',
      name: 'wizard_partner_anniversary_skip_message',
      desc: '',
      args: [],
    );
  }

  /// `Já, sleppa`
  String get wizard_partner_anniversary_skip_yes_confirm {
    return Intl.message(
      'Já, sleppa',
      name: 'wizard_partner_anniversary_skip_yes_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Nei`
  String get wizard_partner_anniversary_skip_no_cancel {
    return Intl.message(
      'Nei',
      name: 'wizard_partner_anniversary_skip_no_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Hvað elskar félagi þinn?`
  String get wizard_partner_loves_title {
    return Intl.message(
      'Hvað elskar félagi þinn?',
      name: 'wizard_partner_loves_title',
      desc: '',
      args: [],
    );
  }

  /// `Segðu mér fá því sem félagi þinn elskar svo ég geti skapað betri upplifun.`
  String get wizard_partner_loves_message_1 {
    return Intl.message(
      'Segðu mér fá því sem félagi þinn elskar svo ég geti skapað betri upplifun.',
      name: 'wizard_partner_loves_message_1',
      desc: '',
      args: [],
    );
  }

  /// `Með þessu móti get ég búið til tillögur og skilaboð sem hitta betur í mark.`
  String get wizard_partner_loves_message_2 {
    return Intl.message(
      'Með þessu móti get ég búið til tillögur og skilaboð sem hitta betur í mark.',
      name: 'wizard_partner_loves_message_2',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get ordinal_suffix_first {
    return Intl.message(
      '.',
      name: 'ordinal_suffix_first',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get ordinal_suffix_generic {
    return Intl.message(
      '.',
      name: 'ordinal_suffix_generic',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get ordinal_suffix_global {
    return Intl.message(
      '.',
      name: 'ordinal_suffix_global',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get ordinal_suffix_second {
    return Intl.message(
      '.',
      name: 'ordinal_suffix_second',
      desc: '',
      args: [],
    );
  }

  /// `.`
  String get ordinal_suffix_third {
    return Intl.message(
      '.',
      name: 'ordinal_suffix_third',
      desc: '',
      args: [],
    );
  }

  /// `Hún`
  String get global_pronoun_she_her {
    return Intl.message(
      'Hún',
      name: 'global_pronoun_she_her',
      desc: '',
      args: [],
    );
  }

  /// `Hann`
  String get global_pronoun_he_him {
    return Intl.message(
      'Hann',
      name: 'global_pronoun_he_him',
      desc: '',
      args: [],
    );
  }

  /// `Hán`
  String get global_pronoun_they_them {
    return Intl.message(
      'Hán',
      name: 'global_pronoun_they_them',
      desc: '',
      args: [],
    );
  }

  /// `Velja sjálf(ur)`
  String get global_pronoun_custom {
    return Intl.message(
      'Velja sjálf(ur)',
      name: 'global_pronoun_custom',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'is'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
