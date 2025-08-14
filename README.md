# Flutter Mocard

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)

A beautiful Flutter app for organizing and managing different types of learning cards using Clean Architecture principles.

## 📱 App Preview

Mocard provides an intuitive card-based interface for organizing your learning materials across different categories:

- **Learning Cards** - Educational content and study materials
- **Working Cards** - Professional development and work-related content  
- **Writing Cards** - Creative writing prompts and exercises
- **Life Cards** - Personal development and lifestyle content

## ✨ Features

- 🎨 **Beautiful UI** - Modern and clean interface with smooth animations
- 📚 **Multiple Card Types** - Organize content across Learning, Working, Writing, and Life categories
- 💬 **Interactive Chat** - Engage with card content through chat interface
- 🌙 **Dark Mode Support** - Toggle between light and dark themes
- 📱 **Responsive Design** - Works seamlessly across different screen sizes
- 🔄 **Real-time Sync** - Cloud synchronization for your cards and progress
- 📊 **Progress Tracking** - Monitor your learning journey with detailed analytics
- 🔍 **Smart Search** - Find cards quickly with intelligent search functionality

## 🏗️ Architecture

This project follows **Clean Architecture** principles with:

- **Presentation Layer**: Flutter UI with BLoC state management
- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository pattern with local and remote data sources

### Key Technologies

- **State Management**: BLoC (flutter_bloc)
- **Local Storage**: Hive database
- **Network**: Dio HTTP client with caching
- **UI**: Custom animations and responsive design
- **Architecture**: Clean Architecture with Repository pattern

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=2.17.3 <3.0.0)
- Dart SDK
- iOS/Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_mocard.git
   cd flutter_mocard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files**
   ```bash
   flutter packages pub run build_runner build
   # If you encounter conflicts, use:
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc` - State management
- `hive` & `hive_flutter` - Local database
- `dio` - HTTP client
- `cached_network_image` - Image caching
- `sliding_up_panel` - Interactive panels

### Development Dependencies
- `build_runner` - Code generation
- `json_serializable` - JSON serialization
- `hive_generator` - Hive type adapters

## 🛠️ Development

### Code Generation

When you modify model classes or add new Hive entities, run:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

If code generation doesn't work, try restarting VS Code to regenerate `.g.dart` files.

### Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # App entry point
├── configs/                # App configuration (colors, themes, etc.)
├── core/                   # Core utilities (network, auth, etc.)
├── data/                   # Data layer (repositories, data sources)
├── domain/                 # Domain layer (entities, use cases)
├── states/                 # BLoC state management
├── ui/                     # Presentation layer
│   ├── screens/           # App screens
│   └── widgets/           # Reusable widgets
└── utils/                 # Utility functions
```

## 🎯 Roadmap

- [ ] Add offline mode support
- [ ] Implement card sharing functionality
- [ ] Add more customization options
- [ ] Integrate with external learning platforms
- [ ] Add collaborative features
- [ ] Implement advanced analytics

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [Flutter Pokedex](https://github.com/hungps/flutter_pokedex) for UI design patterns
- Flutter team for the amazing framework
- The open-source community for various packages used in this project

## 📞 Support

If you found this project helpful, please give it a ⭐️!

For support, email acidteens@gmail.com or open an issue on GitHub.

---

Made with ❤️ using Flutter