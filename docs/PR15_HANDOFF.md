# PR15 Handoff — First Firebase Online Backend Wiring Saved State

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
- pure Dart remote match bootstrap service
- mock remote join/ready simulation controls
- on-screen remote bootstrap preview summary
- first Firebase-backed room create/join/watch wiring

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR15_HANDOFF.md`
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

This chat completed the next major backend-wiring step:
- **first Firebase-backed room creation/join/watch wiring behind the current datasource boundary**

Delivered and saved:
- Firebase dependencies in `pubspec.yaml`
- runtime Firebase config + initialization guard
- a real Firebase online datasource
- repository/datasource async realtime room methods
- controller support for realtime create/join/watch/ready flow
- online screen button/ready branching for Firebase backend target
- tests covering the mock realtime controller/repository path

This means the online feature now has a real backend-oriented execution path while still preserving the mock preview flow as the default.

---

## New Dependencies Added

Added:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`

`flutter pub get` was run successfully.

---

## New Firebase Config / Init Files

Added:
- `lib/core/config/firebase_runtime_config.dart`
- `lib/app/firebase_app_initializer.dart`

Updated:
- `lib/app/bootstrap.dart`

### Current behavior

The app now attempts Firebase initialization at startup **only if runtime config is provided**.

Required runtime defines for actual Firebase backend use:
- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`

Optional defines supported:
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MEASUREMENT_ID`
- `FIREBASE_IOS_BUNDLE_ID`

Important rule preserved:
- if Firebase config is missing, the app still boots and continues to work in mock preview mode

---

## Online Backend Target Expansion

Updated:
- `lib/features/online_multiplayer/data/config/online_backend_target.dart`

New target added:
- `firebaseBackend`

Current backend targets now are:
- `mockPreview`
- `firebasePreview`
- `firebaseBackend`
- `supabasePreview`

Default remains:
- `mockPreview`

---

## New Firebase Datasource Added

Added:
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`

### Current Firebase datasource behavior

Implemented backend path now includes:
- anonymous sign-in guard
- Firestore room creation
- Firestore room join
- Firestore local-ready updates
- Firestore room watching through room + participants listeners
- domain mapping back into `OnlineRoomSession`

Current Firestore shape used by this first wiring pass:
- `online_rooms/{roomCode}`
- `online_rooms/{roomCode}/participants/{participantId}`

Current room fields include:
- `roomCode`
- `phase`
- `createdAt`
- `updatedAt`
- `hostParticipantId`
- `guestParticipantId`

Current participant fields include:
- `participantId`
- `userId`
- `displayName`
- `role`
- `isReady`
- `connectionState`
- `joinedAt`
- `lastSeenAt`

Important current limitation:
- this chat did **not** wire private trait docs, public match docs, or action queue docs to Firestore yet
- those are still prepared in the architecture/contracts, but not stored remotely yet

---

## Repository / Datasource Contract Expansion

Updated:
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`

New async realtime methods now include:
- `createRoomRealtime(...)`
- `joinRoomRealtime(...)`
- `setLocalParticipantReadyRealtime(...)`
- `watchRoom(...)`

Preview methods were preserved.

Important rule preserved:
- realtime room flow still stays behind repository/datasource boundaries instead of leaking Firebase APIs into presentation code

---

## Mock Datasource / Controller Realtime Support Added

Updated:
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart`

### Saved realtime controller behavior now includes
- `createRoomRealtime()`
- `joinRoomRealtime()`
- `toggleLocalReadyRealtime()`
- internal room watch subscription binding
- automatic session updates from repository room streams
- safe subscription cleanup on mode switch / clear / dispose

Mock datasource now also supports the same async realtime methods so the controller path can be tested without Firebase.

---

## Screen Wiring Updated

Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

### Saved screen behavior now includes
When backend target is:
- `mockPreview` / preview adapters:
  - existing mock create/join flow remains
  - simulation controls remain available

When backend target is:
- `firebaseBackend`:
  - create button uses `createRoomRealtime()`
  - join button uses `joinRoomRealtime()`
  - ready button uses `toggleLocalReadyRealtime()`
  - mock remote simulation controls are hidden

Important note:
- there is still no end-user in-app backend target switcher yet
- target selection still lives at the provider/config layer

---

## Tests Updated

Updated:
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_lobby_controller_test.dart`

New validated behavior includes:
- mock realtime room creation + watch flow
- mock realtime ready updates
- realtime controller create flow
- realtime controller ready updates

All tests passed after the change.

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR15_HANDOFF.md`
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
- Keep preview UI read-only with respect to bootstrap assembly.
- Keep mock remote event simulation clearly separated from actual backend sync behavior.
- Keep Firebase runtime initialization guarded so mock mode still works without platform config.
- Future match syncing should extend the existing datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Validated Commands

Verified at the end of this chat:

```bash
flutter pub get
flutter analyze
flutter test
```

All passed.

---

## Recommended Next Scope

Best next options from this new saved state:

1. **wire Firestore private/player and public/match documents**
   - private player state docs
   - public match bootstrap docs
   - action queue docs
   - keep official rules in the game domain

2. **add Firebase room watch/reconnect UX states**
   - connecting
   - joined
   - reconnecting
   - room missing/closed
   - backend config missing

3. **optionally expose real online setup inputs before deeper backend sync**
   - hints-per-player for online flow
   - replace current preview default constant when appropriate

Recommended immediate next step:
- **wire Firestore private/player and public/match bootstrap documents**

That is now the cleanest follow-up because room creation/join/watch exists, but the backend path still does not persist the remote bootstrap/public/private match artifacts that the preview architecture already models.
