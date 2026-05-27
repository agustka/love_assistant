/// Marker interface for all test builders.
///
/// Concrete builders extend this and expose a fluent API for configuring the
/// offline service stubs before each test, then restoring them in tearDown.
abstract class BaseBuilder {
  void tearDown();
}
