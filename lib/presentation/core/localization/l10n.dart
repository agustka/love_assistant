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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hjálp í ást`
  String get app_name {
    return Intl.message('Hjálp í ást', name: 'app_name', desc: '', args: []);
  }

  /// `Hætta við`
  String get global_cancel {
    return Intl.message('Hætta við', name: 'global_cancel', desc: '', args: []);
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
    return Intl.message('Meira', name: 'global_more', desc: '', args: []);
  }

  /// `Búið`
  String get global_done {
    return Intl.message('Búið', name: 'global_done', desc: '', args: []);
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
    return Intl.message('Uppsetning', name: 'wizard_title', desc: '', args: []);
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

  /// `Þinn eiginn Ástar Engill`
  String get wizard_greetings {
    return Intl.message(
      'Þinn eiginn Ástar Engill',
      name: 'wizard_greetings',
      desc: '',
      args: [],
    );
  }

  /// `Ástarengillinn þinn hjálpar þér að næra sambandið við ástvin þinn.`
  String get wizard_greetings_message_1 {
    return Intl.message(
      'Ástarengillinn þinn hjálpar þér að næra sambandið við ástvin þinn.',
      name: 'wizard_greetings_message_1',
      desc: '',
      args: [],
    );
  }

  /// `Hann minnir þig á mikilvægar dagsetningar, semur persónuleg skilaboð og leggur til góðar hugmyndir.`
  String get wizard_greetings_message_2 {
    return Intl.message(
      'Hann minnir þig á mikilvægar dagsetningar, semur persónuleg skilaboð og leggur til góðar hugmyndir.',
      name: 'wizard_greetings_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Byrjum`
  String get wizard_start {
    return Intl.message('Byrjum', name: 'wizard_start', desc: '', args: []);
  }

  /// `Næsta`
  String get wizard_next {
    return Intl.message('Næsta', name: 'wizard_next', desc: '', args: []);
  }

  /// `Fyrri`
  String get wizard_previous {
    return Intl.message('Fyrri', name: 'wizard_previous', desc: '', args: []);
  }

  /// `Byrjum á grunnatriðunum`
  String get wizard_partner_profile_title {
    return Intl.message(
      'Byrjum á grunnatriðunum',
      name: 'wizard_partner_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Segðu okkur aðeins frá félaga þínum eins og nafn og fornafn.`
  String get wizard_partner_profile_message_1_shortened {
    return Intl.message(
      'Segðu okkur aðeins frá félaga þínum eins og nafn og fornafn.',
      name: 'wizard_partner_profile_message_1_shortened',
      desc: '',
      args: [],
    );
  }

  /// `Segðu okkur aðeins frá félaga þínum eins og nafn, fornafn og mikilvægar dagsetningar.`
  String get wizard_partner_profile_message_1_extended {
    return Intl.message(
      'Segðu okkur aðeins frá félaga þínum eins og nafn, fornafn og mikilvægar dagsetningar.',
      name: 'wizard_partner_profile_message_1_extended',
      desc: '',
      args: [],
    );
  }

  /// `Segðu mér hvað þín heittelskaða persónu heitir og hvers kyns hún er.`
  String get wizard_partner_profile_message_initial_1 {
    return Intl.message(
      'Segðu mér hvað þín heittelskaða persónu heitir og hvers kyns hún er.',
      name: 'wizard_partner_profile_message_initial_1',
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

  /// `Ég nota þessar upplýsingar til að ganga úr skugga um að þú hafir tíma til að skipuleggja eitthvað sérstakt fyrir þína sérstöku persónu.`
  String get wizard_partner_birthday_explanation {
    return Intl.message(
      'Ég nota þessar upplýsingar til að ganga úr skugga um að þú hafir tíma til að skipuleggja eitthvað sérstakt fyrir þína sérstöku persónu.',
      name: 'wizard_partner_birthday_explanation',
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

  /// `Hvað dýrkar {name}?`
  String wizard_partner_more_details(Object name) {
    return Intl.message(
      'Hvað dýrkar $name?',
      name: 'wizard_partner_more_details',
      desc: '',
      args: [name],
    );
  }

  /// `Afmæli`
  String get wizard_partner_birthday_title {
    return Intl.message(
      'Afmæli',
      name: 'wizard_partner_birthday_title',
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

  /// `Ég nota þessar upplýsingar til að ganga úr skugga um að þú hafir tíma til að skipuleggja og fá eitthvað sérstakt fyrir þína sérstökupersónu.`
  String get wizard_partner_anniversary_explanation {
    return Intl.message(
      'Ég nota þessar upplýsingar til að ganga úr skugga um að þú hafir tíma til að skipuleggja og fá eitthvað sérstakt fyrir þína sérstökupersónu.',
      name: 'wizard_partner_anniversary_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Hvað elskar {gender}?`
  String wizard_partner_loves_title(Object gender) {
    return Intl.message(
      'Hvað elskar $gender?',
      name: 'wizard_partner_loves_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Deildu því sem {name} hefur gaman af til að hjálpa til við að sérsníða tillögur.`
  String wizard_partner_loves_message_1(Object name) {
    return Intl.message(
      'Deildu því sem $name hefur gaman af til að hjálpa til við að sérsníða tillögur.',
      name: 'wizard_partner_loves_message_1',
      desc: '',
      args: [name],
    );
  }

  /// `Veldu ástarmálin og tóninn sem henta {gender} best.`
  String wizard_partner_loves_message_initial_1(Object gender) {
    return Intl.message(
      'Veldu ástarmálin og tóninn sem henta $gender best.',
      name: 'wizard_partner_loves_message_initial_1',
      desc: '',
      args: [gender],
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

  /// `Það er oft talað um að það séu fimm tegundir ástar-tjáningar.\nGæðatími: Að eyða óskiptum, innihaldsríkum tíma saman.\nStaðfestingarorð: Að tjá ást og þakklæti með góðum og staðfestandi orðum.\nÞjónusta: Að sýna kærleika með því að vinna gagnleg eða ígrunduð verkefni.\nLíkamleg snerting: Að tjá ást með líkamlegum táknum eins og knúsum, kossum og öðrum snertingum.\nGefa gjafir: Að gefa og þiggja ígrundaðar gjafir sem tákn um ást.`
  String get wizard_partner_love_language_explanation {
    return Intl.message(
      'Það er oft talað um að það séu fimm tegundir ástar-tjáningar.\nGæðatími: Að eyða óskiptum, innihaldsríkum tíma saman.\nStaðfestingarorð: Að tjá ást og þakklæti með góðum og staðfestandi orðum.\nÞjónusta: Að sýna kærleika með því að vinna gagnleg eða ígrunduð verkefni.\nLíkamleg snerting: Að tjá ást með líkamlegum táknum eins og knúsum, kossum og öðrum snertingum.\nGefa gjafir: Að gefa og þiggja ígrundaðar gjafir sem tákn um ást.',
      name: 'wizard_partner_love_language_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Með því að deila með mér áhugamálum félaga þíns hjálpar þú mér að velja viðeigandi viðburði og gjafir.`
  String get wizard_partner_hobbies_explanation {
    return Intl.message(
      'Með því að deila með mér áhugamálum félaga þíns hjálpar þú mér að velja viðeigandi viðburði og gjafir.',
      name: 'wizard_partner_hobbies_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Með því að deila hvaða mat þín heittelskaða persóna finnst góður hjálpar þú mér að velja réttar matargjafir og veitingastaði.`
  String get wizard_partner_foods_explanation {
    return Intl.message(
      'Með því að deila hvaða mat þín heittelskaða persóna finnst góður hjálpar þú mér að velja réttar matargjafir og veitingastaði.',
      name: 'wizard_partner_foods_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Með því að velja talsmáta hjálpar þú mér að semja skilaboð sem hljóma betur í eyrum félaga þíns.`
  String get wizard_partner_tone_of_voice_explanation {
    return Intl.message(
      'Með því að velja talsmáta hjálpar þú mér að semja skilaboð sem hljóma betur í eyrum félaga þíns.',
      name: 'wizard_partner_tone_of_voice_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Hvernig talsmáti á best við {gender}?`
  String wizard_partner_tone_of_voice_title(Object gender) {
    return Intl.message(
      'Hvernig talsmáti á best við $gender?',
      name: 'wizard_partner_tone_of_voice_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Veldu talsmáta`
  String get wizard_partner_tone_of_voice_hint {
    return Intl.message(
      'Veldu talsmáta',
      name: 'wizard_partner_tone_of_voice_hint',
      desc: '',
      args: [],
    );
  }

  /// `Selecting your loved one’s favorite types will help me suggest appropriate gifts.\nExperiences: E.g., tickets to events, vacations, date nights.\nSentimental Items: E.g., handmade gifts, personal letters, photo albums.\nPractical Gifts: E.g., gadgets, tools, kitchenware.\nLuxury Items: E.g., jewelry, designer clothing, high-end accessories.\nHobbies & Interests: E.g., books, music instruments, art supplies.\nFood & Drinks: E.g., gourmet chocolates, wine, or subscription boxes.\nSurprise Me: For when you want me to get creative.`
  String get wizard_partner_gift_types_explanation {
    return Intl.message(
      'Selecting your loved one’s favorite types will help me suggest appropriate gifts.\nExperiences: E.g., tickets to events, vacations, date nights.\nSentimental Items: E.g., handmade gifts, personal letters, photo albums.\nPractical Gifts: E.g., gadgets, tools, kitchenware.\nLuxury Items: E.g., jewelry, designer clothing, high-end accessories.\nHobbies & Interests: E.g., books, music instruments, art supplies.\nFood & Drinks: E.g., gourmet chocolates, wine, or subscription boxes.\nSurprise Me: For when you want me to get creative.',
      name: 'wizard_partner_gift_types_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Hvernig ástarmál passar {gender}?`
  String wizard_partner_love_language_title(Object gender) {
    return Intl.message(
      'Hvernig ástarmál passar $gender?',
      name: 'wizard_partner_love_language_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Hefur {gender} einhver áhugamál?`
  String wizard_partner_hobbies_title(Object gender) {
    return Intl.message(
      'Hefur $gender einhver áhugamál?',
      name: 'wizard_partner_hobbies_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Hvernig mat finnst {name} góður?`
  String wizard_partner_food_likes_title(Object name) {
    return Intl.message(
      'Hvernig mat finnst $name góður?',
      name: 'wizard_partner_food_likes_title',
      desc: '',
      args: [name],
    );
  }

  /// `Hvernig gjafir vill {gender} fá?`
  String wizard_partner_gift_likes_title(Object gender) {
    return Intl.message(
      'Hvernig gjafir vill $gender fá?',
      name: 'wizard_partner_gift_likes_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Segðu mér aðeins frá {gender} smekk`
  String wizard_partner_food_and_gifts_title(Object gender) {
    return Intl.message(
      'Segðu mér aðeins frá $gender smekk',
      name: 'wizard_partner_food_and_gifts_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Segðu mér frá matar og gjafastíl sem á best við {gender}.`
  String wizard_partner_food_and_gifts_message_1(Object gender) {
    return Intl.message(
      'Segðu mér frá matar og gjafastíl sem á best við $gender.',
      name: 'wizard_partner_food_and_gifts_message_1',
      desc: '',
      args: [gender],
    );
  }

  /// `Þá get ég stungið upp á hlutum sem {name} mun dýrka og forðast þá sem {gender} kýs síður.`
  String wizard_partner_food_and_gifts_message_2(Object name, Object gender) {
    return Intl.message(
      'Þá get ég stungið upp á hlutum sem $name mun dýrka og forðast þá sem $gender kýs síður.',
      name: 'wizard_partner_food_and_gifts_message_2',
      desc: '',
      args: [name, gender],
    );
  }

  /// `.`
  String get ordinal_suffix_first {
    return Intl.message('.', name: 'ordinal_suffix_first', desc: '', args: []);
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
    return Intl.message('.', name: 'ordinal_suffix_global', desc: '', args: []);
  }

  /// `.`
  String get ordinal_suffix_second {
    return Intl.message('.', name: 'ordinal_suffix_second', desc: '', args: []);
  }

  /// `.`
  String get ordinal_suffix_third {
    return Intl.message('.', name: 'ordinal_suffix_third', desc: '', args: []);
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

  /// `Að fá gjafir`
  String get global_love_language_receiving_gifts {
    return Intl.message(
      'Að fá gjafir',
      name: 'global_love_language_receiving_gifts',
      desc: '',
      args: [],
    );
  }

  /// `Þjónusta`
  String get global_love_language_acts_of_service {
    return Intl.message(
      'Þjónusta',
      name: 'global_love_language_acts_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Tími saman`
  String get global_love_language_quality_time {
    return Intl.message(
      'Tími saman',
      name: 'global_love_language_quality_time',
      desc: '',
      args: [],
    );
  }

  /// `Falleg orð`
  String get global_love_language_words_of_affirmation {
    return Intl.message(
      'Falleg orð',
      name: 'global_love_language_words_of_affirmation',
      desc: '',
      args: [],
    );
  }

  /// `Líkamleg snerting`
  String get global_love_language_physical_touch {
    return Intl.message(
      'Líkamleg snerting',
      name: 'global_love_language_physical_touch',
      desc: '',
      args: [],
    );
  }

  /// `Hún`
  String get global_pronoun_she_nefnifall {
    return Intl.message(
      'Hún',
      name: 'global_pronoun_she_nefnifall',
      desc: '',
      args: [],
    );
  }

  /// `Hana`
  String get global_pronoun_she_tholfall {
    return Intl.message(
      'Hana',
      name: 'global_pronoun_she_tholfall',
      desc: '',
      args: [],
    );
  }

  /// `Henni`
  String get global_pronoun_she_thagufall {
    return Intl.message(
      'Henni',
      name: 'global_pronoun_she_thagufall',
      desc: '',
      args: [],
    );
  }

  /// `Hennar`
  String get global_pronoun_she_eignarfall {
    return Intl.message(
      'Hennar',
      name: 'global_pronoun_she_eignarfall',
      desc: '',
      args: [],
    );
  }

  /// `Hann`
  String get global_pronoun_he_nefnifall {
    return Intl.message(
      'Hann',
      name: 'global_pronoun_he_nefnifall',
      desc: '',
      args: [],
    );
  }

  /// `Hann`
  String get global_pronoun_he_tholfall {
    return Intl.message(
      'Hann',
      name: 'global_pronoun_he_tholfall',
      desc: '',
      args: [],
    );
  }

  /// `Honum`
  String get global_pronoun_he_thagufall {
    return Intl.message(
      'Honum',
      name: 'global_pronoun_he_thagufall',
      desc: '',
      args: [],
    );
  }

  /// `Hans`
  String get global_pronoun_he_eignarfall {
    return Intl.message(
      'Hans',
      name: 'global_pronoun_he_eignarfall',
      desc: '',
      args: [],
    );
  }

  /// `Hán`
  String get global_pronoun_they_nefnifall {
    return Intl.message(
      'Hán',
      name: 'global_pronoun_they_nefnifall',
      desc: '',
      args: [],
    );
  }

  /// `Hán`
  String get global_pronoun_they_tholfall {
    return Intl.message(
      'Hán',
      name: 'global_pronoun_they_tholfall',
      desc: '',
      args: [],
    );
  }

  /// `Háni`
  String get global_pronoun_they_thagufall {
    return Intl.message(
      'Háni',
      name: 'global_pronoun_they_thagufall',
      desc: '',
      args: [],
    );
  }

  /// `Háns`
  String get global_pronoun_they_eignarfall {
    return Intl.message(
      'Háns',
      name: 'global_pronoun_they_eignarfall',
      desc: '',
      args: [],
    );
  }

  /// `Þau`
  String get global_pronoun_invalid_nefnifall {
    return Intl.message(
      'Þau',
      name: 'global_pronoun_invalid_nefnifall',
      desc: '',
      args: [],
    );
  }

  /// `Þau`
  String get global_pronoun_invalid_tholfall {
    return Intl.message(
      'Þau',
      name: 'global_pronoun_invalid_tholfall',
      desc: '',
      args: [],
    );
  }

  /// `Þeim`
  String get global_pronoun_invalid_thagufall {
    return Intl.message(
      'Þeim',
      name: 'global_pronoun_invalid_thagufall',
      desc: '',
      args: [],
    );
  }

  /// `Þeirra`
  String get global_pronoun_invalid_eignarfall {
    return Intl.message(
      'Þeirra',
      name: 'global_pronoun_invalid_eignarfall',
      desc: '',
      args: [],
    );
  }

  /// `Hnyttinn`
  String get global_tone_of_voice_playful {
    return Intl.message(
      'Hnyttinn',
      name: 'global_tone_of_voice_playful',
      desc: '',
      args: [],
    );
  }

  /// `Rómantískur`
  String get global_tone_of_voice_romantic {
    return Intl.message(
      'Rómantískur',
      name: 'global_tone_of_voice_romantic',
      desc: '',
      args: [],
    );
  }

  /// `Hversdagslegur`
  String get global_tone_of_voice_casual {
    return Intl.message(
      'Hversdagslegur',
      name: 'global_tone_of_voice_casual',
      desc: '',
      args: [],
    );
  }

  /// `Formlegur`
  String get global_tone_of_voice_formal {
    return Intl.message(
      'Formlegur',
      name: 'global_tone_of_voice_formal',
      desc: '',
      args: [],
    );
  }

  /// `Lestur og bækur`
  String get global_hobby_reading {
    return Intl.message(
      'Lestur og bækur',
      name: 'global_hobby_reading',
      desc: '',
      args: [],
    );
  }

  /// `Eldamennska`
  String get global_hobby_cooking {
    return Intl.message(
      'Eldamennska',
      name: 'global_hobby_cooking',
      desc: '',
      args: [],
    );
  }

  /// `Ferðalög`
  String get global_hobby_traveling {
    return Intl.message(
      'Ferðalög',
      name: 'global_hobby_traveling',
      desc: '',
      args: [],
    );
  }

  /// `Tölvuleikir`
  String get global_hobby_gaming {
    return Intl.message(
      'Tölvuleikir',
      name: 'global_hobby_gaming',
      desc: '',
      args: [],
    );
  }

  /// `Heilsa`
  String get global_hobby_fitness {
    return Intl.message(
      'Heilsa',
      name: 'global_hobby_fitness',
      desc: '',
      args: [],
    );
  }

  /// `Tónlist`
  String get global_hobby_music {
    return Intl.message(
      'Tónlist',
      name: 'global_hobby_music',
      desc: '',
      args: [],
    );
  }

  /// `Föndur`
  String get global_hobby_crafting {
    return Intl.message(
      'Föndur',
      name: 'global_hobby_crafting',
      desc: '',
      args: [],
    );
  }

  /// `Garðyrkja`
  String get global_hobby_gardening {
    return Intl.message(
      'Garðyrkja',
      name: 'global_hobby_gardening',
      desc: '',
      args: [],
    );
  }

  /// `Myndir og sjónvarp`
  String get global_hobby_movies_and_tv {
    return Intl.message(
      'Myndir og sjónvarp',
      name: 'global_hobby_movies_and_tv',
      desc: '',
      args: [],
    );
  }

  /// `Veiðar`
  String get global_hobby_fishing_and_hunting {
    return Intl.message(
      'Veiðar',
      name: 'global_hobby_fishing_and_hunting',
      desc: '',
      args: [],
    );
  }

  /// `Íþróttir og sport`
  String get global_hobby_sports {
    return Intl.message(
      'Íþróttir og sport',
      name: 'global_hobby_sports',
      desc: '',
      args: [],
    );
  }

  /// `Súkkulaði`
  String get global_food_chocolate {
    return Intl.message(
      'Súkkulaði',
      name: 'global_food_chocolate',
      desc: '',
      args: [],
    );
  }

  /// `Kaffi`
  String get global_food_coffee {
    return Intl.message(
      'Kaffi',
      name: 'global_food_coffee',
      desc: '',
      args: [],
    );
  }

  /// `Pítsur`
  String get global_food_pizza {
    return Intl.message(
      'Pítsur',
      name: 'global_food_pizza',
      desc: '',
      args: [],
    );
  }

  /// `Pasta`
  String get global_food_pasta {
    return Intl.message('Pasta', name: 'global_food_pasta', desc: '', args: []);
  }

  /// `Núðlur`
  String get global_food_noodle_dishes {
    return Intl.message(
      'Núðlur',
      name: 'global_food_noodle_dishes',
      desc: '',
      args: [],
    );
  }

  /// `Sjávarmeti`
  String get global_food_seafood {
    return Intl.message(
      'Sjávarmeti',
      name: 'global_food_seafood',
      desc: '',
      args: [],
    );
  }

  /// `Salöt`
  String get global_food_salads {
    return Intl.message(
      'Salöt',
      name: 'global_food_salads',
      desc: '',
      args: [],
    );
  }

  /// `Sterkur`
  String get global_food_spicy_food {
    return Intl.message(
      'Sterkur',
      name: 'global_food_spicy_food',
      desc: '',
      args: [],
    );
  }

  /// `Götumatur`
  String get global_food_street_food {
    return Intl.message(
      'Götumatur',
      name: 'global_food_street_food',
      desc: '',
      args: [],
    );
  }

  /// `Heimagert`
  String get global_food_home_made {
    return Intl.message(
      'Heimagert',
      name: 'global_food_home_made',
      desc: '',
      args: [],
    );
  }

  /// `Vín`
  String get global_food_wine {
    return Intl.message('Vín', name: 'global_food_wine', desc: '', args: []);
  }

  /// `Eftirréttir`
  String get global_food_desserts {
    return Intl.message(
      'Eftirréttir',
      name: 'global_food_desserts',
      desc: '',
      args: [],
    );
  }

  /// `Upplifanir`
  String get global_gift_experience {
    return Intl.message(
      'Upplifanir',
      name: 'global_gift_experience',
      desc: '',
      args: [],
    );
  }

  /// `Persónulegar`
  String get global_gift_sentimental {
    return Intl.message(
      'Persónulegar',
      name: 'global_gift_sentimental',
      desc: '',
      args: [],
    );
  }

  /// `Hagnýtar`
  String get global_gift_practical_gifts {
    return Intl.message(
      'Hagnýtar',
      name: 'global_gift_practical_gifts',
      desc: '',
      args: [],
    );
  }

  /// `Munaðarvörur`
  String get global_gift_luxury_items {
    return Intl.message(
      'Munaðarvörur',
      name: 'global_gift_luxury_items',
      desc: '',
      args: [],
    );
  }

  /// `Áhugamál`
  String get global_gift_hobbies {
    return Intl.message(
      'Áhugamál',
      name: 'global_gift_hobbies',
      desc: '',
      args: [],
    );
  }

  /// `Matur & drykkur`
  String get global_gift_food_and_drinks {
    return Intl.message(
      'Matur & drykkur',
      name: 'global_gift_food_and_drinks',
      desc: '',
      args: [],
    );
  }

  /// `Vellíðan`
  String get global_gift_wellness {
    return Intl.message(
      'Vellíðan',
      name: 'global_gift_wellness',
      desc: '',
      args: [],
    );
  }

  /// `Komdu mér á óvart`
  String get global_gift_surprise_me {
    return Intl.message(
      'Komdu mér á óvart',
      name: 'global_gift_surprise_me',
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
      Locale.fromSubtags(languageCode: 'en'),
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
