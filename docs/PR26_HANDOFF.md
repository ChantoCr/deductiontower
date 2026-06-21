# PR26 Handoff — Full Saved Context For Tomorrow

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
- `docs/PR26_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read before coding if touching online architecture/tests/UI:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `docs/PR26_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`
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

This chat covered three connected online-multiplayer follow-ups and saved them together.

## 1. Defined official queued-action resolution ownership for now

Chosen policy:
- **host-only client resolution** for the current foundation

Why:
- clearer than unrestricted manual resolution on any client
- smaller next step than immediately moving to backend authority
- reduces accidental dual-resolution attempts from guest clients
- keeps the future migration path explicit

Saved authority options now modeled:
- `hostClient`
- `manualDebugClient`
- `backendService`

Added:
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `lib/features/online_multiplayer/domain/services/online_action_resolution_policy.dart`

Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Behavior now:
- the host client is the temporary official resolver
- guest clients can still inspect the queue feed
- guest clients cannot trigger queued-action resolution
- resolver authority stays explicit in domain/presentation wiring instead of being hidden in widgets

---

## 2. Persisted `resolvedByParticipantId` on resolved action docs

Updated:
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Behavior now:
- resolved online action docs persist the resolver participant id
- both applied and rejected action outcomes keep that metadata
- the queue/debug UI can display which participant resolved a queued action

---

## 3. Persisted `resolvedByUserId` and `resolutionSource` alongside resolver metadata

Updated:
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`
- `lib/features/online_multiplayer/domain/entities/online_room_participant.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`

Behavior now:
- resolved action docs persist:
  - `resolvedByParticipantId`
  - `resolvedByUserId`
  - `resolutionSource`
- `resolutionSource` currently reuses the explicit authority enum and is saved as:
  - `hostClient` for current host-owned resolution
- room participants now preserve `userId` in session entities so the resolver can stamp authoritative user identity
- mock mode now supplies predictable mock user ids for local/remote participants
- controller throws if the authoritative local resolver is missing a user id
- queue/debug UI can display resolver participant, resolver user, and resolution source

---

## Current Saved Online Multiplayer State

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
- participant session entities now preserve `userId`

### Remote contract layer
- bootstrap payload contract
- public match contract
- private player contract
- online player action contract
- resolved action metadata now includes:
  - `resolvedByParticipantId`
  - `resolvedByUserId`
  - `resolutionSource`
  - `resolvedAt`
  - `status`
  - `errorCode`

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
- resolved action docs now trace:
  - who resolved the action as participant
  - who resolved the action as user
  - what authority/source resolved it

### Action-resolution authority layer
- explicit authority enum + policy exists
- current saved authority is **host-only client resolution**
- guest clients can inspect the queue feed but cannot trigger resolution
- future migration path remains explicit for backend authority

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep queued action submission/watch transport-focused.
- Keep action resolution pure Dart where possible.
- Keep authority and resolver metadata explicit instead of hiding them in ad-hoc UI state.
- Keep Firebase persistence focused on reading/writing explicit docs plus concurrency guards.
- Keep widgets thin: they should call providers/controllers, not build backend maps or rule resolution.
- Do **not** move official rule ownership into Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Tests Added / Updated In This Chat

Added earlier in this online action-resolution area and still relevant:
- `test/features/online_multiplayer/online_action_resolution_policy_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

Updated in this chat:
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

Coverage now includes:
- host-only authority gating
- guest-side resolution rejection before repository access
- `resolvedByParticipantId` persistence
- `resolvedByUserId` persistence
- `resolutionSource` persistence
- pure Dart resolver stamping for applied and rejected actions
- Firestore action-resolution doc output including resolver metadata

---

## Files Added Across This Chat Flow

- `docs/PR24_HANDOFF.md`
- `docs/PR25_HANDOFF.md`
- `docs/PR26_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `lib/features/online_multiplayer/domain/services/online_action_resolution_policy.dart`
- `test/features/online_multiplayer/online_action_resolution_policy_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

## Files Updated Across This Chat Flow

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
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
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

## Recommended Prompt For Tomorrow

Use this in a new chat tomorrow:

```md
Start from:
- README.md
- AGENTS.md
- docs/PR26_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved PR26 state.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/ROADMAP.md
- docs/DATA_MODEL.md
- docs/PR26_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current project state summary:
- Flutter + Flame deduction game
- no-lives local rules
- shared character pool gameplay already wired
- protected local multiplayer secrecy already implemented
- premium setup/selection/handoff/match/result UI already in place
- runtime catalog loaded from assets/data/characters.json
- runtime catalog currently contains 1276 characters
- tag catalog currently contains 40 tags
- secret-tag category catalog currently contains 40 categories
- import preview / review / approval / curated promotion tooling still exists and remains valid
- AI mode is already saved with easy/standard/hard behavior and public reasoning notes
- online multiplayer foundation is now saved through room, bootstrap, handoff, remote screen-state hydration, queued action transport, a pure Dart queued-action resolver/application layer, explicit host-only action-resolution ownership for now, and richer persisted resolver metadata on action docs

