# PR9 Handoff — Play vs AI Completion + Online Multiplayer Foundation / UX / Remote-Ready Lobby Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- polished mock player-vs-AI mode
- new online multiplayer room-code foundation preview

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR9_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read, if the next task touches architecture or online flow:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `skills/flutter-architecture/SKILL.md`
- `skills/testing/SKILL.md`
- `skills/ui-ux-mobile/SKILL.md`

---

## Runtime / Data Status

Runtime JSON assets were **not changed** in this chat.

Current live catalog state still is:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important runtime note:
- if JSON assets change again while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Import pipeline state remains valid:
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview records
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** total promoted preview records
- there is **no approved staged backlog** remaining outside the live runtime catalog

---

## What Was Completed In This Chat

This chat did four main things:
1. finished the current **Play vs AI** MVP presentation pass
2. started the **online multiplayer foundation**
3. polished the **online room UX**
4. expanded the online lobby into a more **remote-ready domain model**

---

## 1. Play vs AI was finished properly for the current mock/MVP scope

Delivered and saved:
- setup now includes a richer **AI opponent profile** treatment
- match screen now includes **AI duel profile** presentation
- result screen now includes:
  - AI opponent profile
  - AI performance snapshot / analytics
  - final AI move summary
- AI-specific copy is more explicit about:
  - probe focus
  - commitment style
  - duel tempo
  - AI result interpretation

### AI reasoning persistence was improved
Delivered and saved:
- AI reasoning summaries are now persisted into the match turn state as a public note
- those public notes are surfaced through:
  - AI turn completion dialog
  - latest public event card
  - public timeline entries
  - dedicated AI move summary card
  - result screen review

### New / updated AI presentation pieces
New files:
- `lib/features/game/presentation/widgets/ai_move_summary_card.dart`
- `lib/features/game/presentation/widgets/ai_opponent_profile_card.dart`
- `lib/features/game/presentation/widgets/ai_performance_summary_card.dart`

Updated files:
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`
- `lib/features/game/presentation/helpers/match_lookup_helper.dart`
- `lib/features/game/presentation/helpers/match_presentation_mapper.dart`
- `lib/features/game/presentation/widgets/guess_history.dart`
- `lib/features/game/presentation/widgets/latest_public_event_card.dart`

### AI domain/data updates
Delivered and saved:
- `Turn` now supports an optional public reasoning note for AI-visible move summaries
- `TurnModel` now parses that optional note
- `GameEngine` can record public notes for character and trait guesses
- `MatchController.runAiTurn()` now passes AI reasoning summaries into official stored turn state

Updated files:
- `lib/features/game/domain/entities/turn.dart`
- `lib/features/game/data/models/turn_model.dart`
- `lib/features/game/domain/services/game_engine.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/presentation/models/guess_history_entry.dart`
- `lib/features/game/presentation/models/match_result_comparison.dart`

### AI state status after this chat
Current saved AI behavior now includes:
- `Play vs AI` enabled from home
- setup supports local multiplayer or player-vs-AI
- AI difficulty options:
  - easy
  - standard
  - hard
- human selects only their own hidden tag
- AI hidden tag is auto-assigned at match start
- human still gets protected private reveal before live tools
- AI turns are public-only
- AI turn execution happens from the transition screen
- AI move summaries are visible in dialog, match flow, timeline, and result flow
- game engine still resolves all official rules

### Important AI architecture rule to preserve
Do **not** break this:
- AI chooses or suggests actions
- the **game engine** resolves correctness, winner, surrender, and match completion
- AI difficulty remains a behavior/config layer, **not** a rules layer

---

## 2. Online multiplayer foundation was started

Delivered and saved:
- home screen `Online Match` entry is now enabled
- new dedicated route and screen for online foundation preview
- a new online multiplayer feature area now exists with domain/data/presentation structure
- room-code lobby preview flow exists without any live backend yet

### New route
Added:
- `AppRoutes.onlineMatch = '/online-match'`

Updated file:
- `lib/app/router.dart`

### New feature structure
Added:
- `lib/features/online_multiplayer/domain/`
- `lib/features/online_multiplayer/data/`
- `lib/features/online_multiplayer/presentation/`

Initial files added:
- `lib/features/online_multiplayer/domain/entities/online_room_session.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

---

## 3. Online room UX was polished

Delivered and saved:
- explicit **host vs guest** lobby path switching
- clearer readiness presentation
- more mode-aware copy in the online screen
- formatted room-code display for readability
- one-tap room-code copy flow
- better empty-state and active-session messaging
- clearing stale session previews when switching between host/join flow

### Lobby mode behavior
Delivered and saved:
- `OnlineLobbyMode.host`
- `OnlineLobbyMode.join`
- join action only becomes available in join mode
- switching lobby mode clears stale preview session state

---

## 4. Online lobby was expanded into a remote-ready domain model

This is the biggest online architecture change from the end of the chat.

### New participant-level domain model
Added:
- `OnlineRoomParticipant`
- `OnlineRoomParticipantRole`
- `OnlineRoomParticipantConnectionState`

New file:
- `lib/features/online_multiplayer/domain/entities/online_room_participant.dart`

### Online room session is now more backend-ready
`OnlineRoomSession` no longer stores only simple host/guest strings. It now models:
- `roomCode`
- `localParticipantId`
- `participants`
- `phase`
- `createdAt`

