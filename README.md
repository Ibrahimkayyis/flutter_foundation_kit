# Flutter Foundation Kit (`flutter_foundation_kit`)

Universal Shared Core & Utility Packages for Flutter applications, built with Clean Architecture, Melos, and Dart Workspace.

## Packages

| Package | Description |
| :--- | :--- |
| **`app_types`** | Universal domain primitives, Result/Resource monads, Paginated model, and standard exceptions. |
| **`app_bloc_wrapper`** | Generic Cubits (`GetDataCubit`, `GetDataCubitWithParams`, `FormCubit`) and states for reactive UI without boilerplate. |
| **`app_core`** | Clean Architecture usecases, pluggable backend-agnostic Dio API client, secure storage, session & preferences handler, and extensions. |
| **`app_ui`** | Theme-flexible UI kit, form fields, action buttons, state widgets (empty/loading/error), and dialogs/overlays. |

## Usage via Git Dependency

You can add any package directly to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  app_types:
    git:
      url: https://github.com/<your-username>/flutter_foundation_kit.git
      path: packages/app_types
      ref: main

  app_bloc_wrapper:
    git:
      url: https://github.com/<your-username>/flutter_foundation_kit.git
      path: packages/app_bloc_wrapper
      ref: main

  app_core:
    git:
      url: https://github.com/<your-username>/flutter_foundation_kit.git
      path: packages/app_core
      ref: main

  app_ui:
    git:
      url: https://github.com/<your-username>/flutter_foundation_kit.git
      path: packages/app_ui
      ref: main
```

## Local Development (Melos)

- **Bootstrap dependencies**:
  ```bash
  fvm flutter pub get
  ```
- **Run tests**:
  ```bash
  melos run test
  ```
- **Run static analysis**:
  ```bash
  melos run analyze
  ```
- **Format code**:
  ```bash
  melos run format
  ```
