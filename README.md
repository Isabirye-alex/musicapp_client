# Little Music

A modern music player application built with Flutter.

## Features

- **Authentication**: Secure user login and registration.
- **Music Library**: Browse and manage your music collection.
- **Audio Playback**: High-quality audio playback using `just_audio`.
- **Visualizations**: Dynamic audio waveforms for an immersive experience.
- **Local Storage**: Offline support and data persistence using Hive.
- **Modern UI**: Clean and intuitive interface with light and dark mode support.

## Tech Stack

- **State Management**: [Riverpod](https://riverpod.dev/) with code generation.
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router).
- **Audio**: [just_audio](https://pub.dev/packages/just_audio) & [audio_waveforms](https://pub.dev/packages/audio_waveforms).
- **Database**: [Hive](https://pub.dev/packages/hive) for local storage.
- **Networking**: [http](https://pub.dev/packages/http).
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart).
- **Theme**: Custom comprehensive theme with dark mode support.

## Project Structure

The project follows a feature-based architecture:

- `lib/core`: Common utilities, themes, and base classes.
- `lib/features/auth`: User authentication logic and UI.
- `lib/features/home`: Main application interface and music management.
- `lib/utilis`: Helper functions and constants.

## Getting Started

### Prerequisites

- Flutter SDK: `^3.9.0`
- Android Studio or VS Code

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd musicapp_client
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the code generation:
   ```bash
   dart run build_runner build
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
