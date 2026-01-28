# Aurora Assessment

[<v](https://private-user-images.githubusercontent.com/17580502/541585193-55563993-6bb5-46ad-acba-ca2cd33ffe4e.mp4?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Njk2MDEzNjIsIm5iZiI6MTc2OTYwMTA2MiwicGF0aCI6Ii8xNzU4MDUwMi81NDE1ODUxOTMtNTU1NjM5OTMtNmJiNS00NmFkLWFjYmEtY2EyY2QzM2ZmZTRlLm1wND9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNjAxMjglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjYwMTI4VDExNTEwMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTUzNTYyMjQ5MDc5NDFmZWZjMDA3OWYzOGI3MzVkNzg0YWY1YWU1ZTcxOTY5YjNmZjUyZDcxNmNmNjVlN2UyZWMmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.rg6KNwmDdT3zYrx-wi5o3eiQ2_fXmAVQ81IiQJyc06A)

A Flutter application that displays random images with dynamic color extraction and adaptive UI theming. The app fetches images from a remote API and automatically extracts gradient colors to create a visually cohesive user experience.

## Features

- **Random Image Display**: Fetches and displays random images from a remote API
- **Dynamic Color Extraction**: Automatically extracts gradient colors from images to theme the UI
- **Adaptive Theming**: UI elements adapt their colors based on the displayed image
- **Smooth Animations**: Crossfade transitions between images and animated loading states
- **Internationalization**: Supports English and German locales
- **Splash Screen**: Custom splash screen with image preloading

## Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure, ensuring separation of concerns and maintainability.

### Architecture Layers

```
lib/
├── core/                    # Shared core functionality
│   ├── di/                  # Dependency injection setup
│   ├── error/               # Error handling (Failures)
│   ├── image/               # Image precaching service
│   ├── logger/              # Logging abstraction
│   ├── network/             # HTTP client wrapper
│   ├── splash/              # Splash screen implementation
│   └── theme/               # Color extraction utilities
│
└── features/                # Feature modules
    └── random_image/        # Random image feature
        ├── data/            # Data layer
        │   ├── datasources/ # Remote data sources
        │   ├── models/      # Data models
        │   └── repositories/# Repository implementations
        ├── domain/          # Domain layer (business logic)
        │   ├── entities/    # Domain entities
        │   ├── repositories/# Repository interfaces
        │   └── usecases/   # Use cases
        └── presentation/    # Presentation layer
            ├── page/        # Page widgets
            ├── store/       # MobX stores (state management)
            ├── utils/       # Presentation utilities
            └── widgets/     # Reusable widgets
```

### Clean Architecture Principles

1. **Domain Layer**: Contains business logic, entities, and use cases. No dependencies on other layers.
2. **Data Layer**: Implements repository interfaces, handles API calls, and data transformation.
3. **Presentation Layer**: UI components, state management (MobX), and user interactions.

### State Management

The project uses **MobX** for reactive state management:
- Observable stores manage application state
- Automatic UI updates when observables change
- Code generation via `mobx_codegen` for type-safe reactivity

## Technology Stack

### Core Dependencies

- **Flutter SDK**: ^3.10.1
- **Dio**: ^5.9.1 - HTTP client for API communication
- **GetIt**: ^9.2.0 - Dependency injection container
- **MobX**: ^2.6.0 - State management
- **flutter_mobx**: ^2.0.7 - MobX bindings for Flutter
- **cached_network_image**: ^3.4.1 - Efficient image caching and loading
- **palette_generator_master**: ^1.0.1 - Color palette extraction from images
- **intl**: ^0.20.2 - Internationalization support

### Development Tools

- **flutter_test**: Testing framework
- **flutter_lints**: ^6.0.0 - Linting rules
- **build_runner**: ^2.4.7 - Code generation
- **mobx_codegen**: ^2.7.6 - MobX code generation
- **flutter_launcher_icons**: ^0.14.4 - App icon generation
- **flutter_native_splash**: ^2.4.7 - Splash screen generation

## Project Structure

### Core Module

The `core` module provides shared functionality across the application:

- **Dependency Injection**: Centralized service registration using GetIt
- **Error Handling**: Custom failure classes for error management
- **Logging**: Abstract logger implementation with debug/info/warning/error levels
- **Network**: HTTP client configuration and setup
- **Image Services**: Image precaching and color extraction utilities
- **Localization**: Generated localization files for English and German

### Feature Module: Random Image

The `random_image` feature demonstrates the Clean Architecture pattern:

#### Domain Layer
- **Entity**: `RandomImage` - Domain model representing an image URL
- **Repository Interface**: `RandomImageRepository` - Contract for data access
- **Use Case**: `GetRandomImage` - Business logic for fetching random images

#### Data Layer
- **Remote Data Source**: `RandomImageRemoteDataSource` - API communication
- **Model**: `RandomImageModel` - Data transfer object
- **Repository Implementation**: `RandomImageRepositoryImpl` - Implements domain repository

#### Presentation Layer
- **Store**: `RandomImageStore` (MobX) - Manages state, loading, errors, and image URLs
- **Page**: `RandomImagePage` - Main screen widget
- **Widgets**: 
  - `ImageView` - Image display with crossfade animations
  - `PullingColorButton` - Animated button with gradient theming
- **Utils**: Color utilities for adaptive text and error colors

## Key Features Implementation

### Dynamic Color Extraction

The app extracts gradient colors from images using `ImageColorExtractor`:
- Analyzes top and bottom rows of pixels
- Generates gradient colors for UI theming
- Adapts text and error colors based on luminance

### Image Loading & Caching

- Uses `cached_network_image` for efficient image caching
- Preloads next image in background for smooth transitions
- Crossfade animations between image changes
- Error handling with fallback UI

### State Management Flow

1. User interaction triggers action in `RandomImageStore`
2. Store calls use case (`GetRandomImage`)
3. Use case calls repository interface
4. Repository implementation fetches data from remote source
5. Data flows back through layers, updating observables
6. UI automatically updates via MobX observers

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Core utilities, error handling, logger
- **Widget Tests**: UI components and interactions
- **Test Structure**: Mirrors the source code structure

Run tests with:
```bash
flutter test
```

See `test/TEST_RESULTS.md` for detailed test results.

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.1
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code (MobX):
   ```bash
   flutter pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Build Configuration

- **Android**: Configured with adaptive icons
- **iOS**: Configured with splash screens
- **Localization**: English and German support

## Code Generation

The project uses code generation for:
- **MobX Stores**: Run `flutter pub run build_runner build` after modifying stores
- **Localization**: Generated from `.arb` files in `lib/core/l10n/`

## Design Patterns

- **Repository Pattern**: Abstracts data sources
- **Dependency Injection**: Loose coupling via GetIt
- **Observer Pattern**: MobX reactive state management
- **Use Case Pattern**: Encapsulates business logic
- **Factory Pattern**: Service creation in DI setup

## License

This project is for assessment purposes.
