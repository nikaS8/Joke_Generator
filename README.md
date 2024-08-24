# Joke Generator

## Overview

Joke Generator is a test project developed for practicing the use of Streams in Dart. This Flutter application fetches random jokes from an external service and displays them on the screen with a new joke being automatically updated every 10 seconds. The project also includes animations for smoother transitions between jokes and basic error handling with a retry mechanism.

## Features

- **Random Joke Generation**: The app fetches a new random joke every 10 seconds using a periodic timer.
- **Stream Handling**: Utilizes Dart's `StreamController` with `broadcast` to manage the flow of jokes and update the UI reactively.
- **Animations**: Smooth transitions between jokes using Flutter's `AnimationController` and `AnimatedBuilder`.
- **Error Handling**: Displays an error message with a retry button if the joke fetch fails.
- **User Interface**: Features a clean and minimal UI, including a card view for jokes and a loading indicator while jokes are being fetched.

## Getting Started

### Prerequisites

To run this project, ensure you have the following installed:

- Flutter SDK
- Dart SDK

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/joke-generator.git
    ```
2. **Navigate to the project directory**:
    ```bash
    cd joke-generator
    ```
3. **Install dependencies**:
    ```bash
    flutter pub get
    ```
4. **Run the app**:
    ```bash
    flutter run
    ```

## Project Structure

- `lib/`
  - `main.dart`: The main entry point of the application, handling the app's overall structure and logic.
  - `models/`
    - `joke.dart`: The model class representing a joke, which can either be a single joke or a two-part joke.
  - `service/`
    - `JokeService.dart`: Service class responsible for fetching jokes from an external API.

## Learning Objectives

This project is primarily focused on:

- Practicing the implementation of Streams in Dart.
- Managing asynchronous data flow in Flutter applications.
- Implementing animations in Flutter to enhance user experience.
- Handling errors and providing a user-friendly retry mechanism.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- This project was inspired by the need to practice and solidify understanding of Dart Streams and Flutter animations.
