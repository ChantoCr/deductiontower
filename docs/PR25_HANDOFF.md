# PR25 Handoff — Persisted Resolver User + Source Metadata

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
- explicit temporary host-only online action-resolution ownership
- persisted resolver metadata on resolved action docs

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR25_HANDOFF.md`
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

## What Was Done In This Chat

This chat completed the next online metadata step:

## **persist `resolvedByUserId` and `resolutionSource` alongside existing resolver metadata**

### 1. Extended the online action contract again
Updated:
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`

New persisted fields on resolved actions:
- `resolvedByUserId`
- `resolutionSource`

Current action metadata set now includes:
- `resolvedByParticipantId`
- `resolvedByUserId`
- `resolutionSource`
- `resolvedAt`
- `status`
- `errorCode`

### 2. Reused the explicit authority enum as the resolution-source contract
Updated behavior:
- `resolutionSource` uses `OnlineActionResolutionAuthority?`
- current saved source value during live host-owned resolution is:
  - `OnlineActionResolutionAuthority.hostClient`

This keeps authority policy and persisted source naming aligned for now.

### 3. Added resolver user identity to room participants
Updated:
- `lib/features/online_multiplayer/domain/entities/online_room_participant.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`

Behavior now:
- `OnlineRoomParticipant` can carry `userId`
- Firebase-mapped room sessions preserve participant user ids
- mock sessions now assign predictable mock user ids for local/remote participants

### 4. Stamped both new metadata fields during pure Dart action resolution
Updated:
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`

Behavior now:
- both applied and rejected action results store:
  - resolver participant id
  - resolver user id
  - resolution source

Important rule preserved:
- metadata is attached in pure Dart resolution, not inferred later by Firebase transport glue

### 5. Passed resolver user id + source from the controller layer
Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`

Behavior now:
- controller passes:
  - `session.localParticipantId`
  - `session.localParticipant.userId`
  - current authority enum as `resolutionSource`
- controller throws if the authoritative resolver is missing a local user id

### 6. Surfaced the new metadata in debug queue UI
Updated:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Queue entries can now show:
- submitting participant
- expected version
- resolved-by participant
- resolved-by user
- resolution source label

### 7. Added / updated tests
Updated:
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

Coverage now includes:
- model parsing/serialization for `resolvedByUserId`
- model parsing/serialization for `resolutionSource`
- pure Dart resolver stamping for both fields
- Firestore bundle output for both fields

### 8. Updated docs
Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

Created:
- `docs/PR25_HANDOFF.md`

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
- room participants now preserve `userId` in session entities

### Remote contract layer
- bootstrap payload contract
- public match contract
- private player contract
- online player action contract
- resolved action metadata now includes:
  - `resolvedByParticipantId`
  - `resolvedByUserId`
  - `resolutionSource`

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
- resolved action docs now record:
  - who resolved them as participant
  - who resolved them as user
  - what source resolved them
- Firebase transaction persistence guards version/status races

### Action-resolution authority layer
- explicit authority enum + policy exists
- current saved authority is **host-only client resolution**
- guest clients can still inspect the queue feed but cannot trigger resolution
- persisted resolution source currently aligns with that authority choice

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep queued action submission/watch transport-focused.
- Keep action resolution pure Dart where possible.
- Keep Firebase persistence focused on reading/writing explicit docs plus concurrency guards.
- Keep authority and resolver metadata explicit instead of hiding them in ad-hoc UI state.
- Keep widgets thin: they should call providers/controllers, not build backend maps or rule resolution.
- Do **not** move official rule ownership into Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Updated In This Chat

- `README.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`
- `lib/features/online_multiplayer/domain/entities/online_room_participant.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

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

## **add a small public online resolution summary/timeline layer or start backend authority migration**

Recommended scope:
1. consider adding public-facing online resolution summary fields such as:
   - short resolution label
   - resolved action type/value summary
   - result text suitable for future remote match UI
2. if backend authority is next, keep the current action metadata fields unchanged so server migration stays smooth
3. consider whether action docs should eventually store a compact canonical public event payload for future online result/timeline views
4. keep Firebase transport focused on persistence/guards rather than in-client rule ownership

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
