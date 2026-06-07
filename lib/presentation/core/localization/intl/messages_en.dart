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

  static String m0(seconds) => "Resend in ${seconds}s";

  static String m1(name) => "${name}\'s profile is ready";

  static String m2(gender) =>
      "Share ${gender} gift and food preferences with me.";

  static String m3(name, gender) =>
      "This ensures I recommend things ${name} loves and can avoid what ${gender} may not like as much.";

  static String m4(gender) => "Tell me a bit more about ${gender} tastes";

  static String m5(name) => "What food does ${name} like?";

  static String m6(gender) => "Which kind of gifts does ${gender} like?";

  static String m7(gender) => "Does ${gender} have any hobbies?";

  static String m8(gender) => "Which love languages match ${gender}?";

  static String m9(name) =>
      "Share the things ${name} enjoys so the suggestions fit.";

  static String m10(gender) =>
      "Choose the love languages and tone that fit ${gender} best.";

  static String m11(gender) => "What does ${gender} like?";

  static String m12(name) => "How does ${name} feel loved?";

  static String m13(gender) => "What tone of voice fits ${gender} best?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "app_name": MessageLookupByLibrary.simpleMessage("BetterHalf"),
    "auth_email_confirmation_confirmed": MessageLookupByLibrary.simpleMessage(
      "I\'ve confirmed my email",
    ),
    "auth_email_confirmation_message": MessageLookupByLibrary.simpleMessage(
      "I sent you a confirmation email. Open it, tap the confirmation link, return to the app, and then tap \"I\'ve confirmed my email\".",
    ),
    "auth_email_confirmation_pending_error": MessageLookupByLibrary.simpleMessage(
      "I haven\'t seen your email confirmed yet. Check your inbox and try again.",
    ),
    "auth_email_confirmation_resend": MessageLookupByLibrary.simpleMessage(
      "Resend email",
    ),
    "auth_email_confirmation_resend_cooldown": m0,
    "auth_email_confirmation_resend_error":
        MessageLookupByLibrary.simpleMessage(
          "Couldn\'t resend right now. Try again in a moment.",
        ),
    "auth_email_confirmation_resend_success":
        MessageLookupByLibrary.simpleMessage("Confirmation email sent."),
    "auth_email_confirmation_title": MessageLookupByLibrary.simpleMessage(
      "Confirm your email",
    ),
    "auth_email_hint": MessageLookupByLibrary.simpleMessage("Email"),
    "auth_email_placeholder": MessageLookupByLibrary.simpleMessage(
      "you@example.com",
    ),
    "auth_error_network": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t reach the server. Check your connection and try again.",
    ),
    "auth_error_unexpected": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Try again.",
    ),
    "auth_login_action": MessageLookupByLibrary.simpleMessage("Log in"),
    "auth_login_apple": MessageLookupByLibrary.simpleMessage(
      "Sign in with Apple",
    ),
    "auth_login_email": MessageLookupByLibrary.simpleMessage(
      "Sign in with email",
    ),
    "auth_login_email_invalid": MessageLookupByLibrary.simpleMessage(
      "That email doesn\'t look right. Try again.",
    ),
    "auth_login_error_invalid_credentials":
        MessageLookupByLibrary.simpleMessage(
          "That email or password is wrong.",
        ),
    "auth_login_google": MessageLookupByLibrary.simpleMessage(
      "Sign in with Google",
    ),
    "auth_login_password_empty": MessageLookupByLibrary.simpleMessage(
      "Enter your password.",
    ),
    "auth_login_password_too_short": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters.",
    ),
    "auth_login_signup_action": MessageLookupByLibrary.simpleMessage("Sign up"),
    "auth_login_signup_prompt": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "auth_login_subtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to continue.",
    ),
    "auth_login_title": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "auth_login_under_construction_message":
        MessageLookupByLibrary.simpleMessage(
          "Go back for now. The login flow is still being built.",
        ),
    "auth_login_under_construction_title": MessageLookupByLibrary.simpleMessage(
      "Login is not ready yet",
    ),
    "auth_password_hint": MessageLookupByLibrary.simpleMessage("Password"),
    "auth_password_placeholder": MessageLookupByLibrary.simpleMessage(
      "At least 6 characters",
    ),
    "auth_password_strength_fair": MessageLookupByLibrary.simpleMessage("Fair"),
    "auth_password_strength_label": MessageLookupByLibrary.simpleMessage(
      "Password strength",
    ),
    "auth_password_strength_strong": MessageLookupByLibrary.simpleMessage(
      "Strong",
    ),
    "auth_password_strength_too_short": MessageLookupByLibrary.simpleMessage(
      "Too short",
    ),
    "auth_password_strength_weak": MessageLookupByLibrary.simpleMessage("Weak"),
    "auth_signup_action": MessageLookupByLibrary.simpleMessage(
      "Create account",
    ),
    "auth_signup_apple": MessageLookupByLibrary.simpleMessage(
      "Sign up with Apple",
    ),
    "auth_signup_email": MessageLookupByLibrary.simpleMessage(
      "Sign up with email",
    ),
    "auth_signup_email_invalid": MessageLookupByLibrary.simpleMessage(
      "That email doesn\'t look right. Try again.",
    ),
    "auth_signup_error_email_exists": MessageLookupByLibrary.simpleMessage(
      "An account with this email already exists.",
    ),
    "auth_signup_google": MessageLookupByLibrary.simpleMessage(
      "Sign up with Google",
    ),
    "auth_signup_login_action": MessageLookupByLibrary.simpleMessage("Log in"),
    "auth_signup_login_prompt": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "auth_signup_password_empty": MessageLookupByLibrary.simpleMessage(
      "Enter a password.",
    ),
    "auth_signup_password_too_short": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters.",
    ),
    "auth_signup_subtitle": MessageLookupByLibrary.simpleMessage(
      "Sign up to save your setup and continue.",
    ),
    "auth_signup_title": MessageLookupByLibrary.simpleMessage(
      "Create your account",
    ),
    "date_format_month_and_day": MessageLookupByLibrary.simpleMessage(
      "MMMM dd",
    ),
    "global_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "global_confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "global_done": MessageLookupByLibrary.simpleMessage("Done"),
    "global_enter_custom": MessageLookupByLibrary.simpleMessage(
      "Enter custom value",
    ),
    "global_food_chocolate": MessageLookupByLibrary.simpleMessage("Chocolate"),
    "global_food_coffee": MessageLookupByLibrary.simpleMessage("Coffee"),
    "global_food_desserts": MessageLookupByLibrary.simpleMessage("Dessert"),
    "global_food_home_made": MessageLookupByLibrary.simpleMessage("Home made"),
    "global_food_noodle_dishes": MessageLookupByLibrary.simpleMessage(
      "Noodles",
    ),
    "global_food_pasta": MessageLookupByLibrary.simpleMessage("Pasta"),
    "global_food_pizza": MessageLookupByLibrary.simpleMessage("Pizza"),
    "global_food_salads": MessageLookupByLibrary.simpleMessage("Salat"),
    "global_food_seafood": MessageLookupByLibrary.simpleMessage("Seafood"),
    "global_food_spicy_food": MessageLookupByLibrary.simpleMessage("Spicy"),
    "global_food_street_food": MessageLookupByLibrary.simpleMessage(
      "Street food",
    ),
    "global_food_wine": MessageLookupByLibrary.simpleMessage("Wine"),
    "global_generic_field_error": MessageLookupByLibrary.simpleMessage(
      "This entry is invalid",
    ),
    "global_gift_experience": MessageLookupByLibrary.simpleMessage(
      "Experiences",
    ),
    "global_gift_food_and_drinks": MessageLookupByLibrary.simpleMessage(
      "Food & drink",
    ),
    "global_gift_hobbies": MessageLookupByLibrary.simpleMessage("Hobbies"),
    "global_gift_luxury_items": MessageLookupByLibrary.simpleMessage("Luxury"),
    "global_gift_practical_gifts": MessageLookupByLibrary.simpleMessage(
      "Practical",
    ),
    "global_gift_sentimental": MessageLookupByLibrary.simpleMessage(
      "Sentimental",
    ),
    "global_gift_surprise_me": MessageLookupByLibrary.simpleMessage(
      "Surprise me",
    ),
    "global_gift_wellness": MessageLookupByLibrary.simpleMessage("Wellness"),
    "global_hide_password": MessageLookupByLibrary.simpleMessage(
      "Hide password",
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
    "global_relationship_type_dating": MessageLookupByLibrary.simpleMessage(
      "Dating",
    ),
    "global_relationship_type_engaged": MessageLookupByLibrary.simpleMessage(
      "Engaged",
    ),
    "global_relationship_type_life_partners":
        MessageLookupByLibrary.simpleMessage("Life partners"),
    "global_relationship_type_married": MessageLookupByLibrary.simpleMessage(
      "Married",
    ),
    "global_relationship_type_other": MessageLookupByLibrary.simpleMessage(
      "Other",
    ),
    "global_required": MessageLookupByLibrary.simpleMessage("Required"),
    "global_show_password": MessageLookupByLibrary.simpleMessage(
      "Show password",
    ),
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
    "landing_reassurance_saved": MessageLookupByLibrary.simpleMessage(
      "Your setup is ready and waiting",
    ),
    "landing_reassurance_signup_free": MessageLookupByLibrary.simpleMessage(
      "Signing up is free",
    ),
    "landing_reassurance_trial": MessageLookupByLibrary.simpleMessage(
      "Free to use for your first week",
    ),
    "landing_subtitle": MessageLookupByLibrary.simpleMessage(
      "Create an account and it starts lining up gift ideas, message drafts, and date plans for your partner.",
    ),
    "landing_title": MessageLookupByLibrary.simpleMessage(
      "Your partner\'s profile is ready",
    ),
    "landing_title_named": m1,
    "main_title": MessageLookupByLibrary.simpleMessage("Main App"),
    "main_under_construction_message": MessageLookupByLibrary.simpleMessage(
      "This part of the app isn\'t ready yet.",
    ),
    "main_under_construction_title": MessageLookupByLibrary.simpleMessage(
      "Under construction",
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
      "Your Personal BetterHalf",
    ),
    "wizard_greetings_message_1": MessageLookupByLibrary.simpleMessage(
      "BetterHalf keeps track of what matters to your partner and helps you act on it.",
    ),
    "wizard_greetings_message_2": MessageLookupByLibrary.simpleMessage(
      "It reminds you of the dates that matter, drafts messages in your voice, and lines up gift and date ideas they\'d actually want.",
    ),
    "wizard_next": MessageLookupByLibrary.simpleMessage("Next"),
    "wizard_partner_anniversary_explanation": MessageLookupByLibrary.simpleMessage(
      "I use your anniversary date so you have enough time to plan or get something special for them.",
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
      "I use your partner\'s birthday so you have enough time to plan something special for them.",
    ),
    "wizard_partner_birthday_hint": MessageLookupByLibrary.simpleMessage(
      "Pick birthday date",
    ),
    "wizard_partner_birthday_title": MessageLookupByLibrary.simpleMessage(
      "Birthday",
    ),
    "wizard_partner_food_and_gifts_message_1": m2,
    "wizard_partner_food_and_gifts_message_2": m3,
    "wizard_partner_food_and_gifts_title": m4,
    "wizard_partner_food_likes_title": m5,
    "wizard_partner_foods_explanation": MessageLookupByLibrary.simpleMessage(
      "Sharing your partner\'s favorite foods helps me pick food gifts and restaurants that fit.",
    ),
    "wizard_partner_gift_likes_title": m6,
    "wizard_partner_gift_types_explanation": MessageLookupByLibrary.simpleMessage(
      "Picking your partner\'s favorite types helps me suggest gifts that fit.\nExperiences: E.g., tickets to events, vacations, date nights.\nSentimental Items: E.g., handmade gifts, personal letters, photo albums.\nPractical Gifts: E.g., gadgets, tools, kitchenware.\nLuxury Items: E.g., jewelry, designer clothing, high-end accessories.\nHobbies & Interests: E.g., books, music instruments, art supplies.\nFood & Drinks: E.g., gourmet chocolates, wine, or subscription boxes.\nSurprise Me: For when you want me to get creative.",
    ),
    "wizard_partner_hobbies_explanation": MessageLookupByLibrary.simpleMessage(
      "Sharing your partner\'s hobbies helps me pick activities and gifts that fit.",
    ),
    "wizard_partner_hobbies_title": m7,
    "wizard_partner_love_language_explanation":
        MessageLookupByLibrary.simpleMessage(
          "There are said to be five forms of expressions of love.\nQuality Time: Spending undivided, meaningful time together.\nWords of Affirmation: Expressing love and appreciation through kind and affirming words.\nActs of Service: Showing love by doing helpful or thoughtful tasks.\nPhysical Touch: Expressing love through physical gestures like hugs, kisses, and other forms of touch.\nReceiving Gifts: Giving and receiving thoughtful gifts as a symbol of love.",
        ),
    "wizard_partner_love_language_title": m8,
    "wizard_partner_loves_message_1": m9,
    "wizard_partner_loves_message_2": MessageLookupByLibrary.simpleMessage(
      "This is what makes my suggestions and messages land.",
    ),
    "wizard_partner_loves_message_initial_1": m10,
    "wizard_partner_loves_title": m11,
    "wizard_partner_more_details": m12,
    "wizard_partner_profile_birthday_missing":
        MessageLookupByLibrary.simpleMessage("Birthday is required"),
    "wizard_partner_profile_message_1_extended":
        MessageLookupByLibrary.simpleMessage(
          "Tell me a bit about your partner, like their name, pronouns and important dates.",
        ),
    "wizard_partner_profile_message_1_shortened":
        MessageLookupByLibrary.simpleMessage(
          "Tell me a bit about your partner, like their name and pronouns.",
        ),
    "wizard_partner_profile_message_initial_1":
        MessageLookupByLibrary.simpleMessage(
          "Let\'s start with the basics: name and gender.",
        ),
    "wizard_partner_profile_name_hint": MessageLookupByLibrary.simpleMessage(
      "Partner name",
    ),
    "wizard_partner_profile_name_missing": MessageLookupByLibrary.simpleMessage(
      "Name is required",
    ),
    "wizard_partner_profile_name_title": MessageLookupByLibrary.simpleMessage(
      "What\'s your partner\'s name?",
    ),
    "wizard_partner_profile_pronoun_missing":
        MessageLookupByLibrary.simpleMessage("Pronoun is required"),
    "wizard_partner_profile_title": MessageLookupByLibrary.simpleMessage(
      "Let\'s start with the basics",
    ),
    "wizard_partner_pronouns_hint": MessageLookupByLibrary.simpleMessage(
      "Select your partner\'s pronouns",
    ),
    "wizard_partner_pronouns_title": MessageLookupByLibrary.simpleMessage(
      "How should I refer to your partner?",
    ),
    "wizard_partner_relationship_type_explanation":
        MessageLookupByLibrary.simpleMessage(
          "This helps me fit reminders, messages, and suggestions to the stage of your relationship",
        ),
    "wizard_partner_relationship_type_hint":
        MessageLookupByLibrary.simpleMessage("Select relationship type"),
    "wizard_partner_relationship_type_title":
        MessageLookupByLibrary.simpleMessage("Relationship type"),
    "wizard_partner_tone_of_voice_explanation":
        MessageLookupByLibrary.simpleMessage(
          "Picking the right tone helps me write messages that land with your partner.",
        ),
    "wizard_partner_tone_of_voice_hint": MessageLookupByLibrary.simpleMessage(
      "Select tone of voice",
    ),
    "wizard_partner_tone_of_voice_title": m13,
    "wizard_previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "wizard_start": MessageLookupByLibrary.simpleMessage("Begin"),
    "wizard_title": MessageLookupByLibrary.simpleMessage("Partner setup"),
  };
}
