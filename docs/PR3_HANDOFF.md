# PR3 Handoff — Anime Deduction Tower

> Historical handoff note: this file is now mostly superseded by `docs/PR4_HANDOFF.md` for the next chat.

## Project

**Anime Deduction Tower**

A Flutter + Flame mobile deduction game where players discover hidden anime-inspired character traits through turn-based guessing, tag filtering, and strategic reasoning.

---

## Current Rule Update

The game no longer uses lives.
A match should end only when:

1. a player correctly guesses the opponent's secret trait, or
2. a player surrenders.

The match flow should also support a shared character pool that players can browse or search by name while guessing.

---

## Core Product Direction

This project has 4 main pillars:

1. **Data-driven character system**
2. **Shared character pool flow**
3. **Testable game engine**
4. **Premium mobile game experience**

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
- Do not reintroduce a life system.

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

# PR 2 — Local Data Foundation

Completed:
- Character JSON loading
- Tag JSON loading
- Category JSON loading
- Character repository wiring
- Game category repository wiring
- Character library filtering
- Category validation
- Category selection state
- Repository and parsing tests

# PR 3 — In Progress

Recently applied:
- removed lives from the current data model and setup placeholders
- added match end reason support for surrender/correct trait guess structure
- added shared character pool state to `GameMatch`
- added match creation flow inside `MatchController`
- connected real trait-filter-based pool generation from selected categories
- wired the turn transition screen to create and store the active match
- connected the match screen to the real shared pool in controller state
- added tap-to-autofill character selection from the pool
- added real character guess, trait guess, hint request, and surrender state updates
- reused the turn transition screen between turns for safer local multiplayer flow
- expanded the result screen with real timeline details
- added `NEXT_CHAT_PROMPT.md` for quick reuse
- updated docs and skills to reflect the no-lives rule set

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

### Game data/domain
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

### Game presentation
- `lib/features/game/presentation/controllers/game_setup_controller.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/widgets/category_guess_dialog.dart`
- `lib/features/game/presentation/widgets/character_pool_panel.dart`
- `lib/features/game/presentation/widgets/turn_panel.dart`

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
- `test/features/game/match_controller_test.dart`

---

## Immediate Next Target

Continue PR 3 with deeper gameplay wiring and polish.

Recommended next scope:

1. **Turn transition polish and secret-info safety checks**
2. **Hint UX refinement and per-player deduction improvements**
3. **More controller and engine invalid-action tests**
4. **Match flow cleanup before Flame integration**
5. **Optional richer prompt/replay/export tooling**

---

## Suggested PR 3 Tests

Add or expand tests for:
- creating a match successfully
- generating a valid shared character pool
- validating correct character guess
- validating incorrect character guess
- validating correct trait guess
- validating incorrect trait guess
- switching turns after actions
- setting winner correctly
- resolving surrender correctly
- preserving turn history

---

## Suggested Next Chat Prompt

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
- Foundation is done
- Local data foundation is done
- The game no longer uses lives
- GameMatch now includes shared character pool state
- Match UI includes a placeholder character pool browser/search panel
- Surrender is now part of the intended end-state model

Now implement PR 3 with this scope:
1. match creation flow
2. trait filtering integration
3. character pool generation
4. character guess validation
5. trait guess validation
6. turn switching
7. winner detection
8. surrender resolution

Rules:
- Keep game logic pure Dart
- Do not move business logic into widgets or Flame
- Add unit tests for all core behaviors
- Make small coherent changes
- Update docs if needed
```

---

## Final Status

Docs and code now reflect the no-lives rule set plus shared character pool browsing/search.
PR 3 now has a working match initialization flow, real pool generation, controller-backed match state, real character guessing, real trait guessing, private hint requests, surrender resolution, protected turn reveal, editable setup wiring, and pass-the-device transitions between turns.
Prototype external import preview and curated promotion preview tooling were also added after the original PR 3 scope.

For the next chat, use:
- `docs/PR4_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`
