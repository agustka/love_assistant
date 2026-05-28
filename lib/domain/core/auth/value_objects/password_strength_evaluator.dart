class PasswordStrengthEvaluator {
  static const int _minLength = 6;
  static const int _longLength = 12;

  const PasswordStrengthEvaluator();

  PasswordStrength evaluate(String password) {
    if (password.length < _minLength) {
      return PasswordStrength.tooShort;
    }
    final int variety = _varietyScore(password);
    if (variety >= 3 || (variety >= 2 && password.length >= _longLength)) {
      return PasswordStrength.strong;
    }
    if (variety >= 2) {
      return PasswordStrength.fair;
    }
    return PasswordStrength.weak;
  }

  int _varietyScore(String password) {
    final bool hasLetter = password.contains(RegExp("[A-Za-z]"));
    final bool hasDigit = password.contains(RegExp("[0-9]"));
    final bool hasSymbol = password.contains(RegExp("[^A-Za-z0-9]"));
    int score = 0;
    if (hasLetter) {
      score++;
    }
    if (hasDigit) {
      score++;
    }
    if (hasSymbol) {
      score++;
    }
    return score;
  }
}

enum PasswordStrength {
  tooShort,
  weak,
  fair,
  strong,
}
