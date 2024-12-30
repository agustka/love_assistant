import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserLocale extends Equatable {
  final String localePlain;
  final Locale locale;
  final bool valid;

  bool get isInvalid => !valid;

  const UserLocale({required this.localePlain, required this.locale, this.valid = true});

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
      localePlain: input,
      locale: locale,
    );
  }

  factory UserLocale.fromLocale(Locale locale) {
    return UserLocale(
      localePlain: locale.toLanguageTag(),
      locale: locale,
    );
  }

  const factory UserLocale.invalid() = _$InvalidUserLocale;

  factory UserLocale.icelandic() {
    return const UserLocale(
      localePlain: "Íslenska",
      locale: Locale("is", "IS"),
    );
  }

  factory UserLocale.english() {
    return const UserLocale(
      localePlain: "English",
      locale: Locale("en", "GB"),
    );
  }

  factory UserLocale.spanish() {
    return const UserLocale(
      localePlain: "Español",
      locale: Locale("es", "ES"),
    );
  }

  factory UserLocale.german() {
    return const UserLocale(
      localePlain: "Deutsch",
      locale: Locale("de", "DE"),
    );
  }

  @override
  String toString() {
    return locale.toString();
  }

  @override
  List<Object> get props => [
        localePlain,
        locale,
        valid,
      ];
}

class _$InvalidUserLocale extends UserLocale {
  const _$InvalidUserLocale()
      : super(
          localePlain: "",
          locale: const Locale("is"),
          valid: false,
        );
}
