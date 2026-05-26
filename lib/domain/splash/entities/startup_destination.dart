/// The page a cold start resolves to, derived from device state.
///
/// [resolve] is the single deterministic routing decision for app startup:
/// given whether a partner profile is present, whether reading it succeeded,
/// and whether an active auth session exists, it returns exactly one
/// destination. Navigation itself is performed by the application layer.
enum StartupDestination {
  wizard,
  landing,
  main;

  static StartupDestination resolve({
    required bool profileReadOk,
    required bool profilePresent,
    required bool signedIn,
  }) {
    if (!profileReadOk) {
      return StartupDestination.wizard;
    }
    if (!profilePresent) {
      return StartupDestination.wizard;
    }
    if (signedIn) {
      return StartupDestination.main;
    }
    return StartupDestination.landing;
  }
}
