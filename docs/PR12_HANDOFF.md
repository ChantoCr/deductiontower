# PR12 Handoff — Remote Match Bootstrap Service Saved State

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
- explicit remote match contract models
- new pure Dart remote match bootstrap service

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR12_HANDOFF.md`
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

This chat completed the next recommended online step:
- **remote match bootstrap service**

Delivered and saved:
- a pure Dart online-domain service that converts:
  - a ready online room
  - secret trait selections
  - trait categories
  - character catalog data
  into:
  - `RemoteMatchBootstrapPayload`
  - initial `RemoteMatchPublicState`
  - initial `RemotePlayerPrivateState` records
- bootstrap input/result support entities
- unit tests for bootstrap success and failure paths

This keeps remote room-to-match startup explicit and testable without moving bootstrap logic into Flutter widgets.

---

## New Domain Entities Added

Added:
- `lib/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart`

### Purpose

#### `RemotePlayerBootstrapSeed`
Represents the minimum per-player private input needed to bootstrap a remote match.

Includes:
- participant id
- backend user id
- selected secret trait id
- whether the player has already viewed that secret

#### `RemoteMatchBootstrapResult`
Represents the assembled online bootstrap output.

Includes:
- final `RemoteMatchBootstrapPayload`
- initial `RemoteMatchPublicState`
- initial list of `RemotePlayerPrivateState`

Helper included:
- private-state lookup by participant id

---

## New Service Added

Added:
- `lib/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart`

### Current behavior

`RemoteMatchBootstrapService` now:
- validates that the room has:
  - host + guest
  - everyone ready
  - `readyToSync` phase
- validates secret-selection seed completeness
- resolves host/guest trait categories
- builds the shared character pool from both secret traits using `TraitFilterEngine`
- creates the initial match snapshot using `GameEngine.createMatch(...)`
- maps that into:
  - remote bootstrap payload
  - initial public match state
  - initial private player state docs

### Important architecture rule preserved

This is important and must stay true:
- online bootstrap flow may prepare remote contracts
- the existing game domain/game engine still owns official match rules and turn logic

The bootstrap service currently uses the game domain instead of bypassing it.

---

## Tests Added

Added:
- `test/features/online_multiplayer/remote_match_bootstrap_service_test.dart`

Validated behavior now includes:
- full bootstrap generation from a ready room
- host-default starting turn behavior
- explicit starting-participant override
- failure when room is not ready to sync
- failure when required secret bootstrap data is missing

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR12_HANDOFF.md`
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
- Keep remote bootstrap/public/private/action contracts explicit.
- Keep room-to-match startup logic inside the bootstrap service or similarly testable domain services, not inside widgets.
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

1. **simulate remote lobby events in the mock/preview online layer**
   - fake remote guest join
   - fake remote ready toggles
   - optionally preview a room progressing into bootstrap-ready state

2. **wire bootstrap preview into the online foundation flow**
   - expose a development-only preview card or summary for the generated remote payload/public/private state
   - keep it presentation-only and do not fake live backend sync yet

3. **later, wire Firebase-backed room creation/join/watch**
   - use the saved datasource/repository boundary
   - use the saved remote contract models and bootstrap service
   - do not duplicate official rules in the online feature

Recommended immediate next step:
- **simulate remote lobby events in the mock/preview online layer**

That is now the best follow-up because the bootstrap path exists, but the current preview lobby still cannot mimic a realistic second-device join/ready lifecycle on its own.
