# Flutter Architecture Skill

## Purpose

Use this Skill when creating or modifying Flutter structure, navigation, state management, feature folders, dependency boundaries, or app bootstrap logic.

---

## Architecture Style

Use feature-first clean architecture.

Each complex feature should have:

```txt
data/
domain/
presentation/
```

Domain must not depend on Flutter.

Presentation can depend on Flutter and Riverpod.

Data can depend on JSON loading, local storage, APIs, or external services.

## Main Project Layers

```txt
lib/
  app/
  core/
  features/
  shared/
```

### app

Responsible for:

- App root
- Routing
- Theme
- Bootstrap

### core

Responsible for:

- Constants
- Errors
- Utilities
- Enums
- Shared low-level helpers

### features

Responsible for product features:

- characters
- game
- flame_board
- ai_referee
- profile
- settings
- home

### shared

Responsible for reusable UI:

- Buttons
- Cards
- Dialogs
- Animations
- Text styles
- Colors

## State Management

Use Riverpod.

Rules:

- Keep providers close to their feature.
- Do not put all providers in one global file.
- Domain services should not depend on Riverpod.
- Controllers can use providers.
- UI widgets should call controllers, not implement business rules.

The current match state should eventually expose:

- current player
- shared character pool ids
- hint counts
- winner/end reason

## Routing

Use GoRouter.

Initial routes:

- `/`
- `/home`
- `/setup`
- `/category-selection`
- `/match`
- `/result`
- `/characters`
- `/settings`
- `/profile`

Keep route names centralized in `app/router.dart` or a route constants file.

## Entity Rules

Domain entities should be simple, readable, and testable.

Prefer immutable classes.

Do not add UI-specific fields to domain entities.

Bad:

```dart
class Player {
  Color cardColor;
}
```

Good:

```dart
class Player {
  final String id;
  final String name;
  final String secretTraitId;
}
```

Do not model lives in entities because the game has no life system.
Model the shared character pool explicitly in match state instead.

## Data Model Rules

Use model classes in the data layer when parsing JSON.

Example:

- `CharacterModel extends Character`

or

- `CharacterModel.toEntity()`

Either approach is acceptable, but be consistent.

## UI Rules

Widgets should be small and focused.

Avoid large screens with hundreds of lines.

Extract:

- Buttons
- Cards
- Panels
- Dialogs
- Lists
- Headers
- Character pool browser/search widgets

## Error Handling

Use clear app-level exceptions and failures.

Do not silently fail JSON loading.

Do not crash the UI for recoverable errors.

## Foundation Phase Scope

During the foundation phase, create:

- App shell
- Theme
- Router
- Placeholder screens
- Folder structure
- Empty/skeleton domain classes
- Empty/skeleton services
- Sample JSON files
- Character pool browsing/search placeholders

Do not implement full gameplay yet unless requested.

## Anti-Patterns

Avoid:

- All code in `main.dart`
- Business logic in widgets
- Domain depending on Flutter
- Flame components calculating match rules
- Giant global provider files
- Hardcoded data in UI
- Reintroducing life-based rules in setup or match widgets