Current online multiplayer saved state includes:
- mock preview room create/join/readiness flow
- Firebase-backed realtime room create/join/watch/readiness flow
- explicit remote contracts for:
  - RemoteMatchBootstrapPayload
  - RemoteMatchPublicState
  - RemotePlayerPrivateState
  - OnlinePlayerAction
- pure Dart remote bootstrap service
- deterministic preview seed service
- Firestore bootstrap persistence for:
  - online_rooms/{roomCode}/match_bootstrap/current
  - online_rooms/{roomCode}/match_public/current
  - online_rooms/{roomCode}/private_player_state/{participantId}
- Firestore read/watch support for persisted bootstrap/public/private docs
- reconnect-aware room-to-match handoff UX in the online lobby screen
- read-only remote match screen-state hydration from persisted docs plus local catalog data
- queued online player action submission + live queue watch flow through the datasource/repository boundary
- pure Dart remote action resolver/application flow that:
  - reads persisted bootstrap/public/private contracts
  - applies queued actions through the existing game engine and hint engine
  - persists updated public/private/action docs back through the repository boundary
- Firebase transaction guards for action-resolution persistence based on current match version and pending action status
- explicit action-resolution authority policy with current default set to host-only client ownership
- gated resolver controls so non-authoritative clients can inspect the queue but not resolve it
- resolved action docs now persist resolver metadata through:
  - resolvedByParticipantId
  - resolvedByUserId
  - resolutionSource
- room participants now preserve userId inside session entities
- mock mode still preserved when Firebase config is missing

Important rules:
- keep game logic pure Dart
- keep online room/lobby/backend transport separate from official match-rule resolution
- keep bootstrap/public/private/action contracts explicit
- keep read-only remote hydration separate from action resolution
- keep queued action submission/watch transport-focused
- keep action resolution pure Dart where possible
- keep authority and resolver metadata explicit instead of scattering them across widgets
- keep Firebase transport focused on persistence, watching, and concurrency guards rather than official rule ownership
- keep Firebase runtime init guarded so mock mode still works without config
- keep widgets thin; use providers/controllers instead of backend maps in UI
- keep Flame presentation-only
- add or update tests when logic changes
- if JSON assets change while the app is already running, remind that a full app restart is needed

Best next scope:
1. add a small public online resolution summary/timeline layer or start backend authority migration
2. consider public-facing fields such as:
   - short resolution label
   - resolved action type/value summary
   - result text suitable for future remote match UI
3. if backend authority is next, keep the current action metadata fields unchanged so migration stays smooth
4. consider whether action docs should eventually store a compact canonical public event payload for future online result/timeline views
5. keep Firebase transport focused on persistence/guards rather than in-client rule ownership
```

---

## Best Next Step For Tomorrow

The strongest next step is:

## **add a small public online resolution summary/timeline layer or start backend authority migration**

Recommended scope:
1. consider public-facing online resolution summary fields such as:
   - short resolution label
   - resolved action type/value summary
   - result text suitable for future remote match UI
2. if backend authority is next, keep the current action metadata fields unchanged so server migration stays smooth
3. consider whether action docs should eventually store a compact canonical public event payload for future online result/timeline views
4. keep Firebase transport focused on persistence/guards rather than in-client rule ownership
