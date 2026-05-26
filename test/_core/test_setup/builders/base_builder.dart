import '../test_setup.dart';

/// Base class for all test data builders.
///
/// A builder exposes a fluent API for configuring test data and returns a
/// [TestSetupConstructor] from [build] whose `setup()` wires that data into the
/// offline dependency graph and whose `tearDown()` resets it.
abstract class BaseBuilder {
  BaseBuilder();

  TestSetupConstructor build();

  List<BaseBuilder> single() => [this];
}
