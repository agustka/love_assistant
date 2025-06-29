# LoveAssistant 💕

A digital love assistant that helps you nurture your relationship by providing personalized reminders, gift suggestions, and thoughtful messages for your partner.

## 🌟 What is LoveAssistant?

LoveAssistant is your personal digital companion for building stronger, more thoughtful relationships. By learning about your partner's preferences, love languages, and important dates, the app helps you:

- **Never forget important dates** (birthdays, anniversaries)
- **Get personalized gift suggestions** based on your partner's interests
- **Receive thoughtful message ideas** tailored to your partner's love language
- **Discover meaningful activities** and experiences to share together
- **Stay connected** with regular relationship reminders

## 🚀 Features

### Current (Setup Wizard)
- **Multi-step partner profile setup** with comprehensive data collection
- **Love language assessment** (Quality Time, Words of Affirmation, Acts of Service, Physical Touch, Receiving Gifts)
- **Preference tracking** (hobbies, food preferences, gift types, tone of voice)
- **Important date management** (birthday, anniversary tracking)
- **Multi-language support** (English, Icelandic)

### Planned Features
- AI-powered personalized message generation
- Smart gift and activity recommendations
- Push notification reminders
- Email integration for surprise messages
- User authentication and profile management
- Backend integration and data persistence

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a focus on maintainability and testability:

### Layers
- **UI Layer**: Flutter widgets using Atomic Design principles
- **Application Layer**: Cubits (BLoC pattern) for state management
- **Repository Layer**: Data access abstraction
- **Model Layer**: Domain entities and value objects
- **Service Layer**: External integrations and platform channels

### Key Technologies
- **Flutter** - Cross-platform UI framework
- **Cubits** - State management (BLoC pattern)
- **RxDart** - Reactive programming with BehaviorSubject streams
- **Injectable + GetIt** - Dependency injection
- **Hive** - Local data caching
- **Chopper** - HTTP client for API calls
- **Value Objects** - Domain validation and business rules

## 📱 Screenshots

*Screenshots will be added as the app develops*

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/love_assistant.git
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

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🧪 Testing

Run tests with:
```bash
flutter test
```

The project includes:
- Unit tests for domain logic
- Widget tests for UI components
- Integration tests for user flows

## 📁 Project Structure

```
lib/
├── application/          # Cubits and state management
├── domain/              # Business logic and entities
├── infrastructure/      # External services and platform code
├── presentation/        # UI components and pages
├── setup.dart          # Dependency injection setup
└── main.dart           # App entry point
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](readme/CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project uses a custom license that requires permission before use. See the [LICENSE](readme/LICENSE) file for details.

**Important**: You must obtain explicit written permission from the copyright holder before using, modifying, or distributing this code.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- The relationship psychology community for insights into love languages
- All contributors and beta testers

## 📞 Contact

- **Project Link**: [https://github.com/yourusername/love_assistant](https://github.com/yourusername/love_assistant)
- **Issues**: [GitHub Issues](https://github.com/yourusername/love_assistant/issues)

---

Made with ❤️ for better relationships
