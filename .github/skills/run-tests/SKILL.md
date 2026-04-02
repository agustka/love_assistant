---
name: run-tests
description: Guide for running tests in the project. Use this when asked to run tests, UATs, layer tests, or golden tests.
---

# Running Tests

This project organizes tests by layer and type. Always use `--no-pub` flag unless specified otherwise.

## Quick Reference

| Test Type | Command |
|-----------|---------|
| UATs | `flutter test --no-pub test/user_acceptance_tests` |
| Golden tests | `flutter test --no-pub test/presentation` |
| Update goldens | `flutter test --no-pub test/presentation --update-goldens` |
| Application layer | `flutter test --no-pub test/application` |
| Domain layer | `flutter test --no-pub test/domain` |
| Infrastructure layer | `flutter test --no-pub test/infrastructure` |
| All tests | `flutter test --no-pub` |



