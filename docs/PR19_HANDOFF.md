# PR19 Handoff — Remote Match Screen-State Loader

## Project

**Anime Deduction Tower**

Continue from the saved PR18 online-foundation state plus this increment.

This chat added a read-only remote match screen-state loader that hydrates a gameplay-ready online match model from persisted Firebase bootstrap/public/private docs and local catalog data.

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR19_HANDOFF.md`
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

### 1. Added explicit gameplay-ready remote screen-state entity
Added:
- `RemoteMatchScreenState`

This read-only entity groups the local participant's hydrated online match view state, including:
- `GameMatch`
- local private state
- local secret trait
- validated category references
- resolved shared character pool
- sync timestamp helpers
- local/remote player convenience getters

### 2. Added pure Dart remote screen-state loader
Added:
- `RemoteMatchScreenStateLoader`

What it does:
- requires a complete `RemoteMatchHandoffSnapshot`
- validates room-code / match-id alignment
- validates local private secret consistency against the bootstrap payload
- validates shared pool alignment between bootstrap/public docs
- resolves trait categories from the validated local catalog
- rebuilds per-player valid-character sets through `TraitFilterEngine`
- rebuilds a gameplay-ready `GameMatch`
- resolves the ordered shared character pool from the local runtime catalog

Important rule preserved:
- official rule ownership still stays in the game engine/domain layer
- this loader is read-only hydration, not online rule resolution

### 3. Added provider wiring for hydrated remote screen state
Added:
- `remoteMatchScreenStateLoaderProvider`
- `remoteMatchScreenStateProvider`

Behavior now is:
- only active for `firebaseBackend`
- watches persisted handoff docs through the existing repository boundary
- loads categories and characters from the local validated catalog/runtime catalog
- emits a gameplay-ready remote screen state only when the handoff snapshot is complete

### 4. Surfaced loader status in the lobby handoff UX
Updated:
- `online_room_handoff_card.dart`

The reconnect-ready Firebase handoff card now also shows a:
- `Gameplay-ready remote screen state` section

That section confirms the loader can hydrate:
- room code
- match id
- local player
- remote player
- local secret tag
- current turn owner
- shared pool size
- whether the local player is up next

This keeps the room-to-match bridge visible in the lobby UI without moving gameplay rules into widgets.

### 5. Added tests
Added:
- `test/features/online_multiplayer/remote_match_screen_state_loader_test.dart`

Covered behavior:
- successful hydration from persisted bootstrap/public/private docs
- failure when local private secret conflicts with the bootstrap payload

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from future online action resolution.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep reconnect/handoff UI read-only with respect to bootstrap assembly and rule resolution.
- Future online action syncing should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added

- `docs/PR19_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/remote_match_screen_state.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_screen_state_loader.dart`
- `test/features/online_multiplayer/remote_match_screen_state_loader_test.dart`

## Files Updated

- `NEXT_CHAT_PROMPT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

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

## **add queued online player action submission + public/private refresh flow**

Recommended scope:
1. persist `OnlinePlayerAction` docs through the datasource/repository boundary
2. add read/watch support for queued action state
3. keep official action resolution outside widgets
4. use the hydrated remote screen-state loader as the read-only base for the future remote match screen

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
