# PR16 Handoff — Full Chat Save: Online Foundation → Firebase Room Wiring

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- polished mock player-vs-AI mode
- online multiplayer foundation preview
- backend-ready datasource/repository abstraction
- remote bootstrap/public/private/action contracts
- bootstrap preview UI
- first Firebase room backend wiring

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR16_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read before coding if touching online architecture/tests/UI:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `docs/EXTERNAL_ANIME_DATA.md`
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
- if JSON assets change while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

---

## What Was Done In This Chat

This chat continued from the saved PR9/PR10-era online foundation and completed a large online-focused sequence.

### 1. Read and aligned on project guidance
Read and used:
- `README.md`
- `AGENTS.md`
- `docs/PR9_HANDOFF.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `NEXT_CHAT_PROMPT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- relevant skills docs

### 2. Added backend-ready online datasource/repository abstraction
Saved earlier in this chat:
- backend target config
- datasource interface
- mock / Firebase-preview / Supabase-preview adapters
- repository implementation on top of datasource
- provider-based backend target resolution
- backend-boundary UI card

Core files involved:
- `lib/features/online_multiplayer/data/config/online_backend_target.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

### 3. Added explicit remote online match contracts
Saved earlier in this chat:
- `RemoteMatchBootstrapPayload`
- `RemoteMatchPublicState`
- `RemoteMatchPublicPlayerState`
- `RemotePlayerPrivateState`
- `OnlinePlayerAction`
- `OnlinePlayerActionStatus`
- Firestore/JSON-friendly data models for each

Core files added:
- `lib/core/enums/online_player_action_status.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_state.dart`
- `lib/features/online_multiplayer/domain/entities/remote_player_private_state.dart`
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/remote_match_bootstrap_payload_model.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_player_state_model.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_state_model.dart`
- `lib/features/online_multiplayer/data/models/remote_player_private_state_model.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`

### 4. Added pure Dart remote bootstrap service
Saved earlier in this chat:
- `RemotePlayerBootstrapSeed`
- `RemoteMatchBootstrapResult`
- `RemoteMatchBootstrapService`

What it does:
- validates a ready room
- validates secret seed input
- resolves trait categories
- builds shared character pool with `TraitFilterEngine`
- creates initial match state using `GameEngine.createMatch(...)`
- maps that into:
  - `RemoteMatchBootstrapPayload`
  - initial `RemoteMatchPublicState`
  - initial `RemotePlayerPrivateState` list

Core files added:
- `lib/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart`

### 5. Added mock remote lobby event simulation
Saved earlier in this chat:
- host preview can simulate remote guest join
- remote participant ready/not-ready can be simulated
- controller and UI expose those preview-only controls
- room phases still resolve cleanly through:
  - `waitingForOpponent`
  - `waitingForReady`
  - `readyToSync`

Important saved rule:
- mock remote simulation is clearly separate from real backend sync

### 6. Added bootstrap preview summary UI
Saved earlier in this chat:
- deterministic preview seed selection service
- provider-driven bootstrap preview assembly
- on-screen preview card for:
  - bootstrap payload summary
  - initial public match summary
  - masked private-state summary

Important saved rule:
- preview card **does not reveal actual secret trait ids/labels**

Files added:
- `lib/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_bootstrap_preview_card.dart`

### 7. Added first real Firebase backend wiring for rooms
This is the final state saved in this chat.

#### Dependencies added
In `pubspec.yaml`:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`

#### Firebase runtime/init support
Added:
- `lib/core/config/firebase_runtime_config.dart`
- `lib/app/firebase_app_initializer.dart`

Updated:
- `lib/app/bootstrap.dart`

Current behavior:
- app attempts Firebase initialization only if runtime config is present
- app still boots in mock mode if config is missing

Required runtime defines for real Firebase backend use:
- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`

Optional runtime defines:
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MEASUREMENT_ID`
- `FIREBASE_IOS_BUNDLE_ID`

#### New backend target added
`OnlineBackendTarget` now includes:
- `mockPreview`
- `firebasePreview`
- `firebaseBackend`
- `supabasePreview`

Default is still:
- `mockPreview`

#### Real Firebase datasource added
Added:
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`

