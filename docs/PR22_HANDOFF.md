# PR22 Handoff — Remote Queued-Action Resolver/Application Layer

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives local match rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- polished mock player-vs-AI mode
- online multiplayer foundation
- Firebase-backed room create/join/watch/readiness flow
- explicit remote bootstrap/public/private/action contracts
- reconnect-aware room-to-match handoff UX
- read-only remote match screen-state hydration
- queued online player action submission/watch flow
- pure Dart queued-action resolver/application flow

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR22_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read before coding if touching online architecture/tests/UI:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `skills/flutter-architecture/SKILL.md`
- `skills/testing/SKILL.md`
- `skills/ui-ux-mobile/SKILL.md`

---

## Runtime / Data Status

Runtime JSON assets were **not changed** in this chat.

Current live catalog state remains:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important runtime note:
- if JSON assets change while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

---

## What Was Added In This Chat

This chat completed the next saved online step:

## **remote queued-action resolver/application layer**

### 1. Added a pure Dart remote action resolver
Added:
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_error_code.dart`

What it does:
- reads explicit remote bootstrap/public/private contracts
- validates queued action ownership, turn authority, match status, and expected version
- applies supported actions through the existing game-domain engine/services:
  - character guess
  - trait guess
  - hint request
  - surrender
- updates remote public-state fields such as:
  - current turn participant
  - turn number
  - hints remaining
  - guess counters
  - winner/end reason
  - match version
  - last resolved action id
- updates affected private state for hint requests
- marks actions as applied or rejected with explicit error codes and resolution timestamps

Important rule preserved:
- official rule resolution lives in a pure Dart service, not in Firebase glue and not in widgets

### 2. Added explicit copy/update helpers on remote contracts
Updated:
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_player_private_state.dart`

These now support the resolver/application flow without rebuilding ad-hoc maps.

### 3. Added a Firestore resolution bundle builder
Added:
- `lib/features/online_multiplayer/data/services/remote_match_firestore_action_resolution_bundle_builder.dart`

What it does:
- converts a resolved remote action result into explicit persistence docs for:
  - `match_public/current`
  - affected `private_player_state/{participantId}`
  - `player_actions/{actionId}`

Important rule preserved:
- transport persistence still uses explicit models/docs instead of in-widget maps

### 4. Extended datasource/repository boundaries for resolution reads + writes
Updated:
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`

New boundary methods:
- `readMatchHandoff({ roomCode, participantId })`
- `persistActionResolution({ roomCode, resolution })`

Important rule preserved:
- presentation/application code requests explicit contracts and persistence through the repository boundary

### 5. Extended Firebase datasource for guarded resolution persistence
Updated:
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`

New Firebase behavior:
- one-shot read of persisted bootstrap/public/private docs for a target participant
- transaction-based resolution persistence for:
  - `match_public/current`
  - affected `private_player_state/{participantId}`
  - `player_actions/{actionId}`
- transaction guards validate:
  - public match doc exists
  - queued action doc exists
  - queued action is still `pending`
  - current public `matchVersion` still matches the resolver base version

Important rule preserved:
- Firebase only persists explicit resolution artifacts and guards concurrent writes
- Firebase still does **not** decide game rules itself

### 6. Kept preview/mock paths compatible
Updated:
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`

Behavior now:
- mock mode still returns no persisted handoff docs
- mock mode can still store queued actions
- mock mode can now persist resolved action statuses in memory when explicitly asked
- preview adapters continue delegating through the same datasource boundary

Important rule preserved:
- app still boots and works when Firebase config is missing

### 7. Added a presentation-side resolution controller + provider wiring
Added:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`

Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`

New provider/controller behavior:
- loads valid categories + characters through providers
- reads persisted participant-scoped handoff docs through the repository
- resolves a specific queued action
- resolves the oldest pending queued action in FIFO order
- persists the result through the repository boundary

Important rule preserved:
- widgets still call a controller/provider instead of reading backend docs or applying rules directly

### 8. Added lobby-side debug resolution UX
Updated:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

New debug UX:
- existing queue feed now includes **Resolve Oldest Pending Action**
- action resolution result is surfaced through snackbars
- explanatory copy now distinguishes:
  - queue submission/watch transport
  - pure Dart rule application
  - repository-backed persistence of resolved docs

Important rule preserved:
- this remains debug/application UX, not widget-owned rule logic

### 9. Added and updated tests
Added:
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

Updated:
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`

Coverage added:
- applied character-guess resolution
- applied hint-request resolution with private hint updates
- stale-version rejection behavior
- surrender resolution
- explicit Firestore action-resolution doc building
- mock resolved-action status persistence

### 10. Updated docs for the new saved state
Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`

Created:
- `docs/PR22_HANDOFF.md`

---

## Current Online Multiplayer State After This Chat

The online feature now has these saved layers:

### Preview / lobby layer
- host / guest room-code flow
- readiness phases
- mock guest join and ready simulation
- preview-compatible datasource adapters

### Firebase room layer
- guarded runtime initialization
- anonymous-auth create/join/watch readiness flow
- Firestore room docs and participant docs

### Remote contract layer
- bootstrap payload contract
- public match contract
- private player contract
- online player action contract

### Bootstrap persistence layer
- write bootstrap/public/private docs when room reaches `readyToSync`
- deterministic bootstrap build through pure Dart services

### Reconnect / handoff layer
- watch persisted bootstrap/public/private docs
- read persisted bootstrap/public/private docs once for a target participant
- handoff UI distinguishes pending / partial / ready
- remote screen-state hydration produces a gameplay-ready read-only state

### Action queue layer
- queue explicit online player action contracts
- Firebase persists queued action docs
- mock mode stores queued actions in memory
- watched queue feed is available through providers/UI

### Action resolver/application layer
- pure Dart resolver applies queued actions through the existing game engine
- public/private/action resolution updates remain explicit contracts
- Firebase transaction persistence guards version/status races
- debug UI can resolve the oldest pending action through providers/controllers

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep queued action submission/watch transport-focused.
- Keep action resolution pure Dart where possible.
- Keep Firebase persistence focused on reading/writing explicit docs plus concurrency guards.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep widgets thin: they should call providers/controllers, not build backend maps or rule resolution.
- Do **not** move official rule ownership into Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added In This Chat

- `docs/PR22_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_error_code.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/data/services/remote_match_firestore_action_resolution_bundle_builder.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

## Files Updated In This Chat

- `README.md`
- `NEXT_CHAT_PROMPT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_player_private_state.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`

---

## Validated Commands In This Chat

Verified during this chat:

```bash
flutter analyze
flutter test
```

Both passed at the final saved state.

---

## Best Next Step For Tomorrow

The strongest next step is:

## **decide and implement a clearer online action-resolution owner/executor flow**

Recommended scope:
1. choose who should officially resolve queued actions in-app for now:
   - host-only client
   - local debug/manual trigger
   - future Cloud Function / server authority
2. prevent non-authoritative clients from seeing or invoking resolver controls outside the intended preview/debug scope
3. add richer resolution metadata if needed, such as:
   - rejection reason presentation labels
   - optional resolver participant id
   - optional resolution summary text
4. consider whether remote public state should start storing a minimal official turn timeline or last-applied summary for the future online match UI
5. keep Firebase transport focused on persistence/guards rather than rule ownership

---

## Firebase Reminder For Tomorrow

To exercise `firebaseBackend`, run with dart defines such as:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=...
```

If those are missing, the app should still boot in mock mode.
