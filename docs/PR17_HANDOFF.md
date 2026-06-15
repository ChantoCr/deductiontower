# PR17 Handoff — Firestore Bootstrap Document Persistence

## Project

**Anime Deduction Tower**

Continue from the saved PR16 online-foundation state plus this increment.

This chat wired the first Firestore bootstrap artifact persistence for the real Firebase backend path.

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR17_HANDOFF.md`
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

### 1. Wired Firebase bootstrap document persistence
The real Firebase datasource now persists initial remote match artifacts after a room becomes:
- `readyToSync`
- fully ready on both participants

Persisted Firestore docs now include:
- `online_rooms/{roomCode}/match_bootstrap/current`
- `online_rooms/{roomCode}/match_public/current`
- `online_rooms/{roomCode}/private_player_state/{participantId}`

### 2. Kept bootstrap assembly in pure Dart services
The Firebase datasource now:
- loads validated categories and runtime characters through injected loaders
- resolves deterministic seed assignments through `RemoteMatchPreviewSeedService`
- injects real Firebase `userId` values into `RemotePlayerBootstrapSeed`
- builds the official initial payload/public/private state through `RemoteMatchBootstrapService`
- uses a deterministic Firebase match id: `match_{roomCode}`
- reuses the room creation timestamp as the bootstrap timestamp so repeated writes stay stable

This keeps official match-rule resolution out of Firebase transport code.

### 3. Added explicit Firestore bundle mapping helper
Added:
- `lib/features/online_multiplayer/data/services/remote_match_firestore_bundle_builder.dart`

This pure helper maps `RemoteMatchBootstrapResult` into explicit Firestore-ready documents for:
- room patch metadata
- bootstrap payload doc
- public match doc
- private per-player docs

### 4. Extended seed building for Firebase-backed private state
`RemoteMatchPreviewSeedService` now accepts optional participant user-id overrides.

That means:
- preview mode still falls back to `preview_user_{participantId}`
- Firebase backend can now persist real `userId` values into `RemotePlayerPrivateState`

### 5. Provider wiring updated
`onlineRoomDataSourceProvider` now injects Firebase datasource dependencies needed for bootstrap persistence:
- validated category loader
- runtime character loader
- bootstrap service
- preview-seed service
- Firestore bundle builder
- hints-per-player config

Mock mode still works because:
- the default backend target is still `mockPreview`
- Firebase initialization is still only attempted on real Firebase backend use

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep Firebase runtime initialization guarded so mock mode still works without config.
- Keep deterministic/idempotent bootstrap writes until full live sync and conflict handling are added.
- Keep preview/mock secret assignment behavior separate from later real online secret-selection UX.
- Future online action syncing should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added

- `lib/features/online_multiplayer/data/services/remote_match_firestore_bundle_builder.dart`
- `docs/PR17_HANDOFF.md`

## Files Updated

- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `test/features/online_multiplayer/remote_match_preview_seed_service_test.dart`

## Tests Added

- `test/features/online_multiplayer/remote_match_firestore_bundle_builder_test.dart`

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

## **add Firebase watch/reconnect UX around bootstrap state and room-to-match handoff**

Recommended scope:
1. detect whether a room already has `match_public/current`
2. surface lobby state for:
   - bootstrap pending
   - bootstrap ready
   - reconnecting to existing remote match bootstrap
3. add repository/datasource reads for bootstrap/public/private docs
4. keep official rule resolution in pure Dart and avoid pushing logic into widgets
5. keep mock preview mode working unchanged

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
