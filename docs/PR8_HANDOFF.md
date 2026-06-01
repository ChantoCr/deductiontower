# PR8 Handoff — Player-vs-AI Foundation + Better AI Reasoning + AI Difficulty Layer Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- premium gameplay UI polish in progress
- new mock player-vs-AI foundation now saved

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR8_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

---

## Runtime / Data Status

Runtime JSON assets were **not changed** in this chat.

Current live catalog state still is:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important runtime note:
- if JSON assets change again while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking review note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Import pipeline state still remains valid:
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview records
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** total promoted preview records
- there is **no approved staged backlog** remaining outside the live runtime catalog

---

## What Was Completed In This Chat

This chat moved the project from the PR7 privacy-hardened local multiplayer state into the first saved **player-vs-AI gameplay foundation**, then improved that AI layer with stronger reasoning, clearer microcopy, and a light difficulty system.

### 1. Player-vs-AI foundation was started and saved
Delivered and saved:
- home screen `Play vs AI` entry is now enabled
- setup now supports match mode selection:
  - `Single Device Match`
  - `Play vs AI`
- player-vs-AI uses the same core game engine and no-lives rules
- in player-vs-AI mode:
  - the human chooses only their own hidden tag
  - the AI hidden tag is auto-assigned at match start
  - AI turns are resolved through the same match controller + game engine flow
  - AI performs **public** actions only
  - no extra pass-the-device secrecy is required for AI turns

### 2. AI control metadata was added to the game model
Delivered and saved:
- `Player` now tracks control type:
  - `human`
  - `ai`
- `PlayerModel` now parses this control type safely
- this stays in the domain/data model layer and does **not** move rules into UI

New/updated files:
- `lib/core/enums/player_control_type.dart`
- `lib/features/game/domain/entities/player.dart`
- `lib/features/game/data/models/player_model.dart`

### 3. Mock AI opponent architecture was added
Delivered and saved:
- new AI-opponent feature foundation with:
  - AI turn decision entity
  - AI opponent service interface
  - mock AI implementation
  - Riverpod provider wiring

New files:
- `lib/features/ai_opponent/domain/entities/ai_turn_decision.dart`
- `lib/features/ai_opponent/domain/services/ai_opponent_service.dart`
- `lib/features/ai_opponent/domain/services/mock_ai_opponent_service.dart`
- `lib/features/ai_opponent/presentation/providers/ai_opponent_providers.dart`

### 4. AI reasoning quality was improved beyond the first stub
Delivered and saved:
- AI no longer just picks a simple fallback path
- AI now uses stronger deduction heuristics based on public evidence
- AI now narrows candidate traits using:
  - prior AI **character guess** outcomes
  - prior AI **incorrect trait guesses**
- AI now scores character probes using:
  - public split quality
  - expected elimination value
  - popularity weighting
- AI now decides whether to keep probing or commit to a final trait guess using:
  - remaining candidate count
  - number of prior AI public character probes
  - usefulness of the best remaining probe
- AI turn decisions now include a short reasoning summary string used by the UI

### 5. A small AI difficulty layer was added without changing core rules
Delivered and saved:
- added `AiDifficulty` enum:
  - `easy`
  - `standard`
  - `hard`
- setup now stores selected AI difficulty
- AI difficulty changes behavior only through the AI-opponent service profile
- game rules remain unchanged and still resolve inside the game engine
- current behavioral intent:
  - **Easy**: more conservative, more popularity-biased, slower to commit
  - **Standard**: balanced default
  - **Hard**: stronger information splits, faster commitment when probe value is low

New file:
- `lib/core/enums/ai_difficulty.dart`

### 6. AI-specific gameplay/setup/result microcopy was added
Delivered and saved:
- setup copy now distinguishes local multiplayer from player-vs-AI
- setup now explains AI difficulty better
- match screen now uses AI-aware wording for:
  - turn panel
  - hint panel
  - action console
  - tower panel
  - privacy gate in AI mode
- transition screen now uses AI-aware wording for:
  - AI turn briefing
  - AI difficulty badge
  - AI automated-turn messaging
- result screen now uses AI-aware wording for:
  - celebration summary
  - comparison description
  - final timeline title/description
  - AI match metadata card

This microcopy is now centralized much more cleanly in:
- `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`

### 7. Setup UI now includes AI difficulty selection
Delivered and saved:
- setup screen now includes a dedicated AI difficulty card when player-vs-AI mode is selected
- match preview now includes:
  - mode
  - AI difficulty
  - AI-aware privacy note

### 8. AI turn transition flow was integrated cleanly
Delivered and saved:
- if the next player is AI, the transition screen becomes an AI turn step instead of a secrecy handoff step
- AI turn execution happens from the transition screen
- after AI turn resolution:
  - go to result if completed
  - otherwise return to match screen
- AI turn completion dialog now includes reasoning-aware summary text

### 9. Tests were added and updated
Delivered and saved:
- added AI-opponent service tests for:
  - secret-tag choice avoiding the human trait when possible
  - final trait guess after public evidence narrows candidates
  - hard-difficulty preference for better public probes
  - hard-difficulty earlier commitment when remaining probes teach almost nothing
- updated setup controller tests for AI difficulty state
- updated match controller tests for AI turn execution
- existing tests still pass

New/updated tests:
- `test/features/ai_opponent/mock_ai_opponent_service_test.dart`
- `test/features/game/game_setup_controller_test.dart`
- `test/features/game/match_controller_test.dart`

