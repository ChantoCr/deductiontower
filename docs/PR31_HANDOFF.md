# PR31 Handoff — Full Saved Context From This Chat

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR31_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read before coding if touching online architecture/tests/UI:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `skills/flutter-architecture/SKILL.md`
- `skills/testing/SKILL.md`
- `skills/ui-ux-mobile/SKILL.md`

---

## Current Saved Project State

### Core game / local flow
- local no-lives gameplay is working
- protected one-device multiplayer secrecy is working
- shared character pool gameplay is working
- private hint flow is working
- result flow is working

### AI
- AI mode is working
- easy / standard / hard behavior is already saved
- AI public reasoning notes and AI result analytics already exist

### Runtime data
- runtime catalog: **1276 characters**
- tags: **40**
- categories: **40**

Important runtime note:
- JSON assets were **not changed** in this chat
- if JSON assets change later while the app is already running, do a **full app restart**

### Online multiplayer foundation
Saved online layers now include:
- mock + Firebase-backed room create/join/watch/readiness
- explicit remote contracts for:
  - `RemoteMatchBootstrapPayload`
  - `RemoteMatchPublicState`
  - `RemotePlayerPrivateState`
  - `OnlinePlayerAction`
- Firestore bootstrap/public/private persistence + watch
- reconnect-aware handoff UX
- read-only remote screen-state hydration
- queued action submission/watch flow
- pure Dart queued-action resolver/application flow
- current default official resolver policy still set to **host client**
- non-authoritative clients can inspect queue state but cannot manually resolve
- resolved action docs preserve:
  - `resolvedByParticipantId`
  - `resolvedByUserId`
  - `resolutionSource`
- room participants preserve `userId`

---

## Everything Added / Changed In This Chat

This chat covered four connected online follow-ups.

## 1. Added a small read-only public online resolution timeline preview

Added:
- `lib/features/online_multiplayer/domain/entities/remote_match_action_timeline_entry.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_timeline_builder.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_public_action_timeline_card.dart`
- `test/features/online_multiplayer/remote_match_action_timeline_builder_test.dart`

Behavior added:
- derived public-safe timeline entries from queued action docs + local catalog labels
- showed short label, action summary, result summary, participant label, submitted label, timestamp, and resolver source
- kept private hint text out of the timeline

Important note:
- this was a derived preview layer only
- it did **not** own canonical public event persistence yet

## 2. Promoted that timeline into a canonical public online event contract

Added:
- `lib/features/online_multiplayer/domain/entities/remote_match_public_event.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_event_model.dart`

Updated architecture:
- `RemoteMatchActionResolution` now carries `publicEvent`
- pure Dart `RemoteMatchActionResolver` now builds canonical public event payloads during official resolution
- Firestore resolution persistence now also writes:
  - `match_public_events/{eventId}`
- repository/datasource layers now watch canonical public event docs explicitly
- UI timeline now reads persisted public event docs instead of deriving text in widgets

Important preserved rule:
- canonical public events must not leak private hint text or hidden secrets

## 3. Added backend-authority migration wiring

Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- provider/controller tests

Behavior added:
- current default still remains `hostClient`
- provider-level migration switch now exists through:
  - `onlineUseBackendResolutionAuthorityProvider`
- when enabled together with `firebaseBackend`, authority becomes:
  - `backendService`
- local manual resolution is blocked in backend mode before repository reads
- queue UI explains backend-owned resolution mode

Important preserved rule:
- existing explicit action metadata fields remained unchanged for migration safety

## 4. Added a backend-authority bridge auto-resolution path

Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

New behavior:
- Firebase backend mode can now auto-attempt resolution while authority is `backendService`
- the bridge resolves the oldest pending action in the background
- it still uses the same pure Dart official resolver
- it persists the same public/private/action updates + canonical public event docs
- it stamps backend-style metadata using:
  - `resolvedByParticipantId = backend_authority`
  - `resolvedByUserId = backend_authority_service`
  - `resolutionSource = backendService`

Important nuance:
- this is still a **bridge step** inside the current app/runtime architecture
- it is **not** yet a true Cloud Function or dedicated backend-owned resolver

---

## Current Authority / Resolution Model After This Chat

