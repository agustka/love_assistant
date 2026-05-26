/// The page a cold start resolves to, derived from device state.
///
/// [resolve] is the single deterministic routing decision for app startup:
/// given whether a usable partner profile loaded and whether an active auth
/// session exists, it returns exactly one destination. A profile that is
/// absent or failed to read is invalid, so both collapse to the wizard.
/// Navigation itself is performed by the application layer.
enum StartupDestination {
  wizard,
  landing,
  main;

  static StartupDestination resolve({
    required bool profileValid,
    required bool signedIn,
  }) {
    if (!profileValid) {
      return StartupDestination.wizard;
    }
    if (signedIn) {
      return StartupDestination.main;
    }
    return StartupDestination.landing;
  }
}
