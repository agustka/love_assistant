// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_name": MessageLookupByLibrary.simpleMessage("LoveAssistant"),
        "ordinal_suffix_first": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_generic": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_global": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_second": MessageLookupByLibrary.simpleMessage("."),
        "ordinal_suffix_third": MessageLookupByLibrary.simpleMessage("."),
        "wizard_greetings": MessageLookupByLibrary.simpleMessage("Hi, there!"),
        "wizard_greetings_message": MessageLookupByLibrary.simpleMessage(
            "Let’s create a personalized profile for your partner to make every moment special."),
        "wizard_greetings_privacy": MessageLookupByLibrary.simpleMessage(
            "Don’t worry—your information stays private and won’t be shared with anyone."),
        "wizard_title": MessageLookupByLibrary.simpleMessage("Partner setup")
      };
}
