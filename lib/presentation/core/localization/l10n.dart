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

  /// `Meira`
  String get global_more {
    return Intl.message(
      'Meira',
      name: 'global_more',
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

  /// `Þá getum við skipulagt sérstök tilefni og sérsniðið skilaboð betur.`
  String get wizard_partner_profile_message_2 {
    return Intl.message(
      'Þá getum við skipulagt sérstök tilefni og sérsniðið skilaboð betur.',
      name: 'wizard_partner_profile_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Hvað heitir þinn félagi?`
  String get wizard_partner_profile_name_title {
    return Intl.message(
      'Hvað heitir þinn félagi?',
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
