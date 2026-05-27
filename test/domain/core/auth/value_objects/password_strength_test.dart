import "package:flutter_test/flutter_test.dart";
import "package:la/domain/core/auth/value_objects/password_strength_evaluator.dart";

void main() {
  const PasswordStrengthEvaluator evaluator = PasswordStrengthEvaluator();

  group("Too-short boundary", () {
    test("Empty string is too short", () {
      expect(evaluator.evaluate(""), PasswordStrength.tooShort);
    });

    test("Single character is too short", () {
      expect(evaluator.evaluate("a"), PasswordStrength.tooShort);
    });

    test("Five characters is too short (boundary below minimum)", () {
      expect(evaluator.evaluate("abcde"), PasswordStrength.tooShort);
    });

    test("Exactly six characters meets the minimum and is no longer too short", () {
      expect(evaluator.evaluate("abcdef"), isNot(PasswordStrength.tooShort));
    });
  });

  group("Variety tiers", () {
    test("Letters only maps to weak", () {
      expect(evaluator.evaluate("abcdefg"), PasswordStrength.weak);
    });

    test("Digits only maps to weak", () {
      expect(evaluator.evaluate("1234567"), PasswordStrength.weak);
    });

    test("Letters and digits map to fair", () {
      expect(evaluator.evaluate("abc123"), PasswordStrength.fair);
    });

    test("Letters, digits, and symbols map to strong", () {
      expect(evaluator.evaluate("abc123!@#"), PasswordStrength.strong);
    });

    test("Two-variety password of twelve or more characters is promoted to strong", () {
      expect(evaluator.evaluate("abcdefghij12"), PasswordStrength.strong);
    });

    test("Two-variety password below twelve characters stays fair", () {
      expect(evaluator.evaluate("abcdefghi12"), PasswordStrength.fair);
    });
  });

  group("Strength is advisory and monotonic", () {
    test("Higher variety never produces a lower tier than lower variety", () {
      final PasswordStrength lowVariety = evaluator.evaluate("abcdefg");
      final PasswordStrength highVariety = evaluator.evaluate("Abcdef1!");

      expect(highVariety.index, greaterThanOrEqualTo(lowVariety.index));
    });

    test("A six-character mixed-variety password is rated, never rejected", () {
      expect(evaluator.evaluate("abc123"), isNot(PasswordStrength.tooShort));
    });
  });
}
