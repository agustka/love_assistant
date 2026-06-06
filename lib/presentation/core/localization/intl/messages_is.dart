// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a is locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'is';

  static String m0(seconds) => "Senda aftur eftir ${seconds}s";

  static String m1(name) => "Prófíll ${name} er tilbúinn";

  static String m2(gender) => "Segðu mér frá gjafa- og matarsmekk ${gender}.";

  static String m3(name, gender) =>
      "Þá get ég mælt með hlutum sem ${name} mun elska og forðast það sem ${gender} fílar síður.";

  static String m4(gender) => "Segðu mér aðeins meira frá smekk ${gender}";

  static String m5(name) => "Hvernig mat finnst ${name} góður?";

  static String m6(gender) => "Hvers konar gjafir finnst ${gender} góðar?";

  static String m7(gender) => "Hefur ${gender} einhver áhugamál?";

  static String m8(gender) => "Hvaða ástarmál passa ${gender}?";

  static String m9(name) =>
      "Segðu mér hvað ${name} hefur gaman af svo tillögurnar passi betur.";

  static String m10(gender) =>
      "Veldu ástarmálin og tóninn sem henta ${gender} best.";

  static String m11(gender) => "Hvað finnst ${gender} skemmtilegt?";

  static String m12(name) => "Hvað dýrkar ${name}?";

  static String m13(gender) => "Hvernig talsmáti á best við ${gender}?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_name": MessageLookupByLibrary.simpleMessage("BetterHalf"),
    "auth_email_confirmation_confirmed": MessageLookupByLibrary.simpleMessage(
      "Ég hef staðfest netfangið mitt",
    ),
    "auth_email_confirmation_message": MessageLookupByLibrary.simpleMessage(
      "Ég sendi þér staðfestingarpóst. Opnaðu hann, ýttu á staðfestingarhlekkinn, farðu aftur í appið og ýttu svo á \"Ég hef staðfest netfangið mitt\".",
    ),
    "auth_email_confirmation_pending_error": MessageLookupByLibrary.simpleMessage(
      "Ég sé ekki enn að netfangið þitt hafi verið staðfest. Athugaðu pósthólfið og reyndu aftur.",
    ),
    "auth_email_confirmation_resend": MessageLookupByLibrary.simpleMessage(
      "Senda póst aftur",
    ),
    "auth_email_confirmation_resend_cooldown": m0,
    "auth_email_confirmation_resend_error":
        MessageLookupByLibrary.simpleMessage(
          "Ég get ekki sent aftur núna. Reyndu aftur eftir smá stund.",
        ),
    "auth_email_confirmation_resend_success":
        MessageLookupByLibrary.simpleMessage("Staðfestingarpóstur sendur."),
    "auth_email_confirmation_title": MessageLookupByLibrary.simpleMessage(
      "Staðfestu netfangið þitt",
    ),
    "auth_email_hint": MessageLookupByLibrary.simpleMessage("Netfang"),
    "auth_email_placeholder": MessageLookupByLibrary.simpleMessage(
      "you@example.com",
    ),
    "auth_error_network": MessageLookupByLibrary.simpleMessage(
      "Ég náði ekki sambandi við þjóninn. Athugaðu tenginguna og reyndu aftur.",
    ),
    "auth_error_unexpected": MessageLookupByLibrary.simpleMessage(
      "Eitthvað fór úrskeiðis. Reyndu aftur.",
    ),
    "auth_login_action": MessageLookupByLibrary.simpleMessage("Skrá inn"),
    "auth_login_apple": MessageLookupByLibrary.simpleMessage(
      "Skrá inn með Apple",
    ),
    "auth_login_email": MessageLookupByLibrary.simpleMessage(
      "Skrá inn með netfangi",
    ),
    "auth_login_email_invalid": MessageLookupByLibrary.simpleMessage(
      "Þetta netfang lítur ekki rétt út. Reyndu aftur.",
    ),
    "auth_login_error_invalid_credentials":
        MessageLookupByLibrary.simpleMessage(
          "Netfangið eða lykilorðið er rangt.",
        ),
    "auth_login_google": MessageLookupByLibrary.simpleMessage(
      "Skrá inn með Google",
    ),
    "auth_login_password_empty": MessageLookupByLibrary.simpleMessage(
      "Sláðu inn lykilorðið þitt.",
    ),
    "auth_login_password_too_short": MessageLookupByLibrary.simpleMessage(
      "Lykilorðið þarf að vera að minnsta kosti 6 stafir.",
    ),
    "auth_login_signup_action": MessageLookupByLibrary.simpleMessage(
      "Nýskráning",
    ),
    "auth_login_signup_prompt": MessageLookupByLibrary.simpleMessage(
      "Ertu ekki með aðgang?",
    ),
    "auth_login_subtitle": MessageLookupByLibrary.simpleMessage(
      "Skráðu þig inn til að halda áfram.",
    ),
    "auth_login_title": MessageLookupByLibrary.simpleMessage(
      "Velkomin(n) aftur",
    ),
    "auth_login_under_construction_message":
        MessageLookupByLibrary.simpleMessage(
          "Farðu til baka í bili. Enn er verið að smíða innskráningarflæðið.",
        ),
    "auth_login_under_construction_title": MessageLookupByLibrary.simpleMessage(
      "Innskráning er ekki tilbúin enn",
    ),
    "auth_password_hint": MessageLookupByLibrary.simpleMessage(
      "Lykilorð fyrir aðganginn",
    ),
    "auth_password_placeholder": MessageLookupByLibrary.simpleMessage(
      "Að minnsta kosti 6 stafir",
    ),
    "auth_password_strength_fair": MessageLookupByLibrary.simpleMessage(
      "Lítur ágætlega út",
    ),
    "auth_password_strength_label": MessageLookupByLibrary.simpleMessage(
      "Styrkur lykilorðs",
    ),
    "auth_password_strength_strong": MessageLookupByLibrary.simpleMessage(
      "Lítur vel út",
    ),
    "auth_password_strength_too_short": MessageLookupByLibrary.simpleMessage(
      "Þarf fleiri stafi",
    ),
    "auth_password_strength_weak": MessageLookupByLibrary.simpleMessage(
      "Má vera sterkara",
    ),
    "auth_signup_action": MessageLookupByLibrary.simpleMessage(
      "Búa til aðgang",
    ),
    "auth_signup_apple": MessageLookupByLibrary.simpleMessage("Skrá með Apple"),
    "auth_signup_email": MessageLookupByLibrary.simpleMessage(
      "Skrá með netfangi",
    ),
    "auth_signup_email_invalid": MessageLookupByLibrary.simpleMessage(
      "Þetta netfang lítur ekki rétt út. Reyndu aftur.",
    ),
    "auth_signup_error_email_exists": MessageLookupByLibrary.simpleMessage(
      "Það er nú þegar til aðgangur með þessu netfangi.",
    ),
    "auth_signup_google": MessageLookupByLibrary.simpleMessage(
      "Skrá með Google",
    ),
    "auth_signup_login_action": MessageLookupByLibrary.simpleMessage(
      "Innskráning",
    ),
    "auth_signup_login_prompt": MessageLookupByLibrary.simpleMessage(
      "Ertu nú þegar með aðgang?",
    ),
    "auth_signup_password_empty": MessageLookupByLibrary.simpleMessage(
      "Sláðu inn lykilorðið þitt.",
    ),
    "auth_signup_password_too_short": MessageLookupByLibrary.simpleMessage(
      "Lykilorðið þarf að vera að minnsta kosti 6 stafir.",
    ),
    "auth_signup_subtitle": MessageLookupByLibrary.simpleMessage(
      "Skráðu þig til að vista uppsetninguna og halda áfram.",
    ),
    "auth_signup_title": MessageLookupByLibrary.simpleMessage("Búa til aðgang"),
    "date_format_month_and_day": MessageLookupByLibrary.simpleMessage(
      "dd. MMMM",
    ),
    "global_cancel": MessageLookupByLibrary.simpleMessage("Hætta við"),
    "global_confirm": MessageLookupByLibrary.simpleMessage("Staðfesta"),
    "global_done": MessageLookupByLibrary.simpleMessage("Búið"),
    "global_enter_custom": MessageLookupByLibrary.simpleMessage("Þín eigin"),
    "global_food_chocolate": MessageLookupByLibrary.simpleMessage("Súkkulaði"),
    "global_food_coffee": MessageLookupByLibrary.simpleMessage("Kaffi"),
    "global_food_desserts": MessageLookupByLibrary.simpleMessage("Eftirréttir"),
    "global_food_home_made": MessageLookupByLibrary.simpleMessage("Heimagert"),
    "global_food_noodle_dishes": MessageLookupByLibrary.simpleMessage("Núðlur"),
    "global_food_pasta": MessageLookupByLibrary.simpleMessage("Pasta"),
    "global_food_pizza": MessageLookupByLibrary.simpleMessage("Pítsur"),
    "global_food_salads": MessageLookupByLibrary.simpleMessage("Salöt"),
    "global_food_seafood": MessageLookupByLibrary.simpleMessage("Sjávarmeti"),
    "global_food_spicy_food": MessageLookupByLibrary.simpleMessage(
      "Sterkur matur",
    ),
    "global_food_street_food": MessageLookupByLibrary.simpleMessage(
      "Götumatur",
    ),
    "global_food_wine": MessageLookupByLibrary.simpleMessage("Vín"),
    "global_generic_field_error": MessageLookupByLibrary.simpleMessage(
      "Þetta atriði þarf að vera útfyllt",
    ),
    "global_gift_experience": MessageLookupByLibrary.simpleMessage(
      "Upplifanir",
    ),
    "global_gift_food_and_drinks": MessageLookupByLibrary.simpleMessage(
      "Matur og drykkur",
    ),
    "global_gift_hobbies": MessageLookupByLibrary.simpleMessage("Áhugamál"),
    "global_gift_luxury_items": MessageLookupByLibrary.simpleMessage(
      "Munaðarvörur",
    ),
    "global_gift_practical_gifts": MessageLookupByLibrary.simpleMessage(
      "Hagnýtar",
    ),
    "global_gift_sentimental": MessageLookupByLibrary.simpleMessage(
      "Persónulegar",
    ),
    "global_gift_surprise_me": MessageLookupByLibrary.simpleMessage(
      "Komdu mér á óvart",
    ),
    "global_gift_wellness": MessageLookupByLibrary.simpleMessage("Vellíðan"),
    "global_hide_password": MessageLookupByLibrary.simpleMessage(
      "Fela lykilorð",
    ),
    "global_hobby_cooking": MessageLookupByLibrary.simpleMessage("Eldamennska"),
    "global_hobby_crafting": MessageLookupByLibrary.simpleMessage("Föndur"),
    "global_hobby_fishing_and_hunting": MessageLookupByLibrary.simpleMessage(
      "Veiðar",
    ),
    "global_hobby_fitness": MessageLookupByLibrary.simpleMessage("Heilsa"),
    "global_hobby_gaming": MessageLookupByLibrary.simpleMessage("Tölvuleikir"),
    "global_hobby_gardening": MessageLookupByLibrary.simpleMessage("Garðyrkja"),
    "global_hobby_movies_and_tv": MessageLookupByLibrary.simpleMessage(
      "Myndir og sjónvarp",
    ),
    "global_hobby_music": MessageLookupByLibrary.simpleMessage("Tónlist"),
    "global_hobby_reading": MessageLookupByLibrary.simpleMessage(
      "Lestur og bækur",
    ),
    "global_hobby_sports": MessageLookupByLibrary.simpleMessage(
      "Íþróttir og sport",
    ),
    "global_hobby_traveling": MessageLookupByLibrary.simpleMessage("Ferðalög"),
    "global_love_language_acts_of_service":
        MessageLookupByLibrary.simpleMessage("Þjónusta"),
    "global_love_language_physical_touch": MessageLookupByLibrary.simpleMessage(
      "Líkamleg snerting",
    ),
    "global_love_language_quality_time": MessageLookupByLibrary.simpleMessage(
      "Tími saman",
    ),
    "global_love_language_receiving_gifts":
        MessageLookupByLibrary.simpleMessage("Að fá gjafir"),
    "global_love_language_words_of_affirmation":
        MessageLookupByLibrary.simpleMessage("Falleg orð"),
    "global_more": MessageLookupByLibrary.simpleMessage("Meira"),
    "global_optional": MessageLookupByLibrary.simpleMessage("Valkvæmt"),
    "global_pick_date": MessageLookupByLibrary.simpleMessage(
      "Veldu dagsetningu",
    ),
    "global_pronoun_custom": MessageLookupByLibrary.simpleMessage("Sérsniðið"),
    "global_pronoun_he_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Hans",
    ),
    "global_pronoun_he_him": MessageLookupByLibrary.simpleMessage("Hann"),
    "global_pronoun_he_nefnifall": MessageLookupByLibrary.simpleMessage("Hann"),
    "global_pronoun_he_thagufall": MessageLookupByLibrary.simpleMessage(
      "Honum",
    ),
    "global_pronoun_he_tholfall": MessageLookupByLibrary.simpleMessage("Hann"),
    "global_pronoun_invalid_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Þeirra",
    ),
    "global_pronoun_invalid_nefnifall": MessageLookupByLibrary.simpleMessage(
      "Þau",
    ),
    "global_pronoun_invalid_thagufall": MessageLookupByLibrary.simpleMessage(
      "Þeim",
    ),
    "global_pronoun_invalid_tholfall": MessageLookupByLibrary.simpleMessage(
      "Þau",
    ),
    "global_pronoun_she_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Hennar",
    ),
    "global_pronoun_she_her": MessageLookupByLibrary.simpleMessage("Hún"),
    "global_pronoun_she_nefnifall": MessageLookupByLibrary.simpleMessage("Hún"),
    "global_pronoun_she_thagufall": MessageLookupByLibrary.simpleMessage(
      "Henni",
    ),
    "global_pronoun_she_tholfall": MessageLookupByLibrary.simpleMessage("Hana"),
    "global_pronoun_they_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Háns",
    ),
    "global_pronoun_they_nefnifall": MessageLookupByLibrary.simpleMessage(
      "Hán",
    ),
    "global_pronoun_they_thagufall": MessageLookupByLibrary.simpleMessage(
      "Háni",
    ),
    "global_pronoun_they_them": MessageLookupByLibrary.simpleMessage("Hán"),
    "global_pronoun_they_tholfall": MessageLookupByLibrary.simpleMessage("Hán"),
    "global_relationship_type_dating": MessageLookupByLibrary.simpleMessage(
      "Á föstu",
    ),
    "global_relationship_type_engaged": MessageLookupByLibrary.simpleMessage(
      "Trúlofuð",
    ),
    "global_relationship_type_life_partners":
        MessageLookupByLibrary.simpleMessage("Lífsfélagar"),
    "global_relationship_type_married": MessageLookupByLibrary.simpleMessage(
      "Gift",
    ),
    "global_relationship_type_other": MessageLookupByLibrary.simpleMessage(
      "Annað",
    ),
    "global_required": MessageLookupByLibrary.simpleMessage("Nauðsynlegt"),
    "global_show_password": MessageLookupByLibrary.simpleMessage(
      "Sýna lykilorð",
    ),
    "global_tone_of_voice_casual": MessageLookupByLibrary.simpleMessage(
      "Hversdagslegur",
    ),
    "global_tone_of_voice_formal": MessageLookupByLibrary.simpleMessage(
      "Formlegur",
    ),
    "global_tone_of_voice_playful": MessageLookupByLibrary.simpleMessage(
      "Hnyttinn",
    ),
    "global_tone_of_voice_romantic": MessageLookupByLibrary.simpleMessage(
      "Rómantískur",
    ),
    "landing_reassurance_saved": MessageLookupByLibrary.simpleMessage(
      "Uppsetningin þín er tilbúin og bíður",
    ),
    "landing_reassurance_signup_free": MessageLookupByLibrary.simpleMessage(
      "Það er ókeypis að skrá sig",
    ),
    "landing_reassurance_trial": MessageLookupByLibrary.simpleMessage(
      "Ókeypis að nota fyrstu vikuna",
    ),
    "landing_subtitle": MessageLookupByLibrary.simpleMessage(
      "Búðu til aðgang og þá fer BetterHalf að raða upp gjafahugmyndum, skilaboðadrögum og stefnumótaplönum fyrir maka þinn.",
    ),
    "landing_title": MessageLookupByLibrary.simpleMessage(
      "Prófíll maka þíns er tilbúinn",
    ),
    "landing_title_named": m1,
    "main_title": MessageLookupByLibrary.simpleMessage("Aðalforrit"),
    "main_under_construction_message": MessageLookupByLibrary.simpleMessage(
      "Þessi hluti appsins er ekki tilbúinn enn.",
    ),
    "main_under_construction_title": MessageLookupByLibrary.simpleMessage(
      "Í smíðum",
    ),
    "ordinal_suffix_first": MessageLookupByLibrary.simpleMessage("."),
    "ordinal_suffix_generic": MessageLookupByLibrary.simpleMessage("."),
    "ordinal_suffix_global": MessageLookupByLibrary.simpleMessage("."),
    "ordinal_suffix_second": MessageLookupByLibrary.simpleMessage("."),
    "ordinal_suffix_third": MessageLookupByLibrary.simpleMessage("."),
    "settings_pick_language": MessageLookupByLibrary.simpleMessage(
      "Veldu tungumál",
    ),
    "wizard_greetings": MessageLookupByLibrary.simpleMessage(
      "Þinn eigin BetterHalf",
    ),
    "wizard_greetings_message_1": MessageLookupByLibrary.simpleMessage(
      "BetterHalf heldur utan um það sem skiptir maka þinn máli og hjálpar þér að gera eitthvað í því.",
    ),
    "wizard_greetings_message_2": MessageLookupByLibrary.simpleMessage(
      "Ég minni þig á dagsetningarnar sem skipta máli, skrifa drög að skilaboðum í þínum tón og raða upp gjafa- og stefnumótahugmyndum sem maki þinn myndi raunverulega vilja.",
    ),
    "wizard_next": MessageLookupByLibrary.simpleMessage("Næsta"),
    "wizard_partner_anniversary_explanation": MessageLookupByLibrary.simpleMessage(
      "Ég nota afmælisdaginn ykkar svo þú hafir nægan tíma til að skipuleggja eða redda einhverju sérstöku fyrir maka þinn.",
    ),
    "wizard_partner_anniversary_hint": MessageLookupByLibrary.simpleMessage(
      "Veldu stóra daginn ykkar",
    ),
    "wizard_partner_anniversary_skip_message":
        MessageLookupByLibrary.simpleMessage(
          "Ertu viss um að þú viljir sleppa afmælisdeginum?",
        ),
    "wizard_partner_anniversary_skip_no_cancel":
        MessageLookupByLibrary.simpleMessage("Nei"),
    "wizard_partner_anniversary_skip_title":
        MessageLookupByLibrary.simpleMessage("Sleppa afmælisdegi?"),
    "wizard_partner_anniversary_skip_yes_confirm":
        MessageLookupByLibrary.simpleMessage("Já, sleppa"),
    "wizard_partner_anniversary_title": MessageLookupByLibrary.simpleMessage(
      "Eigið þið afmælisdag?",
    ),
    "wizard_partner_birthday_explanation": MessageLookupByLibrary.simpleMessage(
      "Ég nota afmælisdag maka þíns svo þú hafir nægan tíma til að skipuleggja eitthvað sérstakt fyrir maka þinn.",
    ),
    "wizard_partner_birthday_hint": MessageLookupByLibrary.simpleMessage(
      "Veldu afmælisdagsetningu",
    ),
    "wizard_partner_birthday_title": MessageLookupByLibrary.simpleMessage(
      "Afmæli",
    ),
    "wizard_partner_food_and_gifts_message_1": m2,
    "wizard_partner_food_and_gifts_message_2": m3,
    "wizard_partner_food_and_gifts_title": m4,
    "wizard_partner_food_likes_title": m5,
    "wizard_partner_foods_explanation": MessageLookupByLibrary.simpleMessage(
      "Uppáhaldsmatur maka þíns hjálpar mér að velja matargjafir og veitingastaði sem passa.",
    ),
    "wizard_partner_gift_likes_title": m6,
    "wizard_partner_gift_types_explanation": MessageLookupByLibrary.simpleMessage(
      "Uppáhalds gjafategundir maka þíns hjálpa mér að stinga upp á gjöfum sem passa.\nUpplifanir: Til dæmis miðar á viðburði, ferðalög eða stefnumót.\nPersónulegir hlutir: Til dæmis handgerðar gjafir, persónuleg bréf eða myndaalbúm.\nHagnýtar gjafir: Til dæmis tæki, verkfæri eða eldhúsdót.\nMunaðarvörur: Til dæmis skartgripir, hönnunarfatnaður eða vandaðir aukahlutir.\nÁhugamál: Til dæmis bækur, hljóðfæri eða listavörur.\nMatur og drykkur: Til dæmis vandað súkkulaði, vín eða áskriftarkassar.\nKomdu mér á óvart: Þegar þú vilt að ég verði skapandi.",
    ),
    "wizard_partner_hobbies_explanation": MessageLookupByLibrary.simpleMessage(
      "Áhugamál maka þíns hjálpa mér að velja afþreyingu og gjafir sem passa.",
    ),
    "wizard_partner_hobbies_title": m7,
    "wizard_partner_love_language_explanation":
        MessageLookupByLibrary.simpleMessage(
          "Það er oft talað um fimm leiðir til að sýna ást.\nGæðatími: Að eiga óskiptan og innihaldsríkan tíma saman.\nFalleg orð: Að sýna ást og þakklæti með hlýjum og uppbyggilegum orðum.\nÞjónusta: Að sýna ást með því að gera eitthvað hjálplegt eða hugulsamt.\nLíkamleg snerting: Að sýna ást með líkamlegum merkjum eins og faðmlögum, kossum og annarri snertingu.\nGjafir: Að gefa og þiggja gjafir sem tákn um ást.",
        ),
    "wizard_partner_love_language_title": m8,
    "wizard_partner_loves_message_1": m9,
    "wizard_partner_loves_message_2": MessageLookupByLibrary.simpleMessage(
      "Þetta hjálpar mér að láta tillögurnar og skilaboðin hitta í mark.",
    ),
    "wizard_partner_loves_message_initial_1": m10,
    "wizard_partner_loves_title": m11,
    "wizard_partner_more_details": m12,
    "wizard_partner_profile_birthday_missing":
        MessageLookupByLibrary.simpleMessage("Afmæli er nauðsynlegt"),
    "wizard_partner_profile_message_1_extended":
        MessageLookupByLibrary.simpleMessage(
          "Segðu mér aðeins frá maka þínum, eins og nafni, fornöfnum og mikilvægum dagsetningum.",
        ),
    "wizard_partner_profile_message_1_shortened":
        MessageLookupByLibrary.simpleMessage(
          "Segðu mér aðeins frá maka þínum, eins og nafni og fornöfnum.",
        ),
    "wizard_partner_profile_message_initial_1":
        MessageLookupByLibrary.simpleMessage(
          "Byrjum á grunnatriðunum: nafni og kyni.",
        ),
    "wizard_partner_profile_name_hint": MessageLookupByLibrary.simpleMessage(
      "Nafn maka",
    ),
    "wizard_partner_profile_name_missing": MessageLookupByLibrary.simpleMessage(
      "Nafn er nauðsynlegt",
    ),
    "wizard_partner_profile_name_title": MessageLookupByLibrary.simpleMessage(
      "Hvað heitir maki þinn?",
    ),
    "wizard_partner_profile_pronoun_missing":
        MessageLookupByLibrary.simpleMessage("Fornafn er nauðsynlegt"),
    "wizard_partner_profile_title": MessageLookupByLibrary.simpleMessage(
      "Byrjum á grunnatriðunum",
    ),
    "wizard_partner_pronouns_hint": MessageLookupByLibrary.simpleMessage(
      "Veldu fornöfn maka þíns",
    ),
    "wizard_partner_pronouns_title": MessageLookupByLibrary.simpleMessage(
      "Hvernig á ég að tala um maka þinn?",
    ),
    "wizard_partner_relationship_type_explanation":
        MessageLookupByLibrary.simpleMessage(
          "Þetta hjálpar mér að láta áminningar, skilaboð og tillögur passa við stöðuna í sambandinu ykkar",
        ),
    "wizard_partner_relationship_type_hint":
        MessageLookupByLibrary.simpleMessage("Veldu tegund sambands"),
    "wizard_partner_relationship_type_title":
        MessageLookupByLibrary.simpleMessage("Tegund sambands"),
    "wizard_partner_tone_of_voice_explanation":
        MessageLookupByLibrary.simpleMessage(
          "Rétti tónninn hjálpar mér að skrifa skilaboð sem hitta í mark hjá maka þínum.",
        ),
    "wizard_partner_tone_of_voice_hint": MessageLookupByLibrary.simpleMessage(
      "Veldu talsmáta",
    ),
    "wizard_partner_tone_of_voice_title": m13,
    "wizard_previous": MessageLookupByLibrary.simpleMessage("Fyrri"),
    "wizard_start": MessageLookupByLibrary.simpleMessage("Byrjum"),
    "wizard_title": MessageLookupByLibrary.simpleMessage("Uppsetning"),
  };
}
