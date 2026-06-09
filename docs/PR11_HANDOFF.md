# PR11 Handoff — Remote Match Contract Models Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- polished mock player-vs-AI mode
- online multiplayer lobby foundation preview
- backend-ready online datasource/repository abstraction
- new remote match bootstrap/public/private/action contract models

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR11_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read when touching architecture, online flow, or tests:
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

---

## What Was Completed In This Chat

This chat completed the next recommended online step after the Firebase schema design:
- **explicit remote match contract models**

Delivered and saved:
- pure Dart online domain entities for:
  - remote room-to-match bootstrap payloads
  - public remote match snapshots
  - private player remote state
  - queued player action intents
- data-layer models for JSON/Firestore-shaped mapping
- unit tests for the new online models

This gives the project a cleaner bridge between:
- room/lobby state
- future Firebase documents
- eventual remote match startup/sync
- the existing game domain that still owns official rules

---

## New Domain Entities Added

Added:
- `lib/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_player_private_state.dart`
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`

Also added:
- `lib/core/enums/online_player_action_status.dart`

### Current purpose of these entities

#### `RemoteMatchBootstrapPayload`
Represents the clean handoff from a ready online room into remote match startup.

Includes:
- room code
- match id
- host/guest participant ids
- starting participant id
- host/guest player names
- hints per player
- host/guest secret trait ids
- shared character pool ids
- created time

Helpers now include:
- required participant validation
- secret assignment validation
- playable pool validation
- `canStartMatch`

#### `RemoteMatchPublicState`
Represents the shared public remote match snapshot both clients can watch.

Includes:
- match id
- room code
- public match status
- current turn participant id
- turn number
- shared character pool ids
- public player summaries
- winner/end metadata
- last resolved action id
- match version
- created/updated timestamps

#### `RemotePlayerPrivateState`
Represents player-private remote data that should not be exposed to the opponent.

Includes:
- participant id
- backend user id
- secret trait id
- secret lock/view flags
- hints used
- latest private hint text
- selected/updated timestamps

#### `OnlinePlayerAction`
Represents queued remote action intents.

Includes:
- action id
- submitting participant/user ids
- action type
- character or trait payload fields when relevant
- expected match version
- resolver status
- error code
- created/resolved timestamps

---

## New Data Models Added

Added:
- `lib/features/online_multiplayer/data/models/remote_match_bootstrap_payload_model.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_player_state_model.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_state_model.dart`
- `lib/features/online_multiplayer/data/models/remote_player_private_state_model.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`

### Current behavior

These models now support:
- `fromJson(...)`
- `toEntity()`
- `fromEntity(...)`
- `toJson()`

Important implementation details already saved:
- `RemoteMatchPublicStateModel` maps Firebase-friendly `playerPublicState` maps into readable entity lists
- `OnlinePlayerActionModel` maps action payloads into explicit `characterId` / `traitId` fields while still serializing back into a Firestore-friendly `payload` object
- safe defaults exist for unknown or missing status/action values

---

## Tests Added

Added:
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`

Validated behavior now includes:
- playable bootstrap payload detection
- safe bootstrap defaults
- public match snapshot parsing and player-state lookup helpers
- completed match metadata parsing
- private-state hint helpers
- online action payload parsing and status fallback behavior

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR11_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Preserve hidden-information UX safety for one-device local multiplayer.
- Keep Flame visual polish presentation-only.
- Keep AI action choice separate from game-engine rule resolution.
- Keep AI difficulty as a behavior/config layer, not a rules layer.
- Keep online room/lobby state separate from official match-rule resolution.
- Keep remote bootstrap/public/private/action contracts explicit instead of falling back to ad-hoc nested maps in widgets.
- Future realtime/backend work should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

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

Best next options from this new saved state:

1. **build a remote match bootstrap service**
   - turn a ready online room + selected secret data into:
     - `RemoteMatchBootstrapPayload`
     - initial `RemoteMatchPublicState`
     - initial `RemotePlayerPrivateState`
   - keep official rule resolution in the existing game domain

2. **simulate remote lobby events in the mock/preview online layer**
   - fake remote guest join
   - fake remote ready toggles
   - deepen room phase tests

3. **later, wire Firebase-backed room creation/join/watch**
   - use the saved datasource/repository boundary
   - use the saved remote contract models
   - do not duplicate official rules in the online feature

Recommended immediate next step:
- **remote match bootstrap service**

That is now the cleanest follow-up because the contract models exist, but nothing yet builds those contracts from ready room state.
