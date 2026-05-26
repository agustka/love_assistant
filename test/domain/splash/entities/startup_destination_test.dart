import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/splash/entities/startup_destination.dart';

void main() {
  group("StartupDestination.resolve", () {
    test("no profile present routes to the wizard", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileReadOk: true,
        profilePresent: false,
        signedIn: false,
      );

      expect(destination, StartupDestination.wizard);
    });

    test("profile present and signed in routes to main", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileReadOk: true,
        profilePresent: true,
        signedIn: true,
      );

      expect(destination, StartupDestination.main);
    });

    test("profile present and not signed in routes to landing", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileReadOk: true,
        profilePresent: true,
        signedIn: false,
      );

      expect(destination, StartupDestination.landing);
    });

    test("profile read failure falls back to the wizard", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileReadOk: false,
        profilePresent: false,
        signedIn: false,
      );

      expect(destination, StartupDestination.wizard);
    });
  });
}
