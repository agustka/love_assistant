// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_name": MessageLookupByLibrary.simpleMessage("LoveAssistant"),
        "global_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "ordinal_suffix_first": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_generic": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_global": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_second": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_third": MessageLookupByLibrary.simpleMessage("."),
        "settings_pick_language":
            MessageLookupByLibrary.simpleMessage("Select language"),
        "wizard_greetings": MessageLookupByLibrary.simpleMessage("Hi, there!"),
        "wizard_greetings_message_1": MessageLookupByLibrary.simpleMessage(
            "Let’s get started on creating a tailored profile for your partner."),
        "wizard_greetings_message_2": MessageLookupByLibrary.simpleMessage(
            "With this, you’ll receive thoughtful reminders, ideas, and personalized messages."),
        "wizard_greetings_message_3": MessageLookupByLibrary.simpleMessage(
            "You don’t need to create an account to get started."),
        "wizard_start": MessageLookupByLibrary.simpleMessage("Begin"),
        "wizard_title": MessageLookupByLibrary.simpleMessage("Partner setup")
      };
}