It also exposes helpers for:
- local participant
- host participant
- guest participant
- participant count
- guest existence
- everyone-ready state
- derived host/guest display labels

### Room phases are now more explicit
Current phases now are:
- `waitingForOpponent`
- `waitingForReady`
- `readyToSync`

This gives the online model a cleaner bridge to future realtime work.

### Ready-state handling was added
Delivered and saved:
- repository now supports `setLocalParticipantReady(...)`
- controller now supports `toggleLocalReady()`
- online screen now lets the local preview player mark ready / not ready
- mock repository promotes a fully-ready room into `readyToSync`

### Connection-state preview behavior
Current mock behavior intentionally keeps a backend-free preview model:
- host-created rooms start with one local host participant and phase `waitingForOpponent`
- guest join preview creates:
  - one remote host preview participant
  - one local guest preview participant
  - phase `waitingForReady`
- if every participant in the preview session is ready, phase becomes `readyToSync`

This is still local/mock-only and is **not** realtime networking yet.

---

## Current Gameplay/UI/Online Behavior To Remember

### Local multiplayer privacy behavior must still be preserved
Do **not** break any of this while working on online systems:
- protected pass-the-device reveal flow is implemented
- active player’s secret tag stays hidden by default and can be privately rechecked
- character pool browser is privacy-hardened for one-device human-vs-human play
- when a new human turn starts:
  - previous search text is cleared
  - previous filters are cleared
  - previous scroll position is reset to top
  - previous staged guess text/selection is cleared
  - a short lock overlay appears
  - then a privacy-cleared notice appears

### Play vs AI behavior now saved
- player-vs-AI is in a strong current MVP/polish state
- AI profile cards, AI performance cards, and AI move summaries are integrated
- AI reasoning public notes are stored in turn state
- result screen exposes AI-specific replay context
- official rules still belong to the game engine

### Online match foundation behavior now saved
- home screen can open the online foundation screen
- the online screen is still a **preview / architecture screen**, not live multiplayer
- the online screen now supports:
  - host flow
  - guest flow
  - normalized join-code UX
  - mock room creation / join preview
  - explicit room participants
  - ready toggling for the local participant
  - room phase transitions for previewed readiness
  - copy room code
  - future-milestone explanation panels

### Important online architecture rule to preserve
Do **not** let online work bypass the existing game domain.

Important rule:
- remote lobby / room / transport state can live in the online feature
- **official match rules must still be resolved by the existing game domain/game engine**
- future backend work should replace the mock room repository behind the same interface when possible

---

## Important Files Touched In This Chat

### AI completion / polish
- `lib/features/game/domain/entities/turn.dart`
- `lib/features/game/data/models/turn_model.dart`
- `lib/features/game/domain/services/game_engine.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`
- `lib/features/game/presentation/helpers/match_lookup_helper.dart`
- `lib/features/game/presentation/helpers/match_presentation_mapper.dart`
- `lib/features/game/presentation/models/guess_history_entry.dart`
- `lib/features/game/presentation/models/match_result_comparison.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/widgets/ai_move_summary_card.dart`
- `lib/features/game/presentation/widgets/ai_opponent_profile_card.dart`
- `lib/features/game/presentation/widgets/ai_performance_summary_card.dart`
- `lib/features/game/presentation/widgets/guess_history.dart`
- `lib/features/game/presentation/widgets/latest_public_event_card.dart`
- `lib/shared/widgets/app_dialog.dart`

### Online multiplayer foundation / UX / remote-ready lobby
- `lib/app/router.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/online_multiplayer/domain/entities/online_room_participant.dart`
- `lib/features/online_multiplayer/domain/entities/online_room_session.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

### Tests
- `test/features/game/game_engine_test.dart`
- `test/features/game/game_models_test.dart`
- `test/features/game/game_flow_copy_helper_test.dart`
- `test/features/game/match_controller_test.dart`
- `test/features/game/match_presentation_mapper_test.dart`
- `test/features/game/match_result_comparison_model_test.dart`
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_lobby_controller_test.dart`

### Documentation
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR9_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

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

Best next options from this saved state:

1. **first backend abstraction for Firebase/Supabase without full live sync**
   - keep the repository interface
   - add backend-ready datasource/repository boundaries
   - do not wire final production sync yet unless requested

2. **online room setup → remote match bootstrap flow**
   - define how a ready online room maps into a future remote match payload
   - keep official match rules in the existing game domain

3. **simulate remote lobby events in the mock online layer**
   - fake remote guest join
   - fake remote ready toggles
   - test room phase transitions more deeply

4. **later, wire realtime room membership and room state transport**
   - but do not duplicate rule resolution in the online feature

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Preserve hidden-information UX safety for one-device local multiplayer.
- Preserve the fixed bottom action areas for match and secret-tag selection screens.
- Preserve the searchable series-chip flow for large rosters.
- Preserve the privacy-safe browser reset, top scroll reset, staged-guess clearing, and lock-overlay flow.
- Keep Flame visual polish presentation-only.
- Keep AI action choice separate from game-engine rule resolution.
- Keep AI difficulty as a behavior/config layer, not a rules layer.
- Keep online room/lobby state separate from official match-rule resolution.
- Future realtime/backend work should extend the online repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.
