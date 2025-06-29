// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(gender) =>
      "Please share with me ${gender} gift and food preferences.";

  static String m1(name, gender) =>
      "This ensures I recommend things ${name} loves and can avoid what ${gender} may not like as much.";

  static String m2(gender) => "Tell me a bit more about ${gender} tastes";

  static String m3(gender) => "Does ${gender} have any hobbies?";

  static String m4(gender) => "Which love languages match ${gender}?";

  static String m5(gender) =>
      "Tell me about ${gender} love languages and preferred tone of voice so I can create messages that hit the mark.";

  static String m6(gender) => "What does ${gender} like?";

  static String m7(gender) => "What tone of voice fits ${gender} best?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_name": MessageLookupByLibrary.simpleMessage("LoveAssistant"),
    "date_format_month_and_day": MessageLookupByLibrary.simpleMessage(
      "MMMM dd",
    ),
    "global_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "global_confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "global_done": MessageLookupByLibrary.simpleMessage("Done"),
    "global_enter_custom": MessageLookupByLibrary.simpleMessage(
      "Enter custom value",
    ),
    "global_generic_field_error": MessageLookupByLibrary.simpleMessage(
      "This entry is invalid",
    ),
    "global_hobby_cooking": MessageLookupByLibrary.simpleMessage("Cooking"),
    "global_hobby_crafting": MessageLookupByLibrary.simpleMessage("Crafting"),
    "global_hobby_fishing_and_hunting": MessageLookupByLibrary.simpleMessage(
      "Fishing and hunting",
    ),
    "global_hobby_fitness": MessageLookupByLibrary.simpleMessage("Fitness"),
    "global_hobby_gaming": MessageLookupByLibrary.simpleMessage("Gaming"),
    "global_hobby_gardening": MessageLookupByLibrary.simpleMessage("Gardening"),
    "global_hobby_movies_and_tv": MessageLookupByLibrary.simpleMessage(
      "Movies & TV",
    ),
    "global_hobby_music": MessageLookupByLibrary.simpleMessage("Music"),
    "global_hobby_reading": MessageLookupByLibrary.simpleMessage("Reading"),
    "global_hobby_sports": MessageLookupByLibrary.simpleMessage("Sports"),
    "global_hobby_traveling": MessageLookupByLibrary.simpleMessage("Traveling"),
    "global_love_language_acts_of_service":
        MessageLookupByLibrary.simpleMessage("Acts of service"),
    "global_love_language_physical_touch": MessageLookupByLibrary.simpleMessage(
      "Physical touch",
    ),
    "global_love_language_quality_time": MessageLookupByLibrary.simpleMessage(
      "Quality time",
    ),
    "global_love_language_receiving_gifts":
        MessageLookupByLibrary.simpleMessage("Receiving gifts"),
    "global_love_language_words_of_affirmation":
        MessageLookupByLibrary.simpleMessage("Words of affirmation"),
    "global_more": MessageLookupByLibrary.simpleMessage("More"),
    "global_optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "global_pick_date": MessageLookupByLibrary.simpleMessage("Pick a date"),
    "global_pronoun_custom": MessageLookupByLibrary.simpleMessage("Custom"),
    "global_pronoun_he_eignarfall": MessageLookupByLibrary.simpleMessage("His"),
    "global_pronoun_he_him": MessageLookupByLibrary.simpleMessage("He"),
    "global_pronoun_he_nefnifall": MessageLookupByLibrary.simpleMessage("He"),
    "global_pronoun_he_thagufall": MessageLookupByLibrary.simpleMessage("Him"),
    "global_pronoun_he_tholfall": MessageLookupByLibrary.simpleMessage("Him"),
    "global_pronoun_invalid_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Theirs",
    ),
    "global_pronoun_invalid_nefnifall": MessageLookupByLibrary.simpleMessage(
      "Them",
    ),
    "global_pronoun_invalid_thagufall": MessageLookupByLibrary.simpleMessage(
      "Them",
    ),
    "global_pronoun_invalid_tholfall": MessageLookupByLibrary.simpleMessage(
      "They",
    ),
    "global_pronoun_she_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Hers",
    ),
    "global_pronoun_she_her": MessageLookupByLibrary.simpleMessage("She"),
    "global_pronoun_she_nefnifall": MessageLookupByLibrary.simpleMessage("She"),
    "global_pronoun_she_thagufall": MessageLookupByLibrary.simpleMessage("Her"),
    "global_pronoun_she_tholfall": MessageLookupByLibrary.simpleMessage("Her"),
    "global_pronoun_they_eignarfall": MessageLookupByLibrary.simpleMessage(
      "Theirs",
    ),
    "global_pronoun_they_nefnifall": MessageLookupByLibrary.simpleMessage(
      "They",
    ),
    "global_pronoun_they_thagufall": MessageLookupByLibrary.simpleMessage(
      "Them",
    ),
    "global_pronoun_they_them": MessageLookupByLibrary.simpleMessage("They"),
    "global_pronoun_they_tholfall": MessageLookupByLibrary.simpleMessage(
      "Them",
    ),
    "global_required": MessageLookupByLibrary.simpleMessage("Required"),
    "global_tone_of_voice_casual": MessageLookupByLibrary.simpleMessage(
      "Casual",
    ),
    "global_tone_of_voice_formal": MessageLookupByLibrary.simpleMessage(
      "Formal",
    ),
    "global_tone_of_voice_playful": MessageLookupByLibrary.simpleMessage(
      "Playful",
    ),
    "global_tone_of_voice_romantic": MessageLookupByLibrary.simpleMessage(
      "Romantic",
    ),
    "ordinal_suffix_first": MessageLookupByLibrary.simpleMessage("st"),
    "ordinal_suffix_generic": MessageLookupByLibrary.simpleMessage("th"),
    "ordinal_suffix_global": MessageLookupByLibrary.simpleMessage("."),
    "ordinal_suffix_second": MessageLookupByLibrary.simpleMessage("nd"),
    "ordinal_suffix_third": MessageLookupByLibrary.simpleMessage("rd"),
    "settings_pick_language": MessageLookupByLibrary.simpleMessage(
      "Select language",
    ),
    "wizard_greetings": MessageLookupByLibrary.simpleMessage(
      "✨ Your Personal Love-Assistant",
    ),
    "wizard_greetings_message_1": MessageLookupByLibrary.simpleMessage(
      "Hi, I’m here to help you nurture your relationship with your loved one.",
    ),
    "wizard_greetings_message_2": MessageLookupByLibrary.simpleMessage(
      "I’ll remind you of special dates, craft personalized messages, and suggest thoughtful ideas.",
    ),
    "wizard_next": MessageLookupByLibrary.simpleMessage("Next"),
    "wizard_partner_anniversary_explanation": MessageLookupByLibrary.simpleMessage(
      "I use your anniversary date to make sure you have enough time to plan or get something special for your loved one.",
    ),
    "wizard_partner_anniversary_hint": MessageLookupByLibrary.simpleMessage(
      "Pick your big date",
    ),
    "wizard_partner_anniversary_skip_message":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to skip the anniversary date?",
        ),
    "wizard_partner_anniversary_skip_no_cancel":
        MessageLookupByLibrary.simpleMessage("No"),
    "wizard_partner_anniversary_skip_title":
        MessageLookupByLibrary.simpleMessage("Skip anniversary?"),
    "wizard_partner_anniversary_skip_yes_confirm":
        MessageLookupByLibrary.simpleMessage("Yes, skip"),
    "wizard_partner_anniversary_title": MessageLookupByLibrary.simpleMessage(
      "Do you have an anniversary date?",
    ),
    "wizard_partner_birthday_explanation": MessageLookupByLibrary.simpleMessage(
      "I use your partner’s birthday to make sure you have enough time to plan something special for your loved one.",
    ),
    "wizard_partner_birthday_hint": MessageLookupByLibrary.simpleMessage(
      "Pick birthday date",
    ),
    "wizard_partner_birthday_title": MessageLookupByLibrary.simpleMessage(
      "When is your partner’s birthday?",
    ),
    "wizard_partner_food_and_gifts_message_1": m0,
    "wizard_partner_food_and_gifts_message_2": m1,
    "wizard_partner_food_and_gifts_title": m2,
    "wizard_partner_foods_explanation": MessageLookupByLibrary.simpleMessage(
      "Sharing your loved one’s favorite foods will help me select the correct food gifts and restaurant suggestons.",
    ),
    "wizard_partner_gift_types_explanation": MessageLookupByLibrary.simpleMessage(
      "Selecting your loved one’s favorite types will help me suggest appropriate gifts.\nExperiences: E.g., tickets to events, vacations, date nights.\nSentimental Items: E.g., handmade gifts, personal letters, photo albums.\nPractical Gifts: E.g., gadgets, tools, kitchenware.\nLuxury Items: E.g., jewelry, designer clothing, high-end accessories.\nHobbies & Interests: E.g., books, music instruments, art supplies.\nFood & Drinks: E.g., gourmet chocolates, wine, or subscription boxes.\nSurprise Me: For when you want me to get creative.",
    ),
    "wizard_partner_hobbies_explanation": MessageLookupByLibrary.simpleMessage(
      "Sharing your loved one’s hobbies will help me select a variety of appropriate activities and gifts.",
    ),
    "wizard_partner_hobbies_title": m3,
    "wizard_partner_love_language_explanation":
        MessageLookupByLibrary.simpleMessage(
          "There are said to be five forms of expressions of love.\nQuality Time: Spending undivided, meaningful time together.\nWords of Affirmation: Expressing love and appreciation through kind and affirming words.\nActs of Service: Showing love by doing helpful or thoughtful tasks.\nPhysical Touch: Expressing love through physical gestures like hugs, kisses, and other forms of touch.\nReceiving Gifts: Giving and receiving thoughtful gifts as a symbol of love.",
        ),
    "wizard_partner_love_language_title": m4,
    "wizard_partner_loves_message_1": MessageLookupByLibrary.simpleMessage(
      "Share the things your partner loves to help me craft personalized experiences.",
    ),
    "wizard_partner_loves_message_2": MessageLookupByLibrary.simpleMessage(
      "This ensures that my suggestions and messages are truly meaningful.",
    ),
    "wizard_partner_loves_message_initial_1": m5,
    "wizard_partner_loves_title": m6,
    "wizard_partner_profile_birthday_missing":
        MessageLookupByLibrary.simpleMessage("Birthday is required"),
    "wizard_partner_profile_message_1": MessageLookupByLibrary.simpleMessage(
      "We’ll start with the basics — like their name, pronouns, and important dates.",
    ),
    "wizard_partner_profile_message_2": MessageLookupByLibrary.simpleMessage(
      "This helps me personalize reminders and messages just for them.",
    ),
    "wizard_partner_profile_message_initial_1":
        MessageLookupByLibrary.simpleMessage(
          "We’ll start with the basics; name and gender.",
        ),
    "wizard_partner_profile_name_hint": MessageLookupByLibrary.simpleMessage(
      "Partner name",
    ),
    "wizard_partner_profile_name_missing": MessageLookupByLibrary.simpleMessage(
      "Name is required",
    ),
    "wizard_partner_profile_name_title": MessageLookupByLibrary.simpleMessage(
      "What’s your partner’s name?",
    ),
    "wizard_partner_profile_pronoun_missing":
        MessageLookupByLibrary.simpleMessage("Pronoun is required"),
    "wizard_partner_profile_title": MessageLookupByLibrary.simpleMessage(
      "Tell Me About Your Partner",
    ),
    "wizard_partner_pronouns_hint": MessageLookupByLibrary.simpleMessage(
      "Select your partner’s pronouns",
    ),
    "wizard_partner_pronouns_title": MessageLookupByLibrary.simpleMessage(
      "How should I refer to your partner?",
    ),
    "wizard_partner_tone_of_voice_explanation":
        MessageLookupByLibrary.simpleMessage(
          "Selecting the correct tone of voice helps me craft messages that resonate with your loved one better.",
        ),
    "wizard_partner_tone_of_voice_hint": MessageLookupByLibrary.simpleMessage(
      "Select tone of voice",
    ),
    "wizard_partner_tone_of_voice_title": m7,
    "wizard_previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "wizard_start": MessageLookupByLibrary.simpleMessage("Begin"),
    "wizard_title": MessageLookupByLibrary.simpleMessage("Partner setup"),
  };
}