### Default working path
- authority: `hostClient`
- host device can resolve queued actions
- guests cannot manually resolve

### Migration path now saved
- authority: `backendService`
- local manual resolution is disabled
- UI waits for backend ownership
- bridge auto-resolution can run in Firebase backend mode
- same metadata + canonical public event shape are preserved

---

## Current Important Rules To Preserve

- keep game logic pure Dart
- keep online transport separate from official match-rule resolution
- keep bootstrap/public/private/action contracts explicit
- keep read-only hydration separate from action resolution
- keep queued action transport separate from resolution
- keep action resolution pure Dart where possible
- keep authority/resolver metadata explicit
- keep Firebase focused on persistence/watch/concurrency guards, not rule ownership
- keep widgets thin
- keep Flame presentation-only
- add/update tests when logic changes
- if JSON assets change, remind that a full app restart is needed

---

## Files Added In This Chat

- `docs/PR27_HANDOFF.md`
- `docs/PR28_HANDOFF.md`
- `docs/PR29_HANDOFF.md`
- `docs/PR30_HANDOFF.md`
- `docs/PR31_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_timeline_entry.dart`
- `lib/features/online_multiplayer/domain/entities/remote_match_public_event.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_timeline_builder.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_event_model.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_public_action_timeline_card.dart`
- `test/features/online_multiplayer/remote_match_action_timeline_builder_test.dart`

## Main Files Updated In This Chat

- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `lib/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/services/remote_match_firestore_action_resolution_bundle_builder.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_multiplayer_providers_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

---

## Validation In This Chat

Verified repeatedly during this chat:

```bash
flutter analyze
flutter test
```

Final saved state:
- `flutter analyze` ✅
- `flutter test` ✅

---

## Best Next Step Tomorrow

Best next step from PR31:
1. replace the current backend-authority bridge with a **true backend-owned resolver path**
2. preserve these exact metadata fields during migration:
   - `resolvedByParticipantId`
   - `resolvedByUserId`
   - `resolutionSource`
3. keep the canonical public event contract stable unless intentionally versioned
4. if moving to Cloud Functions or another server authority, move ownership into a dedicated authority layer instead of leaving official ownership in widget-driven app runtime flows

---

## Copy-Paste Prompt For Tomorrow

```md
Start from:
- README.md
- AGENTS.md
- docs/PR31_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from saved PR31 state.

Before coding, read:
- docs/ARCHITECTURE.md
- docs/ROADMAP.md
- docs/DATA_MODEL.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current saved state:
- local no-lives gameplay is working
- protected one-device multiplayer secrecy is working
- AI mode is working with easy/standard/hard behavior
- online room foundation is working with mock + Firebase-backed room create/join/watch/readiness
- explicit remote contracts exist for bootstrap/public/private/action
- Firestore bootstrap docs are persisted and watched
- reconnect-aware handoff UX exists
- read-only remote screen-state hydration exists
- queued online player action submission/watch exists
- pure Dart queued-action resolver/application flow exists
- current official online action-resolution owner is still the host client by default
- Firebase backend mode now also has a backend-authority bridge flow
  - auto-resolves pending actions with `backendService` metadata
  - preserves current explicit action metadata
  - preserves canonical public event persistence
- resolved action docs preserve:
  - resolvedByParticipantId
  - resolvedByUserId
  - resolutionSource
- canonical public online event docs now persist for future remote timeline/result UI
- room participants preserve userId
- runtime catalog: 1276 characters
- tags: 40
- categories: 40

Important rules:
- keep game logic pure Dart
- keep online transport separate from official match-rule resolution
- keep bootstrap/public/private/action contracts explicit
- keep read-only hydration separate from action resolution
- keep queued action transport separate from resolution
- keep action resolution pure Dart where possible
- keep authority/resolver metadata explicit
- keep Firebase focused on persistence/watch/concurrency guards, not rule ownership
- keep widgets thin
- keep Flame presentation-only
- add/update tests when logic changes
- if JSON assets change, remind that a full app restart is needed

Best next step:
- replace the current backend-authority bridge with a true backend-owned resolver path while preserving current explicit action metadata and canonical public event shape
- or enrich the canonical public event contract for broader remote match/result UI coverage
```
