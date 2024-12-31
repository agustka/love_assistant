part of 'language_cubit.dart';

@immutable
class LanguageState extends Equatable {
  final Language language;

  const LanguageState({
    required this.language,
  });

  const LanguageState.initial()
      : this(
          language: Language.invalid,
        );

  LanguageState copyWith({
    Language? language,
  }) {
    return LanguageState(
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        language,
      ];
}
