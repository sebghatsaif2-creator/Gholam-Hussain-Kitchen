# آشپزخانه غلام حسین — Gholam Hussain Kitchen

A premium, offline-first Flutter recipe discovery and cooking app. The primary interface is Persian/Dari with right-to-left layout; content is served from a local, typed recipe catalogue and user preferences are persisted on-device.

## Highlights

- Animated splash and three-page onboarding flow.
- Four preserved bottom-navigation destinations: home, search, favourites and profile.
- 30 Afghan, Persian and international sample recipes, with recipe categories, local food photography, ingredients, nutrition, timing and cooking steps.
- Live name/ingredient/category search, recent and popular queries, cuisine/difficulty/time filters and sorting.
- Recipe detail pages with hero photos, favourites, clipboard sharing and serving-size ingredient scaling.
- Focused cooking mode with step-by-step progress, ingredient checklist and a start/pause/reset timer.
- Local persistence for favourites, searches, cooking history, theme and profile preferences via SharedPreferences.
- Light/dark themes, accessible text-size preference UI, settings, privacy and app information.
- Responsive layouts and a reusable recipe/model/data separation designed for future repository-backed data sources.

## Requirements

- Flutter SDK with Dart 3.5 or newer (stable channel recommended).
- Android Studio/Android SDK for Android builds; Xcode on macOS for iOS builds.

## Run locally

```sh
flutter pub get
flutter run
```

For a debug Android package:

```sh
flutter build apk --debug
```

For iOS (on macOS with Xcode installed):

```sh
flutter build ios --debug
```

## Tests and analysis

```sh
dart format .
flutter analyze
flutter test
```

## Project structure

```text
lib/
  app/                    App shell and GoRouter routes
  core/                   Theme, local state and Persian utilities
  data/models/             Typed recipe and ingredient models
  data/datasources/        Offline sample catalogue
  features/                Onboarding, home, search, detail, cook, etc.
  shared/widgets/          Reusable recipe cards and navigation
assets/images/recipes/     Bundled offline recipe photographs
test/                      Recipe catalogue and quantity tests
```

All recipe content and interaction are local. No account, API, Firebase, database, or network connection is required. English is listed as a future locale option; the current product copy and screens are Persian/Dari.
