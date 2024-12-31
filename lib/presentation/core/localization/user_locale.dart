import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

class UserLocale extends Equatable {
  final Locale locale;
  final Language language;
  final bool valid;

  bool get isInvalid => !valid;

  const UserLocale({
    required this.locale,
    required this.language,
    this.valid = true,
  });

  factory UserLocale.fromString(String input) {
    String language = input;
    String country = "";
    if (input.contains("-")) {
      final List<String> parts = input.split("-");
      language = parts.first;
      country = parts[1];
    }
    final Locale locale = Locale(language, country);
    return UserLocale(
      locale: locale,
      language: _languageFromCode(language),
    );
  }

  factory UserLocale.fromLanguage(Language language) {
    return UserLocale.fromLocale(language.locale);
  }

  factory UserLocale.fromLocale(Locale locale) {
    return UserLocale(
      locale: locale,
      language: _languageFromCode(locale.languageCode),
    );
  }

  const factory UserLocale.invalid() = _$InvalidUserLocale;

  factory UserLocale.icelandic() {
    return const UserLocale(
      locale: Locale("is", "IS"),
      language: Language.icelandic,
    );
  }

  factory UserLocale.english() {
    return const UserLocale(
      locale: Locale("en", "US"),
      language: Language.english,
    );
  }

  factory UserLocale.spanish() {
    return const UserLocale(
      locale: Locale("es", "ES"),
      language: Language.spanish,
    );
  }

  factory UserLocale.german() {
    return const UserLocale(
      locale: Locale("de", "DE"),
      language: Language.german,
    );
  }

  static Language _languageFromCode(String language) {
    switch (language.toLowerCase()) {
      case "en":
        return Language.english;
      case "es":
        return Language.spanish;
      case "de":
        return Language.german;
      case "is":
        return Language.icelandic;
      default:
        return Language.english;
    }
  }

  @override
  String toString() {
    return language.properName;
  }

  @override
  List<Object> get props => [
        locale,
    language,
        valid,
      ];
}

class _$InvalidUserLocale extends UserLocale {
  const _$InvalidUserLocale()
      : super(
          locale: const Locale("en"),
          language: Language.invalid,
          valid: false,
        );
}

enum Language {
  english,
  spanish,
  german,
  icelandic,
  invalid,
}

extension LanguageExtension on Language {
  String get properName {
    switch (this) {
      case Language.english:
        return "English";
      case Language.icelandic:
        return "Íslenska";
      case Language.german:
        return "Deutsch";
      case Language.spanish:
        return "Español";
      case Language.invalid:
        return "";
    }
  }

  String get flagIcon {
    switch (this) {
      case Language.english:
        return AppAssets.icons.flags.flagUs;
      case Language.icelandic:
        return AppAssets.icons.flags.flagIs;
      case Language.german:
        return AppAssets.icons.flags.flagDe;
      case Language.spanish:
        return AppAssets.icons.flags.flagEs;
      case Language.invalid:
        return AppAssets.icons.icTransparent;
    }
  }

  Locale get locale {
    switch (this) {
      case Language.english:
        return const Locale("en", "US");
      case Language.icelandic:
        return const Locale("is", "IS");
      case Language.german:
        return const Locale("de", "DE");
      case Language.spanish:
        return const Locale("es", "ES");
      case Language.invalid:
        return const Locale("en", "US");
    }
  }
}
