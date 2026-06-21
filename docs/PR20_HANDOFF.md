# PR20 Handoff — Queued Online Player Action Submission + Watch Flow

## Project

**Anime Deduction Tower**

Continue from the saved PR19 online-foundation state plus this increment.

This chat added queued online player action submission and live action-queue watch flow through the online datasource/repository boundary.

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR20_HANDOFF.md`
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

Current live catalog state is unchanged:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important runtime note:
- if JSON assets change while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

---

## What Was Done In This Chat

### 1. Extended the online boundary for player actions
Added submit/watch support across:
- `OnlineRoomDataSource`
- `OnlineRoomRepository`
- `OnlineRoomRepositoryImpl`

New contract methods:
- `submitPlayerAction({ roomCode, action })`
- `watchPlayerActions(roomCode)`

### 2. Added pure Dart action creation service
Added:
- `RemoteMatchActionFactory`

What it does:
- builds explicit `OnlinePlayerAction` contracts from a hydrated `RemoteMatchScreenState`
- validates local-turn queueing rules on the client side
- supports:
  - character guess
  - trait guess
  - hint request
  - surrender
- stamps:
  - participant id
  - user id
  - expected match version
  - action id / createdAt

Important rule preserved:
- this is only transport-contract creation
- official action resolution still does **not** happen in widgets or Firebase glue

### 3. Added lightweight presentation controller for queue submission
Added:
- `OnlineActionQueueController`

This controller uses:
- `OnlineRoomRepository`
- `RemoteMatchActionFactory`

Current controller methods:
- `queueHintRequest(...)`
- `queueCharacterGuess(...)`
- `queueTraitGuess(...)`
- `queueSurrender(...)`

### 4. Wired Firebase action persistence + watch flow
Updated:
- `FirebaseOnlineRoomDataSource`

Current behavior:
- submits action docs to:
  - `online_rooms/{roomCode}/player_actions/{actionId}`
- validates that the signed-in Firebase user matches the queued action user id
- ensures remote bootstrap/public docs exist before action submission
- watches the `player_actions` collection and maps docs back into `OnlinePlayerAction`
- sorts watched actions newest-first in memory

### 5. Wired mock/preview action queue support
Updated:
- `MockOnlineRoomDataSource`
- Firebase preview datasource
- Supabase preview datasource

Behavior now:
- mock mode stores queued actions in memory
- preview adapters delegate to the mock queue implementation
- this keeps tests and non-Firebase development paths working

### 6. Added providers for queueing and watching actions
Updated:
- `online_multiplayer_providers.dart`

Added:
- `remoteMatchActionFactoryProvider`
- `onlineActionQueueControllerProvider`
- `onlinePlayerActionsProvider`

### 7. Added lobby-side action queue UX
Updated:
- `online_room_handoff_card.dart`

The Firebase reconnect-ready section now includes:
- queue controls for:
  - hint request
  - first shared-pool character probe
  - surrender
- live watched action feed
- action status counts:
  - pending
  - applied
  - rejected

Important rule preserved:
- this UI only submits and watches explicit remote action contracts
- it does not resolve them locally

### 8. Added tests
Added:
- `test/features/online_multiplayer/remote_match_action_factory_test.dart`

Updated:
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`

Covered behavior:
- action factory builds valid queued contracts
- invalid off-pool character queueing throws
- mock repository stores and watches queued actions

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep queued action submission and watch flow outside widgets where possible, with widgets only invoking controllers/providers.
- Do not resolve queued actions inside Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added

- `docs/PR20_HANDOFF.md`
- `lib/features/online_multiplayer/domain/services/remote_match_action_factory.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_queue_controller.dart`
- `test/features/online_multiplayer/remote_match_action_factory_test.dart`

## Files Updated

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

## Best Next Step

The strongest next step is:

## **add a remote action resolver/application layer that updates public/private docs from queued actions**

Recommended scope:
1. keep resolver logic pure Dart where possible
2. apply queued actions against the existing game engine / rule services
3. update persisted:
   - `match_public/current`
   - affected `private_player_state/{participantId}`
   - action status / resolution metadata
4. keep Firebase transport focused on persistence and watching, not rule ownership

---

## Firebase Reminder

To exercise `firebaseBackend`, run with dart defines such as:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=...
```

If those are missing, the app should still boot in mock mode.
