# Contributing to LoveAssistant 💕

Thank you for your interest in contributing to LoveAssistant! I am excited to have you help me build a better digital love assistant.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Architecture Guidelines](#architecture-guidelines)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Standards

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed steps to reproduce the bug
- Provide device/OS information
- Include screenshots if applicable
- Use the "Bug" issue template

### Suggesting Enhancements

- Use the "Feature Request" issue template
- Clearly describe the enhancement
- Explain why this enhancement would be useful
- Include mockups or examples if possible

### Code Contributions

- Pick an issue from the "Good First Issue" or "Help Wanted" labels
- Comment on the issue to let us know you're working on it
- Follow our coding standards and architecture guidelines
- Write tests for new functionality
- Update documentation as needed

## Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git

### Local Development

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/love_assistant.git
   cd love_assistant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

## Architecture Guidelines

LoveAssistant follows **Clean Architecture** principles. Please adhere to these guidelines:

### Layer Responsibilities

- **UI Layer** (`presentation/`): Flutter widgets, pages, and UI logic
- **Application Layer** (`application/`): Cubits for state management
- **Repository Layer** (`domain/repositories/`): Data access interfaces
- **Model Layer** (`domain/entities/`): Business entities and value objects
- **Service Layer** (`infrastructure/`): External services and platform code

### Key Principles

- **Dependency Inversion**: Depend on abstractions, not concretions
- **Single Responsibility**: Each class has one reason to change
- **Value Objects**: Use immutable objects for validation and business rules
- **Reactive Programming**: Use RxDart streams for data flow
- **Dependency Injection**: Use Injectable + GetIt for all dependencies

### File Naming Conventions

- **Cubits**: `*_cubit.dart` and `*_state.dart`
- **Entities**: `*.dart` (e.g., `profile.dart`)
- **Repositories**: `i_*_repository.dart` (interfaces)
- **Value Objects**: `*_value_object.dart`
- **Widgets**: `*_widget.dart` or descriptive names

## Coding Standards

### Dart/Flutter Standards

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Keep functions small and focused
- Add comments for complex business logic
- Use const constructors where possible

### State Management

- Use Cubits for state management (not StatefulWidget for business logic)
- Keep state classes immutable
- Use copyWith for state updates
- Emit states, not events

### Error Handling

- Use Result types or Either for error handling
- Don't let exceptions bubble up to UI layer
- Provide meaningful error messages
- Log errors appropriately

### Example Code Structure

```dart
// Good: Clean separation of concerns
class ProfileCubit extends Cubit<ProfileState> {
  final IProfileRepository _repository;
  
  ProfileCubit(this._repository) : super(ProfileState.initial());
  
  Future<void> createProfile(Profile profile) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      await _repository.createProfile(profile);
      emit(state.copyWith(status: ProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
```

## Testing Guidelines

### Test Structure

- **Unit Tests**: Test business logic and value objects
- **Widget Tests**: Test UI components
- **Integration Tests**: Test user flows
- **Repository Tests**: Test data access with mocks

### Testing Best Practices

- Write tests before or alongside code (TDD when possible)
- Use descriptive test names
- Test both success and failure scenarios
- Mock external dependencies
- Keep tests fast and reliable

### Example Test

```dart
group('ProfileCubit', () {
  late MockIProfileRepository mockRepository;
  late ProfileCubit cubit;

  setUp(() {
    mockRepository = MockIProfileRepository();
    cubit = ProfileCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('should emit loading then success when profile is created', () async {
    // Arrange
    when(mockRepository.createProfile(any)).thenAnswer((_) async {});

    // Act
    cubit.createProfile(Profile.empty());

    // Assert
    expect(cubit.state.status, ProfileStatus.loading);
    await expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ProfileState>().having((s) => s.status, 'status', ProfileStatus.loading),
        isA<ProfileState>().having((s) => s.status, 'status', ProfileStatus.success),
      ]),
    );
  });
});
```

## Pull Request Process

### Before Submitting

1. **Ensure tests pass**
   ```bash
   flutter test
   ```

2. **Check code formatting**
   ```bash
   flutter format .
   ```

3. **Run static analysis**
   ```bash
   flutter analyze
   ```

4. **Update documentation** if needed

### PR Guidelines

- **Title**: Use conventional commit format (e.g., "feat: add profile creation")
- **Description**: Clearly describe what the PR does and why
- **Linked Issues**: Reference related issues using keywords (e.g., "Fixes #123")
- **Screenshots**: Include screenshots for UI changes
- **Tests**: Include tests for new functionality

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or breaking changes documented)
```

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

- **Environment**: Flutter version, device, OS
- **Steps to reproduce**: Detailed step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Screenshots**: If applicable
- **Logs**: Any error messages or logs

### Feature Requests

When suggesting features, please include:

- **Problem**: What problem does this solve?
- **Solution**: How should it work?
- **Alternatives**: What alternatives have you considered?
- **Mockups**: Visual examples if applicable

## Getting Help

- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Use GitHub Issues for bugs and feature requests
- **Documentation**: Check the README and code comments

## Recognition

Contributors will be recognized in:
- The project README
- Release notes
- GitHub contributors page

Thank you for contributing to LoveAssistant! 💕 