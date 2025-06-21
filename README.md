# Flutter Clean Architecture Template

A production-grade Flutter template using Clean Architecture principles with Riverpod state management, designed for scalable enterprise mobile applications.

[![CI/CD Pipeline](https://github.com/senthilinfo62/Flutter_template/actions/workflows/ci.yml/badge.svg)](https://github.com/senthilinfo62/Flutter_template/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/senthilinfo62/Flutter_template/branch/main/graph/badge.svg)](https://codecov.io/gh/senthilinfo62/Flutter_template)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 Features

- **Clean Architecture**: Strict layer separation (Domain → Data → Presentation)
- **State Management**: Riverpod for dependency injection and state management
- **Code Generation**: Freezed for immutable classes and sealed unions
- **Localization**: Multi-language support with flutter_localizations
- **Theme System**: Light/Dark/System theme switching
- **Responsive Design**: Adaptive UI components with flutter_screenutil
- **Network Layer**: Dio with proper error handling and interceptors
- **Local Storage**: SharedPreferences and Hive for caching
- **Performance Monitoring**: Firebase Performance and Analytics integration
- **Image Optimization**: Cached network images with compression
- **Bundle Optimization**: Tree shaking and code splitting
- **Testing**: Unit and widget test templates with mocktail
- **CI/CD**: GitHub Actions for automated testing and building
- **App Store Deployment**: Automatic TestFlight and Play Store uploads
- **Multi-Environment**: Automatic package name switching (.dev, .stg, production)
- **Code Quality**: Strict linting rules with very_good_analysis

> **📱 iOS Build Status:** iOS builds are enabled in CI/CD with intelligent error handling. Due to Firebase SDK 11.x compatibility issues with GitHub Actions Swift environment, iOS builds may fail in CI but this doesn't affect the pipeline success. iOS builds work perfectly locally and in production.
>
> **🚀 Fastlane Integration:** This template includes Fastlane configuration for advanced iOS build automation. Use `cd ios && bundle exec fastlane build_firebase` for local iOS builds with enhanced Firebase compatibility settings.

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App-wide constants
│   ├── errors/                     # Error handling (failures & exceptions)
│   ├── network/                    # Network configuration (Dio client)
│   ├── theme/                      # Theme configuration
│   ├── utils/                      # Utility functions and extensions
│   └── widgets/                    # Reusable UI components
├── features/                       # Feature modules
│   └── todos/                      # Todo feature example
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Local & remote data sources
│       │   ├── models/             # Data models with JSON serialization
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   ├── repositories/       # Repository abstractions
│       │   └── usecases/           # Business logic use cases
│       └── presentation/           # Presentation layer
│           ├── pages/              # UI pages/screens
│           ├── providers/          # Riverpod providers
│           └── widgets/            # Feature-specific widgets
├── l10n/                          # Localization files
├── shared/                        # Shared functionality across features
│   └── providers/                 # Global providers (theme, etc.)
└── main.dart                      # App entry point
```

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (>=3.32.0)
- Dart SDK (>=3.8.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/senthilinfo62/Flutter_template.git
   cd Flutter_template
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Store Deployment

This template includes automatic deployment to app stores:
- **iOS**: Automatic TestFlight uploads after successful builds
- **Android**: Automatic Play Store Internal Release uploads

**Setup required:** See [App Store Deployment Guide](docs/APP_STORE_DEPLOYMENT.md) for configuration details.

## 🌿 Multi-Environment Management

Automatic package name switching based on Git branch patterns:
- **Development (.dev)** - feature/*, fix/*, hotfix/* branches
- **Staging (.stg)** - development, qa/* branches
- **Production (original)** - main, release/* branches

**Learn more:** See [Environment Management Guide](docs/ENVIRONMENT_MANAGEMENT.md) for complete details.

## 🔥 Firebase Configuration

Easy copy-paste Firebase setup for all environments:
- **Templates provided** for Development, Staging, and Production
- **Automatic configuration** switching based on Git branch
- **Sample values** and step-by-step setup guide

**Quick setup:** Run `./scripts/setup_firebase.sh` and follow the guide in `config/README.md`

### Development Setup

1. **Install recommended VS Code extensions**
   - Flutter
   - Dart
   - Riverpod Snippets
   - Error Lens

2. **Configure your IDE**
   - Enable format on save
   - Set line length to 80 characters
   - Enable auto-import organization

## 🏗️ Architecture Overview

This template follows **Clean Architecture** principles with three main layers:

### Domain Layer
- **Entities**: Core business objects
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Business logic and application rules

### Data Layer
- **Models**: Data representations with JSON serialization
- **Data Sources**: Local (SharedPreferences, Hive) and Remote (API) data access
- **Repository Implementations**: Concrete implementations of domain repositories

### Presentation Layer
- **Pages**: UI screens and navigation
- **Widgets**: Reusable UI components
- **Providers**: Riverpod providers for state management

### Dependency Flow
```
Presentation → Domain ← Data
```

## 🎨 Theming

The app supports three theme modes:
- **Light Theme**: Clean, modern light design
- **Dark Theme**: OLED-friendly dark design
- **System Theme**: Follows device settings

### Customizing Themes

1. **Colors**: Modify `lib/core/theme/app_colors.dart`
2. **Text Styles**: Update `lib/core/theme/app_text_styles.dart`
3. **Component Themes**: Edit `lib/core/theme/app_theme.dart`

## 🌍 Localization

### Adding New Languages

1. **Create ARB file**
   ```bash
   # Create lib/l10n/app_[locale].arb
   touch lib/l10n/app_fr.arb
   ```

2. **Add translations**
   ```json
   {
     "@@locale": "fr",
     "appTitle": "Modèle d'Architecture Propre Flutter",
     "welcome": "Bienvenue"
   }
   ```

3. **Update supported locales**
   ```dart
   // In main.dart
   supportedLocales: const [
     Locale('en', ''),
     Locale('es', ''),
     Locale('fr', ''), // Add new locale
   ],
   ```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/todos/domain/usecases/get_todos_test.dart
```

### Test Structure

```
test/
├── features/
│   └── todos/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           └── providers/
└── widget_test.dart
```

### Writing Tests

1. **Unit Tests**: Test individual functions and classes
2. **Widget Tests**: Test UI components and interactions
3. **Integration Tests**: Test complete user flows

## 🚀 Building & Deployment

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### Web

```bash
# Release build
flutter build web --release
```

## 🔧 Code Generation

This template uses several code generation tools:

### Freezed (Data Classes)
```bash
flutter packages pub run build_runner build
```

### JSON Serialization
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Riverpod (Providers)
```bash
flutter packages pub run build_runner watch
```

## 📝 Development Guidelines

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Keep functions small and focused
- Write self-documenting code

### Git Workflow

1. **Feature branches**: `feature/todo-crud`
2. **Bug fixes**: `bugfix/login-validation`
3. **Hotfixes**: `hotfix/critical-crash`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add todo creation functionality
fix: resolve login validation issue
docs: update README with setup instructions
test: add unit tests for todo repository
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [Riverpod](https://riverpod.dev/) for excellent state management
- [Very Good Ventures](https://verygood.ventures/) for development best practices
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) by Uncle Bob

## 📞 Support

If you have any questions or need help, please:

1. Check the [documentation](https://flutter.dev/docs)
2. Search [existing issues](https://github.com/senthilinfo62/Flutter_template/issues)
3. Create a [new issue](https://github.com/senthilinfo62/Flutter_template/issues/new)

---

**Happy coding! 🎉**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
