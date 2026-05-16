# PR3 Handoff — Anime Deduction Tower

## Project

**Anime Deduction Tower**

A Flutter + Flame mobile deduction game where players discover hidden anime-inspired character traits through turn-based guessing, tag filtering, and strategic reasoning.

---

## Core Product Direction

This project has 3 main pillars:

1. **Data-driven character system**
2. **Testable game engine**
3. **Premium mobile game experience**

---

## Non-Negotiable Rules

- Keep game logic independent from UI.
- Keep Flame visual logic separate from domain logic.
- Do not put business rules inside widgets.
- Use JSON files for character, tag, and category data.
- Do not add online multiplayer yet.
- Do not connect OpenAI yet.
- Do not use copyrighted anime images.
- Domain logic must remain testable without Flutter UI or Flame.

---

## Tech Stack

- Flutter
- Dart
- Flame
- Riverpod
- GoRouter

---

## Repository Context Already Created

### Core project docs
- `README.md`
- `AGENTS.md`
- `docs/GAME_DESIGN.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `docs/AI_AGENT_WORKFLOW.md`
- `docs/CONTRIBUTING.md`

### Skills
- `skills/game-design/SKILL.md`
- `skills/flutter-architecture/SKILL.md`
- `skills/flame-gameplay/SKILL.md`
- `skills/character-data-modeling/SKILL.md`
- `skills/ui-ux-mobile/SKILL.md`
- `skills/testing/SKILL.md`
- `skills/ai-integration/SKILL.md`

---

## What Was Completed So Far

# PR 1 — Foundation

Completed:
- Project folder structure
- App bootstrap
- App router
- Theme system
- Placeholder screens
- Shared widgets
- Core constants, utils, enums, errors
- Feature skeletons
- Flame placeholder layer
- AI referee placeholder layer
- Initial tests and fixtures
- Assets structure

### Important compile issue already fixed
A Chrome compile error happened because `CharacterLibraryScreen` used const widgets with indexed const list access.
That was fixed by replacing the preview-only implementation with JSON-backed loading.

---

# PR 2 — Local Data Foundation

Completed:

## Data loading and repositories
- Character JSON loading
- Tag JSON loading
- Category JSON loading
- Character repository wiring
- Game category repository wiring

## Character Library improvements
- Character library now loads from local JSON
- Real filtering by tag
- Real filtering by difficulty
- Combined filtering
- Clear filters support

## Category Selection improvements
- Category list loads from local JSON
- Validation layer filters invalid categories
- Category selection state added for Player 1 and Player 2
- Category selection reset support
- Protected local flow improved

## Validation layer added
Created:
- `TraitCatalogValidator`
- `TraitCatalogValidationIssue`
- `TraitCatalogValidationResult`

Validation currently checks:
- duplicate tag IDs
- duplicate category IDs
- missing category tag references
- invalid character tag references
- categories without enough matching characters

## Parsing/model tests added
Tests now cover:
- `CharacterModel`
- `CharacterTagModel`
- `TraitCategoryModel`
- `PlayerModel`
- `TurnModel`
- `GuessModel`
- `GameMatchModel`

## Extra tests added
- repository behavior tests
- validation tests
- category selection controller tests
- character library controller tests
- character library filter tests

---

## Current Key Data Files

### Assets
- `assets/data/characters.json`
- `assets/data/tags.json`
- `assets/data/categories.json`

### Note about dataset
The original sample dataset was too small for categories with `minCharacters: 5`.
The character catalog was expanded so the main categories now have enough characters for MVP validation.

---

## Current Important Source Files

### Character feature
- `lib/features/characters/data/datasources/local_character_datasource.dart`
- `lib/features/characters/data/models/character_model.dart`
- `lib/features/characters/data/models/character_tag_model.dart`
- `lib/features/characters/data/repositories/character_repository_impl.dart`
- `lib/features/characters/domain/entities/character.dart`
- `lib/features/characters/domain/entities/character_tag.dart`
- `lib/features/characters/domain/services/character_library_filter.dart`
- `lib/features/characters/presentation/controllers/character_library_controller.dart`
- `lib/features/characters/presentation/providers/character_providers.dart`
- `lib/features/characters/presentation/screens/character_library_screen.dart`

### Game data/domain already present
- `lib/features/game/data/datasources/local_game_datasource.dart`
- `lib/features/game/data/models/trait_category_model.dart`
- `lib/features/game/data/models/player_model.dart`
- `lib/features/game/data/models/turn_model.dart`
- `lib/features/game/data/models/guess_model.dart`
- `lib/features/game/data/models/game_match_model.dart`
- `lib/features/game/data/repositories/game_repository_impl.dart`
- `lib/features/game/domain/entities/game_match.dart`
- `lib/features/game/domain/entities/player.dart`
- `lib/features/game/domain/entities/turn.dart`
- `lib/features/game/domain/entities/guess.dart`
- `lib/features/game/domain/entities/guess_result.dart`
- `lib/features/game/domain/entities/trait_category.dart`
- `lib/features/game/domain/entities/trait_catalog_validation_issue.dart`
- `lib/features/game/domain/entities/trait_catalog_validation_result.dart`
- `lib/features/game/domain/services/game_engine.dart`
- `lib/features/game/domain/services/trait_filter_engine.dart`
- `lib/features/game/domain/services/hint_engine.dart`
- `lib/features/game/domain/services/match_rules_engine.dart`
- `lib/features/game/domain/services/trait_catalog_validator.dart`

### Game presentation already present
- `lib/features/game/presentation/controllers/game_setup_controller.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/presentation/controllers/category_selection_controller.dart`
- `lib/features/game/presentation/providers/trait_category_providers.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/category_selection_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`

---

## Current Tests Already Present

### Character tests
- `test/features/characters/character_repository_test.dart`
- `test/features/characters/character_model_test.dart`
- `test/features/characters/character_tag_model_test.dart`
- `test/features/characters/character_library_controller_test.dart`
- `test/features/characters/character_library_filter_test.dart`

### Game tests
- `test/features/game/game_engine_test.dart`
- `test/features/game/game_repository_impl_test.dart`
- `test/features/game/trait_filter_engine_test.dart`
- `test/features/game/hint_engine_test.dart`
- `test/features/game/match_rules_engine_test.dart`
- `test/features/game/trait_catalog_validator_test.dart`
- `test/features/game/category_selection_controller_test.dart`
- `test/features/game/game_models_test.dart`

---

## Important Constraint From This Session

Flutter/Dart CLI was not available inside the coding environment used during this chat.
So structure and code changes were made, but local verification must still be run manually with:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

---

## Next Target

# PR 3 — Implement Core Game Engine

Recommended scope:

1. **Match creation flow**
2. **Trait filtering integration**
3. **Character guess validation**
4. **Trait guess validation**
5. **Turn switching**
6. **Winner detection**

---

## Recommended PR 3 Approach

Keep PR 3 focused on pure Dart domain logic first.

### Goal
Build a real, testable game engine that does not depend on Flutter widgets or Flame.

### Suggested implementation order

#### 1. Match creation
Create a proper match initialization flow that:
- receives 2 players
- receives or resolves both secret traits
- filters valid characters for each player
- creates initial `GameMatch`
- sets current player
- starts with `MatchStatus.inProgress`

#### 2. Trait filtering integration
Use `TraitFilterEngine` with real categories and characters to generate valid character pools.

#### 3. Character guess validation
Use `MatchRulesEngine` to check if a guessed character belongs to opponent secret trait.
Return a `GuessResult` and record a `Turn`.

#### 4. Trait guess validation
Validate whether guessed trait matches opponent secret trait.
If correct, finish match and set winner.
If incorrect, define current MVP penalty behavior consistently.

#### 5. Turn switching
After valid actions, switch active player correctly.
This should remain deterministic and easy to test.

#### 6. Winner detection
Winner should be detected through explicit game engine logic, not UI.

---

## PR 3 Rules

- Do not build the full playable UI flow yet.
- Do not put game decisions in widgets.
- Do not put game decisions in Flame.
- Prefer domain services and plain Dart entities.
- Add or update unit tests for every behavior change.

---

## Suggested PR 3 Tests

Add or expand tests for:
- creating a match successfully
- generating valid character pools from selected trait
- validating correct character guess
- validating incorrect character guess
- validating correct trait guess
- validating incorrect trait guess
- switching turns after actions
- setting winner correctly
- preserving turn history

---

## Suggested Next Chat Prompt

Use this exact prompt in the next chat:

```txt
Continue Anime Deduction Tower with PR 3: Implement core game engine.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/game-design/SKILL.md
- docs/PR3_HANDOFF.md

Current status:
- PR 1 foundation is done
- PR 2 local data foundation is done
- Character library filtering is implemented
- Category validation and selection state are implemented
- Model parsing tests are implemented

Now implement PR 3 with this scope:
1. match creation flow
2. trait filtering integration
3. character guess validation
4. trait guess validation
5. turn switching
6. winner detection

Rules:
- Keep game logic pure Dart
- Do not move business logic into widgets or Flame
- Add unit tests for all core behaviors
- Make small coherent changes
- Update docs if needed
```

---

## Final Status At End Of This Chat

Foundation and PR 2 are saved.
The project is ready to begin **PR 3: core game engine** tomorrow.