### 10. Documentation was updated
Delivered and saved:
- `README.md` now reflects:
  - player-vs-AI foundation
  - AI difficulty layer
  - stronger AI public-probe scoring / microcopy
- `docs/ARCHITECTURE.md` now reflects:
  - AI-opponent flow
  - difficulty profile step in the AI-opponent pipeline
- `docs/DATA_MODEL.md` already reflects the newer player control metadata

---

## Current Gameplay/UI Behavior To Remember

### Local multiplayer privacy behavior must still be preserved
This remains important and must **not** be broken while working on AI or UI:
- protected pass-the-device reveal flow is implemented
- the active player’s secret tag remains hidden by default and can be privately rechecked
- the character pool browser is privacy-hardened for one-device play
- when a new human player takes the turn:
  - previous search text is cleared
  - previous filters are cleared
  - previous scroll position is reset to top
  - previous staged guess text/selection is cleared
  - a short lock overlay appears
  - then a privacy-cleared notice appears

### Player-vs-AI behavior now saved
- player-vs-AI is now selectable from the home screen
- setup supports AI difficulty selection
- in player-vs-AI mode:
  - human picks their hidden tag privately
  - AI hidden tag is auto-assigned from the current valid category catalog
  - AI turns are public-only
  - human still gets a protected hidden-tag reminder gate before live tools
  - AI turns run through the transition screen without a pass-the-device handoff
- AI difficulty currently changes AI behavior only, not match rules

### Match screen behavior
- still uses a persistent bottom action console
- still supports shared-pool browsing/search and tap-to-stage guessing
- now uses AI-aware microcopy when the match contains an AI player
- local privacy reset behavior must remain intact for human-vs-human matches

### Result screen behavior
- still includes animated winner celebration hero
- still includes winner-vs-loser comparison and replay timeline
- now includes AI-aware result summary/copy in AI matches
- now includes an `AI Match Metadata` card in AI matches
- Flame backdrop remains optional and presentation-only

### AI architecture boundary
Important rule to preserve:
- AI may suggest or choose actions
- the **game engine** still resolves official correctness, winner, surrender, and match completion
- Flame remains presentation-only

---

## Important Files Touched In This Chat

### New AI / enum foundation
- `lib/core/enums/player_control_type.dart`
- `lib/core/enums/game_mode.dart`
- `lib/core/enums/ai_difficulty.dart`
- `lib/features/ai_opponent/domain/entities/ai_turn_decision.dart`
- `lib/features/ai_opponent/domain/services/ai_opponent_service.dart`
- `lib/features/ai_opponent/domain/services/mock_ai_opponent_service.dart`
- `lib/features/ai_opponent/presentation/providers/ai_opponent_providers.dart`

### Game entities / controllers / helpers
- `lib/features/game/domain/entities/player.dart`
- `lib/features/game/data/models/player_model.dart`
- `lib/features/game/presentation/controllers/game_setup_controller.dart`
- `lib/features/game/presentation/controllers/category_selection_controller.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`
- `lib/features/game/presentation/helpers/match_lookup_helper.dart`

### Gameplay screens
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/category_selection_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`

### Gameplay widgets reused for AI-aware wording
- `lib/features/game/presentation/widgets/turn_panel.dart`
- `lib/features/game/presentation/widgets/tower_view.dart`
- `lib/features/game/presentation/widgets/hint_panel.dart`
- `lib/features/game/presentation/widgets/match_action_bar.dart`
- `lib/features/game/presentation/widgets/match_privacy_gate.dart`
- `lib/features/game/presentation/widgets/latest_public_event_card.dart`

### Tests
- `test/features/ai_opponent/mock_ai_opponent_service_test.dart`
- `test/features/game/game_setup_controller_test.dart`
- `test/features/game/category_selection_controller_test.dart`
- `test/features/game/game_models_test.dart`
- `test/features/game/match_controller_test.dart`

### Documentation
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/DATA_MODEL.md`
- `docs/PR8_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

---

## Validated Commands

Verified at the end of this chat:

```bash
flutter analyze
flutter test
```

Both passed.

---

## Recommended Next Scope

Strongest next focus after this saved state:
1. **full UI polish for the Play vs AI flow**
   - richer AI identity treatment in setup/match/result
   - better AI turn-complete summary card/dialog styling
   - AI-specific badges and motion language
   - premium AI difficulty presentation throughout the flow
2. **refine AI reasoning summaries shown to the user**
   - clearer explanation wording
   - maybe a dedicated “AI move summary” panel instead of only dialog copy
3. **consider whether AI should later use optional hints, bluff-like pacing, or category-specific behavior**
   - but keep all official rule resolution inside the game engine
4. **evaluate if the result screen should later expose AI-vs-human per-turn analytics more explicitly**
5. **later, if desired, add a real AI-provider-backed opponent behind the same interface**
   - but keep it optional and replaceable

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Keep hidden-information UX safe for one-device local multiplayer.
- Preserve the fixed bottom action areas for match and secret-tag selection.
- Preserve the searchable series-chip flow for large rosters.
- Preserve the privacy-safe browser reset, top scroll reset, staged-guess clearing, and lock-overlay flow.
- Keep Flame visual polish presentation-only.
- Keep AI action choice separate from game-engine rule resolution.
- Keep AI difficulty as a behavior/config layer, not a rules layer.
- If runtime JSON changes again, remind the user to do a full app restart.