Implemented backend path currently covers:
- anonymous sign-in guard
- Firestore room creation
- Firestore room join
- Firestore room watch
- Firestore local-ready updates
- room/participant mapping back into `OnlineRoomSession`

Current Firestore collections currently used by this first backend step:
- `online_rooms/{roomCode}`
- `online_rooms/{roomCode}/participants/{participantId}`

Current room doc fields include:
- `roomCode`
- `phase`
- `createdAt`
- `updatedAt`
- `hostParticipantId`
- `guestParticipantId`

Current participant doc fields include:
- `participantId`
- `userId`
- `displayName`
- `role`
- `isReady`
- `connectionState`
- `joinedAt`
- `lastSeenAt`

Important limitation still present:
- this backend path does **not** yet persist:
  - `RemotePlayerPrivateState`
  - `RemoteMatchBootstrapPayload`
  - initial `RemoteMatchPublicState`
  - action queue docs

#### Async realtime repository/datasource methods added
Contracts now include:
- `createRoomRealtime(...)`
- `joinRoomRealtime(...)`
- `setLocalParticipantReadyRealtime(...)`
- `watchRoom(...)`

#### Controller realtime flow added
`OnlineLobbyController` now supports:
- `createRoomRealtime()`
- `joinRoomRealtime()`
- `toggleLocalReadyRealtime()`
- internal room watch subscription binding
- cleanup on mode switch / clear / dispose

#### Screen/backend branching added
In the online foundation screen:
- `firebaseBackend` uses Firebase create/join/ready flow
- preview targets keep old mock behavior
- mock simulation controls are hidden while using `firebaseBackend`

Important note:
- there is still **no in-app backend target switcher**
- backend target selection still lives in providers/config

#### Mock realtime support added for tests
The mock datasource also supports:
- mock realtime room creation
- mock realtime room watch stream
- mock realtime local-ready updates

This lets controller/repository realtime paths be tested without Firebase.

---

## Current Online State After This Chat

The online feature now has three major layers saved:

### Preview layer
- mock room create/join
- host/guest room preview UX
- ready state preview UX
- remote guest join simulation
- remote ready simulation
- bootstrap preview summary

### Domain contracts layer
- remote bootstrap payload
- remote public match state
- remote private player state
- online player action model
- bootstrap service
- deterministic preview seed service

### First backend layer
- Firebase runtime config/init guard
- Firebase room create/join/watch
- Firebase local-ready updates
- provider/backend target branch to activate Firebase path

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
- Keep preview UI read-only with respect to bootstrap assembly.
- Keep mock remote event simulation clearly separated from actual backend sync behavior.
- Keep Firebase runtime initialization guarded so mock mode still works without platform config.
- Future match syncing should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Validated Commands In This Chat

Verified during this chat:

```bash
flutter pub get
flutter analyze
flutter test
```

All passed at the final saved state.

---

## Best Next Step Saved For Tomorrow

The cleanest next step is:

## **wire Firestore private/player and public/match bootstrap documents**

That means persisting:
- `RemotePlayerPrivateState`
- `RemoteMatchBootstrapPayload`
- initial `RemoteMatchPublicState`

### Recommended scope for that next step
1. extend the Firebase datasource to write bootstrap artifacts once a room reaches `readyToSync`
2. keep bootstrap assembly in `RemoteMatchBootstrapService`
3. write Firestore docs for:
   - `online_rooms/{roomCode}/private_player_state/{participantId}`
   - `online_rooms/{roomCode}/match_public/current`
   - a room-level bootstrap payload doc or equivalent bootstrap section
4. do **not** duplicate official rules in Firebase code
5. add tests for the non-Firebase mappable/service logic where possible
6. update docs/hand-off again after that work

---

## Practical Firebase Reminder For Tomorrow

To actually exercise `firebaseBackend`, the run command will need dart defines such as:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=...
```

If those are missing, mock mode should still work and the app should still boot.
