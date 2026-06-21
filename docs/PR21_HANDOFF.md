# PR21 Handoff — Full Saved Context For This Chat

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
- queued online player action submission and watch flow

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR21_HANDOFF.md`
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

## Project State Already Saved Before This Chat

### Core local game state
Saved and working:
- no-lives rules
- shared character pool generation
- character guessing
- trait guessing
- surrender flow
- hint flow
- result flow
- protected local multiplayer reveal/handoff flow
- privacy-safe pool browser reset between human turns
- fixed bottom action areas
- premium gameplay-facing UI polish

### AI state
Saved and working:
- Play vs AI from home
- setup supports local multiplayer and player-vs-AI
- AI difficulty:
  - easy
  - standard
  - hard
- AI hidden tag auto-assignment
- AI public automated turns
- AI reasoning summaries stored in public notes
- richer AI-specific setup/live/result presentation

### Online state before this chat started
Already saved before this chat:
- dedicated online room foundation screen
- room-code normalization and copy flow
- host-vs-guest lobby switching
- participant-based lobby model
- room phases:
  - `waitingForOpponent`
  - `waitingForReady`
  - `readyToSync`
- mock guest join / mock ready simulation
- backend-target abstraction:
  - `mockPreview`
  - `firebasePreview`
  - `firebaseBackend`
  - `supabasePreview`
- Firebase runtime config guard
- Firebase anonymous-auth room create/join/watch/readiness wiring
- explicit remote models:
  - `RemoteMatchBootstrapPayload`
  - `RemoteMatchPublicState`
  - `RemotePlayerPrivateState`
  - `OnlinePlayerAction`
- pure Dart `RemoteMatchBootstrapService`
- deterministic `RemoteMatchPreviewSeedService`
- Firestore bootstrap persistence for:
  - `online_rooms/{roomCode}/match_bootstrap/current`
  - `online_rooms/{roomCode}/match_public/current`
  - `online_rooms/{roomCode}/private_player_state/{participantId}`
- Firestore read/watch support for persisted bootstrap/public/private docs
- reconnect-aware room-to-match handoff UI
- read-only remote match screen-state hydration from persisted docs plus local catalog data

---

## What Was Done In This Chat

This chat completed the next online step:

## **queued online player action submission + read/watch flow**

### 1. Extended the datasource/repository boundary for queued actions
Added explicit transport methods across the online boundary:
- `submitPlayerAction({ roomCode, action })`
- `watchPlayerActions(roomCode)`

Updated files:
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`

Important rule preserved:
- online action transport stays separate from official match-rule resolution

### 2. Added a pure Dart remote action contract factory
Added:
- `lib/features/online_multiplayer/domain/services/remote_match_action_factory.dart`

What it does:
- builds explicit `OnlinePlayerAction` contracts from `RemoteMatchScreenState`
- validates that the local player is allowed to queue an action
- uses the hydrated remote screen state as the source of:
  - participant id
  - user id
  - expected match version
  - shared-pool membership
  - local hint availability

Supported queued actions now include:
- character guess
- trait guess
- hint request
- surrender

Important rule preserved:
- this service creates transport payloads only
- it does **not** apply game rules

### 3. Added a lightweight presentation-side queue controller
Added:
- `lib/features/online_multiplayer/presentation/controllers/online_action_queue_controller.dart`

This controller wraps repository submission for:
- `queueHintRequest(...)`
- `queueCharacterGuess(...)`
- `queueTraitGuess(...)`
- `queueSurrender(...)`

Important rule preserved:
- widgets call a controller/provider instead of building raw Firestore maps

### 4. Extended Firebase datasource for queued action persistence
Updated:
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`

New Firebase behavior:
- action docs are written to:
  - `online_rooms/{roomCode}/player_actions/{actionId}`
- action submission validates that:
  - Firebase is initialized
  - the user is signed in
  - the submitted action user id matches the signed-in Firebase user
  - the remote match bootstrap/public state already exists
- watched action docs are mapped back into `OnlinePlayerAction`
- actions are emitted newest-first

Important rule preserved:
- Firebase datasource only persists and watches action contracts
- it still does **not** resolve queued actions into public/private match updates

### 5. Extended mock / preview action flow so non-Firebase mode still works
Updated:
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`

Behavior now:
- mock mode stores queued actions in memory
- preview adapters delegate to the mock queue behavior
- tests and preview flows remain usable without Firebase config

### 6. Extended hydrated remote match screen state for queueing support
Updated:
- `lib/features/online_multiplayer/domain/entities/remote_match_screen_state.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_screen_state_loader.dart`

New screen-state fields/helpers now include:
- `matchVersion`
- `lastResolvedActionId`
- `canQueueLocalAction`

This gives the queue layer the data it needs without pushing rule logic into widgets.

### 7. Added providers for queue submission and live queue watching
Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`

Added:
- `remoteMatchActionFactoryProvider`
- `onlineActionQueueControllerProvider`
- `onlinePlayerActionsProvider`

Important rule preserved:
- provider wiring keeps the backend behind the repository boundary

### 8. Added lobby-side debug UX for queued actions
Updated:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

The reconnect-ready Firebase handoff card now includes:
- action queue controls for:
  - hint request
  - first shared-pool character probe
  - surrender
- live watched queue feed
- status badges for:
  - pending
  - applied
  - rejected

Important rule preserved:
- this is transport/debug UX only
- it does **not** resolve queued actions locally

### 9. Added and updated tests
Added:
- `test/features/online_multiplayer/remote_match_action_factory_test.dart`

Updated:
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`

New coverage includes:
- valid hint action creation
- valid shared-pool character action creation
- rejection when attempting to queue a character outside the shared pool
- mock datasource queue persistence and watch behavior

### 10. Updated docs for the new saved state
Updated during this chat:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`

Created during this chat:
- `docs/PR20_HANDOFF.md`
- `docs/PR21_HANDOFF.md`

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
- handoff UI distinguishes pending / partial / ready
- remote screen-state hydration produces a gameplay-ready read-only state

### Action queue layer
- queue explicit online player action contracts
- Firebase persists queued action docs
- mock mode stores queued actions in memory
- watched queue feed is available through providers/UI

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep queued action submission/watch transport-focused.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep widgets thin: they should call providers/controllers, not build backend maps or rule resolution.
- Do **not** resolve queued actions inside Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added In This Chat

- `docs/PR20_HANDOFF.md`
- `docs/PR21_HANDOFF.md`
- `lib/features/online_multiplayer/domain/services/remote_match_action_factory.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_queue_controller.dart`
- `test/features/online_multiplayer/remote_match_action_factory_test.dart`

## Files Updated In This Chat

- `NEXT_CHAT_PROMPT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_screen_state.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_screen_state_loader.dart`
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

## **add a remote action resolver/application layer that updates public/private docs from queued actions**

Recommended scope:
1. keep resolver logic pure Dart where possible
2. apply queued actions against the existing game engine and supporting rule services
3. update persisted docs for:
   - `match_public/current`
   - affected `private_player_state/{participantId}`
   - `player_actions/{actionId}` status / resolution metadata
4. keep Firebase transport focused on persistence/watching rather than rule ownership
5. keep mock mode working if Firebase config is missing

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
