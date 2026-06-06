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

  /// `BetterHalf`
  String get app_name {
    return Intl.message('BetterHalf', name: 'app_name', desc: '', args: []);
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

  /// `Sýna lykilorð`
  String get global_show_password {
    return Intl.message(
      'Sýna lykilorð',
      name: 'global_show_password',
      desc: '',
      args: [],
    );
  }

  /// `Fela lykilorð`
  String get global_hide_password {
    return Intl.message(
      'Fela lykilorð',
      name: 'global_hide_password',
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

  /// `Þinn eigin BetterHalf`
  String get wizard_greetings {
    return Intl.message(
      'Þinn eigin BetterHalf',
      name: 'wizard_greetings',
      desc: '',
      args: [],
    );
  }

  /// `BetterHalf heldur utan um það sem skiptir maka þinn máli og hjálpar þér að gera eitthvað í því.`
  String get wizard_greetings_message_1 {
    return Intl.message(
      'BetterHalf heldur utan um það sem skiptir maka þinn máli og hjálpar þér að gera eitthvað í því.',
      name: 'wizard_greetings_message_1',
      desc: '',
      args: [],
    );
  }

  /// `Ég minni þig á dagsetningarnar sem skipta máli, skrifa drög að skilaboðum í þínum tón og raða upp gjafa- og stefnumótahugmyndum sem maki þinn myndi raunverulega vilja.`
  String get wizard_greetings_message_2 {
    return Intl.message(
      'Ég minni þig á dagsetningarnar sem skipta máli, skrifa drög að skilaboðum í þínum tón og raða upp gjafa- og stefnumótahugmyndum sem maki þinn myndi raunverulega vilja.',
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

  /// `Segðu mér aðeins frá maka þínum, eins og nafni og fornöfnum.`
  String get wizard_partner_profile_message_1_shortened {
    return Intl.message(
      'Segðu mér aðeins frá maka þínum, eins og nafni og fornöfnum.',
      name: 'wizard_partner_profile_message_1_shortened',
      desc: '',
      args: [],
    );
  }

  /// `Segðu mér aðeins frá maka þínum, eins og nafni, fornöfnum og mikilvægum dagsetningum.`
  String get wizard_partner_profile_message_1_extended {
    return Intl.message(
      'Segðu mér aðeins frá maka þínum, eins og nafni, fornöfnum og mikilvægum dagsetningum.',
      name: 'wizard_partner_profile_message_1_extended',
      desc: '',
      args: [],
    );
  }

  /// `Byrjum á grunnatriðunum: nafni og kyni.`
  String get wizard_partner_profile_message_initial_1 {
    return Intl.message(
      'Byrjum á grunnatriðunum: nafni og kyni.',
      name: 'wizard_partner_profile_message_initial_1',
      desc: '',
      args: [],
    );
  }

  /// `Hvað heitir maki þinn?`
  String get wizard_partner_profile_name_title {
    return Intl.message(
      'Hvað heitir maki þinn?',
      name: 'wizard_partner_profile_name_title',
      desc: '',
      args: [],
    );
  }

  /// `Nafn maka`
  String get wizard_partner_profile_name_hint {
    return Intl.message(
      'Nafn maka',
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

  /// `Hvernig á ég að tala um maka þinn?`
  String get wizard_partner_pronouns_title {
    return Intl.message(
      'Hvernig á ég að tala um maka þinn?',
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

  /// `Veldu fornöfn maka þíns`
  String get wizard_partner_pronouns_hint {
    return Intl.message(
      'Veldu fornöfn maka þíns',
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

  /// `Ég nota afmælisdag maka þíns svo þú hafir nægan tíma til að skipuleggja eitthvað sérstakt fyrir maka þinn.`
  String get wizard_partner_birthday_explanation {
    return Intl.message(
      'Ég nota afmælisdag maka þíns svo þú hafir nægan tíma til að skipuleggja eitthvað sérstakt fyrir maka þinn.',
      name: 'wizard_partner_birthday_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Eigið þið afmælisdag?`
  String get wizard_partner_anniversary_title {
    return Intl.message(
      'Eigið þið afmælisdag?',
      name: 'wizard_partner_anniversary_title',
      desc: '',
      args: [],
    );
  }

  /// `Veldu stóra daginn ykkar`
  String get wizard_partner_anniversary_hint {
    return Intl.message(
      'Veldu stóra daginn ykkar',
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

  /// `Sleppa afmælisdegi?`
  String get wizard_partner_anniversary_skip_title {
    return Intl.message(
      'Sleppa afmælisdegi?',
      name: 'wizard_partner_anniversary_skip_title',
      desc: '',
      args: [],
    );
  }

  /// `Ertu viss um að þú viljir sleppa afmælisdeginum?`
  String get wizard_partner_anniversary_skip_message {
    return Intl.message(
      'Ertu viss um að þú viljir sleppa afmælisdeginum?',
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

  /// `Ég nota afmælisdaginn ykkar svo þú hafir nægan tíma til að skipuleggja eða redda einhverju sérstöku fyrir maka þinn.`
  String get wizard_partner_anniversary_explanation {
    return Intl.message(
      'Ég nota afmælisdaginn ykkar svo þú hafir nægan tíma til að skipuleggja eða redda einhverju sérstöku fyrir maka þinn.',
      name: 'wizard_partner_anniversary_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Hvað finnst {gender} skemmtilegt?`
  String wizard_partner_loves_title(Object gender) {
    return Intl.message(
      'Hvað finnst $gender skemmtilegt?',
      name: 'wizard_partner_loves_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Segðu mér hvað {name} hefur gaman af svo tillögurnar passi betur.`
  String wizard_partner_loves_message_1(Object name) {
    return Intl.message(
      'Segðu mér hvað $name hefur gaman af svo tillögurnar passi betur.',
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

  /// `Þetta hjálpar mér að láta tillögurnar og skilaboðin hitta í mark.`
  String get wizard_partner_loves_message_2 {
    return Intl.message(
      'Þetta hjálpar mér að láta tillögurnar og skilaboðin hitta í mark.',
      name: 'wizard_partner_loves_message_2',
      desc: '',
      args: [],
    );
  }

  /// `Það er oft talað um fimm leiðir til að sýna ást.\nGæðatími: Að eiga óskiptan og innihaldsríkan tíma saman.\nFalleg orð: Að sýna ást og þakklæti með hlýjum og uppbyggilegum orðum.\nÞjónusta: Að sýna ást með því að gera eitthvað hjálplegt eða hugulsamt.\nLíkamleg snerting: Að sýna ást með líkamlegum merkjum eins og faðmlögum, kossum og annarri snertingu.\nGjafir: Að gefa og þiggja gjafir sem tákn um ást.`
  String get wizard_partner_love_language_explanation {
    return Intl.message(
      'Það er oft talað um fimm leiðir til að sýna ást.\nGæðatími: Að eiga óskiptan og innihaldsríkan tíma saman.\nFalleg orð: Að sýna ást og þakklæti með hlýjum og uppbyggilegum orðum.\nÞjónusta: Að sýna ást með því að gera eitthvað hjálplegt eða hugulsamt.\nLíkamleg snerting: Að sýna ást með líkamlegum merkjum eins og faðmlögum, kossum og annarri snertingu.\nGjafir: Að gefa og þiggja gjafir sem tákn um ást.',
      name: 'wizard_partner_love_language_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Áhugamál maka þíns hjálpa mér að velja afþreyingu og gjafir sem passa.`
  String get wizard_partner_hobbies_explanation {
    return Intl.message(
      'Áhugamál maka þíns hjálpa mér að velja afþreyingu og gjafir sem passa.',
      name: 'wizard_partner_hobbies_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Uppáhaldsmatur maka þíns hjálpar mér að velja matargjafir og veitingastaði sem passa.`
  String get wizard_partner_foods_explanation {
    return Intl.message(
      'Uppáhaldsmatur maka þíns hjálpar mér að velja matargjafir og veitingastaði sem passa.',
      name: 'wizard_partner_foods_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Rétti tónninn hjálpar mér að skrifa skilaboð sem hitta í mark hjá maka þínum.`
  String get wizard_partner_tone_of_voice_explanation {
    return Intl.message(
      'Rétti tónninn hjálpar mér að skrifa skilaboð sem hitta í mark hjá maka þínum.',
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

  /// `Uppáhalds gjafategundir maka þíns hjálpa mér að stinga upp á gjöfum sem passa.\nUpplifanir: Til dæmis miðar á viðburði, ferðalög eða stefnumót.\nPersónulegir hlutir: Til dæmis handgerðar gjafir, persónuleg bréf eða myndaalbúm.\nHagnýtar gjafir: Til dæmis tæki, verkfæri eða eldhúsdót.\nMunaðarvörur: Til dæmis skartgripir, hönnunarfatnaður eða vandaðir aukahlutir.\nÁhugamál: Til dæmis bækur, hljóðfæri eða listavörur.\nMatur og drykkur: Til dæmis vandað súkkulaði, vín eða áskriftarkassar.\nKomdu mér á óvart: Þegar þú vilt að ég verði skapandi.`
  String get wizard_partner_gift_types_explanation {
    return Intl.message(
      'Uppáhalds gjafategundir maka þíns hjálpa mér að stinga upp á gjöfum sem passa.\nUpplifanir: Til dæmis miðar á viðburði, ferðalög eða stefnumót.\nPersónulegir hlutir: Til dæmis handgerðar gjafir, persónuleg bréf eða myndaalbúm.\nHagnýtar gjafir: Til dæmis tæki, verkfæri eða eldhúsdót.\nMunaðarvörur: Til dæmis skartgripir, hönnunarfatnaður eða vandaðir aukahlutir.\nÁhugamál: Til dæmis bækur, hljóðfæri eða listavörur.\nMatur og drykkur: Til dæmis vandað súkkulaði, vín eða áskriftarkassar.\nKomdu mér á óvart: Þegar þú vilt að ég verði skapandi.',
      name: 'wizard_partner_gift_types_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Hvaða ástarmál passa {gender}?`
  String wizard_partner_love_language_title(Object gender) {
    return Intl.message(
      'Hvaða ástarmál passa $gender?',
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

  /// `Hvers konar gjafir finnst {gender} góðar?`
  String wizard_partner_gift_likes_title(Object gender) {
    return Intl.message(
      'Hvers konar gjafir finnst $gender góðar?',
      name: 'wizard_partner_gift_likes_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Tegund sambands`
  String get wizard_partner_relationship_type_title {
    return Intl.message(
      'Tegund sambands',
      name: 'wizard_partner_relationship_type_title',
      desc: '',
      args: [],
    );
  }

  /// `Veldu tegund sambands`
  String get wizard_partner_relationship_type_hint {
    return Intl.message(
      'Veldu tegund sambands',
      name: 'wizard_partner_relationship_type_hint',
      desc: '',
      args: [],
    );
  }

  /// `Þetta hjálpar mér að láta áminningar, skilaboð og tillögur passa við stöðuna í sambandinu ykkar`
  String get wizard_partner_relationship_type_explanation {
    return Intl.message(
      'Þetta hjálpar mér að láta áminningar, skilaboð og tillögur passa við stöðuna í sambandinu ykkar',
      name: 'wizard_partner_relationship_type_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Segðu mér aðeins meira frá smekk {gender}`
  String wizard_partner_food_and_gifts_title(Object gender) {
    return Intl.message(
      'Segðu mér aðeins meira frá smekk $gender',
      name: 'wizard_partner_food_and_gifts_title',
      desc: '',
      args: [gender],
    );
  }

  /// `Segðu mér frá gjafa- og matarsmekk {gender}.`
  String wizard_partner_food_and_gifts_message_1(Object gender) {
    return Intl.message(
      'Segðu mér frá gjafa- og matarsmekk $gender.',
      name: 'wizard_partner_food_and_gifts_message_1',
      desc: '',
      args: [gender],
    );
  }

  /// `Þá get ég mælt með hlutum sem {name} mun elska og forðast það sem {gender} fílar síður.`
  String wizard_partner_food_and_gifts_message_2(Object name, Object gender) {
    return Intl.message(
      'Þá get ég mælt með hlutum sem $name mun elska og forðast það sem $gender fílar síður.',
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

  /// `Sérsniðið`
  String get global_pronoun_custom {
    return Intl.message(
      'Sérsniðið',
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

  /// `Sterkur matur`
  String get global_food_spicy_food {
    return Intl.message(
      'Sterkur matur',
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

  /// `Matur og drykkur`
  String get global_gift_food_and_drinks {
    return Intl.message(
      'Matur og drykkur',
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

  /// `Á föstu`
  String get global_relationship_type_dating {
    return Intl.message(
      'Á föstu',
      name: 'global_relationship_type_dating',
      desc: '',
      args: [],
    );
  }

  /// `Trúlofuð`
  String get global_relationship_type_engaged {
    return Intl.message(
      'Trúlofuð',
      name: 'global_relationship_type_engaged',
      desc: '',
      args: [],
    );
  }

  /// `Gift`
  String get global_relationship_type_married {
    return Intl.message(
      'Gift',
      name: 'global_relationship_type_married',
      desc: '',
      args: [],
    );
  }

  /// `Lífsfélagar`
  String get global_relationship_type_life_partners {
    return Intl.message(
      'Lífsfélagar',
      name: 'global_relationship_type_life_partners',
      desc: '',
      args: [],
    );
  }

  /// `Annað`
  String get global_relationship_type_other {
    return Intl.message(
      'Annað',
      name: 'global_relationship_type_other',
      desc: '',
      args: [],
    );
  }

  /// `Búa til aðgang`
  String get auth_signup_title {
    return Intl.message(
      'Búa til aðgang',
      name: 'auth_signup_title',
      desc: '',
      args: [],
    );
  }

  /// `Skráðu þig til að vista uppsetninguna og halda áfram.`
  String get auth_signup_subtitle {
    return Intl.message(
      'Skráðu þig til að vista uppsetninguna og halda áfram.',
      name: 'auth_signup_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Skrá með Google`
  String get auth_signup_google {
    return Intl.message(
      'Skrá með Google',
      name: 'auth_signup_google',
      desc: '',
      args: [],
    );
  }

  /// `Skrá með Apple`
  String get auth_signup_apple {
    return Intl.message(
      'Skrá með Apple',
      name: 'auth_signup_apple',
      desc: '',
      args: [],
    );
  }

  /// `Ertu nú þegar með aðgang?`
  String get auth_signup_login_prompt {
    return Intl.message(
      'Ertu nú þegar með aðgang?',
      name: 'auth_signup_login_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Innskráning`
  String get auth_signup_login_action {
    return Intl.message(
      'Innskráning',
      name: 'auth_signup_login_action',
      desc: '',
      args: [],
    );
  }

  /// `Velkomin aftur`
  String get auth_login_title {
    return Intl.message(
      'Velkomin aftur',
      name: 'auth_login_title',
      desc: '',
      args: [],
    );
  }

  /// `Skráðu þig inn til að halda áfram.`
  String get auth_login_subtitle {
    return Intl.message(
      'Skráðu þig inn til að halda áfram.',
      name: 'auth_login_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Innskráning er ekki tilbúin enn`
  String get auth_login_under_construction_title {
    return Intl.message(
      'Innskráning er ekki tilbúin enn',
      name: 'auth_login_under_construction_title',
      desc: '',
      args: [],
    );
  }

  /// `Farðu til baka í bili. Enn er verið að smíða innskráningarflæðið.`
  String get auth_login_under_construction_message {
    return Intl.message(
      'Farðu til baka í bili. Enn er verið að smíða innskráningarflæðið.',
      name: 'auth_login_under_construction_message',
      desc: '',
      args: [],
    );
  }

  /// `Skrá inn með Google`
  String get auth_login_google {
    return Intl.message(
      'Skrá inn með Google',
      name: 'auth_login_google',
      desc: '',
      args: [],
    );
  }

  /// `Skrá inn með Apple`
  String get auth_login_apple {
    return Intl.message(
      'Skrá inn með Apple',
      name: 'auth_login_apple',
      desc: '',
      args: [],
    );
  }

  /// `Ertu ekki með aðgang?`
  String get auth_login_signup_prompt {
    return Intl.message(
      'Ertu ekki með aðgang?',
      name: 'auth_login_signup_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Nýskráning`
  String get auth_login_signup_action {
    return Intl.message(
      'Nýskráning',
      name: 'auth_login_signup_action',
      desc: '',
      args: [],
    );
  }

  /// `Netfang`
  String get auth_email_hint {
    return Intl.message('Netfang', name: 'auth_email_hint', desc: '', args: []);
  }

  /// `Lykilorð fyrir aðganginn`
  String get auth_password_hint {
    return Intl.message(
      'Lykilorð fyrir aðganginn',
      name: 'auth_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `you@example.com`
  String get auth_email_placeholder {
    return Intl.message(
      'you@example.com',
      name: 'auth_email_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Að minnsta kosti 6 stafir`
  String get auth_password_placeholder {
    return Intl.message(
      'Að minnsta kosti 6 stafir',
      name: 'auth_password_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Skrá með netfangi`
  String get auth_signup_email {
    return Intl.message(
      'Skrá með netfangi',
      name: 'auth_signup_email',
      desc: '',
      args: [],
    );
  }

  /// `Skrá inn með netfangi`
  String get auth_login_email {
    return Intl.message(
      'Skrá inn með netfangi',
      name: 'auth_login_email',
      desc: '',
      args: [],
    );
  }

  /// `Staðfestu netfangið þitt`
  String get auth_email_confirmation_title {
    return Intl.message(
      'Staðfestu netfangið þitt',
      name: 'auth_email_confirmation_title',
      desc: '',
      args: [],
    );
  }

  /// `Ég sendi þér staðfestingarpóst. Opnaðu hann, ýttu á staðfestingarhlekkinn, farðu aftur í appið og ýttu svo á "Ég hef staðfest netfangið mitt".`
  String get auth_email_confirmation_message {
    return Intl.message(
      'Ég sendi þér staðfestingarpóst. Opnaðu hann, ýttu á staðfestingarhlekkinn, farðu aftur í appið og ýttu svo á "Ég hef staðfest netfangið mitt".',
      name: 'auth_email_confirmation_message',
      desc: '',
      args: [],
    );
  }

  /// `Ég hef staðfest netfangið mitt`
  String get auth_email_confirmation_confirmed {
    return Intl.message(
      'Ég hef staðfest netfangið mitt',
      name: 'auth_email_confirmation_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Ég sé ekki enn að netfangið þitt hafi verið staðfest. Athugaðu pósthólfið og reyndu aftur.`
  String get auth_email_confirmation_pending_error {
    return Intl.message(
      'Ég sé ekki enn að netfangið þitt hafi verið staðfest. Athugaðu pósthólfið og reyndu aftur.',
      name: 'auth_email_confirmation_pending_error',
      desc: '',
      args: [],
    );
  }

  /// `Búa til aðgang`
  String get auth_signup_action {
    return Intl.message(
      'Búa til aðgang',
      name: 'auth_signup_action',
      desc: '',
      args: [],
    );
  }

  /// `[Log in]`
  String get auth_login_action {
    return Intl.message(
      '[Log in]',
      name: 'auth_login_action',
      desc: '',
      args: [],
    );
  }

  /// `Þetta netfang lítur ekki rétt út. Reyndu aftur.`
  String get auth_signup_email_invalid {
    return Intl.message(
      'Þetta netfang lítur ekki rétt út. Reyndu aftur.',
      name: 'auth_signup_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `[That email doesn't look right. Try again.]`
  String get auth_login_email_invalid {
    return Intl.message(
      '[That email doesn\'t look right. Try again.]',
      name: 'auth_login_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Lykilorðið þarf að vera að minnsta kosti 6 stafir.`
  String get auth_signup_password_too_short {
    return Intl.message(
      'Lykilorðið þarf að vera að minnsta kosti 6 stafir.',
      name: 'auth_signup_password_too_short',
      desc: '',
      args: [],
    );
  }

  /// `[Password must be at least 6 characters.]`
  String get auth_login_password_too_short {
    return Intl.message(
      '[Password must be at least 6 characters.]',
      name: 'auth_login_password_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Sláðu inn lykilorðið þitt.`
  String get auth_signup_password_empty {
    return Intl.message(
      'Sláðu inn lykilorðið þitt.',
      name: 'auth_signup_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `[Enter your password.]`
  String get auth_login_password_empty {
    return Intl.message(
      '[Enter your password.]',
      name: 'auth_login_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Það er nú þegar til aðgangur með þessu netfangi.`
  String get auth_signup_error_email_exists {
    return Intl.message(
      'Það er nú þegar til aðgangur með þessu netfangi.',
      name: 'auth_signup_error_email_exists',
      desc: '',
      args: [],
    );
  }

  /// `[That email or password is wrong.]`
  String get auth_login_error_invalid_credentials {
    return Intl.message(
      '[That email or password is wrong.]',
      name: 'auth_login_error_invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `Ég náði ekki sambandi við þjóninn. Athugaðu tenginguna og reyndu aftur.`
  String get auth_error_network {
    return Intl.message(
      'Ég náði ekki sambandi við þjóninn. Athugaðu tenginguna og reyndu aftur.',
      name: 'auth_error_network',
      desc: '',
      args: [],
    );
  }

  /// `Eitthvað fór úrskeiðis. Reyndu aftur.`
  String get auth_error_unexpected {
    return Intl.message(
      'Eitthvað fór úrskeiðis. Reyndu aftur.',
      name: 'auth_error_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `Styrkur lykilorðs`
  String get auth_password_strength_label {
    return Intl.message(
      'Styrkur lykilorðs',
      name: 'auth_password_strength_label',
      desc: '',
      args: [],
    );
  }

  /// `Þarf fleiri stafi`
  String get auth_password_strength_too_short {
    return Intl.message(
      'Þarf fleiri stafi',
      name: 'auth_password_strength_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Má vera sterkara`
  String get auth_password_strength_weak {
    return Intl.message(
      'Má vera sterkara',
      name: 'auth_password_strength_weak',
      desc: '',
      args: [],
    );
  }

  /// `Lítur ágætlega út`
  String get auth_password_strength_fair {
    return Intl.message(
      'Lítur ágætlega út',
      name: 'auth_password_strength_fair',
      desc: '',
      args: [],
    );
  }

  /// `Lítur vel út`
  String get auth_password_strength_strong {
    return Intl.message(
      'Lítur vel út',
      name: 'auth_password_strength_strong',
      desc: '',
      args: [],
    );
  }

  /// `Senda póst aftur`
  String get auth_email_confirmation_resend {
    return Intl.message(
      'Senda póst aftur',
      name: 'auth_email_confirmation_resend',
      desc: '',
      args: [],
    );
  }

  /// `Senda aftur eftir {seconds}s`
  String auth_email_confirmation_resend_cooldown(Object seconds) {
    return Intl.message(
      'Senda aftur eftir ${seconds}s',
      name: 'auth_email_confirmation_resend_cooldown',
      desc: '',
      args: [seconds],
    );
  }

  /// `Staðfestingarpóstur sendur.`
  String get auth_email_confirmation_resend_success {
    return Intl.message(
      'Staðfestingarpóstur sendur.',
      name: 'auth_email_confirmation_resend_success',
      desc: '',
      args: [],
    );
  }

  /// `Ég get ekki sent aftur núna. Reyndu aftur eftir smá stund.`
  String get auth_email_confirmation_resend_error {
    return Intl.message(
      'Ég get ekki sent aftur núna. Reyndu aftur eftir smá stund.',
      name: 'auth_email_confirmation_resend_error',
      desc: '',
      args: [],
    );
  }

  /// `Í smíðum`
  String get main_under_construction_title {
    return Intl.message(
      'Í smíðum',
      name: 'main_under_construction_title',
      desc: '',
      args: [],
    );
  }

  /// `Þessi hluti appsins er ekki tilbúinn enn.`
  String get main_under_construction_message {
    return Intl.message(
      'Þessi hluti appsins er ekki tilbúinn enn.',
      name: 'main_under_construction_message',
      desc: '',
      args: [],
    );
  }

  /// `Prófíll maka þíns er tilbúinn`
  String get landing_title {
    return Intl.message(
      'Prófíll maka þíns er tilbúinn',
      name: 'landing_title',
      desc: '',
      args: [],
    );
  }

  /// `Prófíll {name} er tilbúinn`
  String landing_title_named(Object name) {
    return Intl.message(
      'Prófíll $name er tilbúinn',
      name: 'landing_title_named',
      desc: '',
      args: [name],
    );
  }

  /// `Búðu til aðgang og þá fer BetterHalf að raða upp gjafahugmyndum, skilaboðadrögum og stefnumótaplönum fyrir maka þinn.`
  String get landing_subtitle {
    return Intl.message(
      'Búðu til aðgang og þá fer BetterHalf að raða upp gjafahugmyndum, skilaboðadrögum og stefnumótaplönum fyrir maka þinn.',
      name: 'landing_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Uppsetningin þín er tilbúin og bíður`
  String get landing_reassurance_saved {
    return Intl.message(
      'Uppsetningin þín er tilbúin og bíður',
      name: 'landing_reassurance_saved',
      desc: '',
      args: [],
    );
  }

  /// `Það er ókeypis að skrá sig`
  String get landing_reassurance_signup_free {
    return Intl.message(
      'Það er ókeypis að skrá sig',
      name: 'landing_reassurance_signup_free',
      desc: '',
      args: [],
    );
  }

  /// `Ókeypis að nota fyrstu vikuna`
  String get landing_reassurance_trial {
    return Intl.message(
      'Ókeypis að nota fyrstu vikuna',
      name: 'landing_reassurance_trial',
      desc: '',
      args: [],
    );
  }

  /// `Aðalforrit`
  String get main_title {
    return Intl.message('Aðalforrit', name: 'main_title', desc: '', args: []);
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
