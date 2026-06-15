# PR18 Handoff — Firebase Bootstrap Read/Watch + Reconnect Handoff UX

## Project

**Anime Deduction Tower**

Continue from the saved PR17 online-foundation state plus this increment.

This chat added the read/watch side for persisted Firebase bootstrap documents and surfaced reconnect-aware room-to-match handoff UX in the online lobby screen.

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR18_HANDOFF.md`
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

### 1. Added explicit handoff snapshot contract
Added:
- `RemoteMatchHandoffSnapshot`

This transport-focused entity groups the persisted room-to-match handoff artifacts for the local participant:
- optional bootstrap payload
- optional public match state
- optional local private player state
- readiness helpers like `isComplete`

### 2. Extended datasource/repository boundaries for persisted handoff watching
Added a new explicit stream method across the online boundary:
- `watchMatchHandoff({ roomCode, participantId })`

Updated:
- `OnlineRoomDataSource`
- `OnlineRoomRepository`
- `OnlineRoomRepositoryImpl`
- mock / Firebase-preview / Supabase-preview / Firebase backend datasource implementations

Behavior now is:
- preview/mock datasources return `null` handoff snapshots
- Firebase backend watches:
  - `match_bootstrap/current`
  - `match_public/current`
  - `private_player_state/{participantId}`

### 3. Wired Firebase read/watch side for persisted bootstrap docs
`FirebaseOnlineRoomDataSource` now watches the three persisted document locations and maps them back into explicit contract models via:
- `RemoteMatchBootstrapPayloadModel`
- `RemoteMatchPublicStateModel`
- `RemotePlayerPrivateStateModel`

Important implementation detail:
- the stream waits until each watched doc path has delivered an initial snapshot before emitting a combined handoff state
- when no persisted docs exist yet, the combined result is `null`
- when some docs exist but not all, the combined result is partial and visible to the UI

### 4. Added provider-side handoff watching
Added:
- `remoteMatchHandoffProvider`

It:
- activates only for `firebaseBackend`
- reads the active room session from `OnlineLobbyController`
- watches the persisted handoff bundle for the local participant

### 5. Added reconnect-aware room-to-match handoff UX
Added:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Updated:
- `online_match_screen.dart`

Current UI behavior:
- preview/mock targets still show the existing bootstrap preview card
- Firebase backend now shows a live handoff card with explicit states:
  - no active room
  - waiting for lobby readiness
  - bootstrap pending
  - partial handoff docs detected
  - reconnect ready
- reconnect-ready UI reads persisted bootstrap/public/private docs instead of rebuilding the bundle in presentation code
- private state remains masked enough to avoid exposing the raw secret trait id in the lobby UI

### 6. Added tests
Updated/added:
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
  - added `RemoteMatchHandoffSnapshot` readiness test
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
  - added mock handoff watch behavior test

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep reconnect/handoff UI read-only with respect to match bootstrap assembly.
- Keep official match startup/rule logic inside pure Dart services and the game domain, not widgets.
- Future online action syncing should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added

- `docs/PR18_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

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
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`

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

## **bridge persisted remote bootstrap/public/private docs into an actual remote match screen state loader**

Recommended scope:
1. add a read-only remote match loader that converts persisted contracts into a gameplay-ready screen state
2. keep official rule resolution in the existing game engine
3. avoid introducing online action resolution directly in widgets
4. after that, add queued online player action submission/resolution flow

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
