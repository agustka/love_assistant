import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/splash/entities/startup_destination.dart';

void main() {
  group("StartupDestination.resolve", () {
    test("invalid profile routes to the wizard", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileValid: false,
        signedIn: false,
      );

      expect(destination, StartupDestination.wizard);
    });

    test("valid profile and signed in routes to main", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileValid: true,
        signedIn: true,
      );

      expect(destination, StartupDestination.main);
    });

    test("valid profile and not signed in routes to landing", () {
      final StartupDestination destination = StartupDestination.resolve(
        profileValid: true,
        signedIn: false,
      );

      expect(destination, StartupDestination.landing);
    });
  });
}
