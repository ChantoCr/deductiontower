# PR32 Handoff — Dedicated Backend-Authority Service Path

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR32_HANDOFF.md`
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
- resolved action docs preserve:
  - `resolvedByParticipantId`
  - `resolvedByUserId`
  - `resolutionSource`
- room participants preserve `userId`
- canonical public online event docs persist for remote timeline/result UI

---

## What Changed In PR32

## 1. Replaced the widget-driven backend bridge with a dedicated backend-authority service path

Added:
- `lib/features/online_multiplayer/data/services/remote_match_backend_authority_service.dart`
- `test/features/online_multiplayer/remote_match_backend_authority_service_test.dart`

Behavior now:
- backend-authority resolution is no longer triggered from `online_room_handoff_card.dart`
- Firebase backend mode can enable a dedicated data-layer backend-authority service
- that service reads the oldest pending queued action
- it loads persisted bootstrap/public/private docs
- it runs the same pure Dart `RemoteMatchActionResolver`
- it persists the same public/private/action updates and canonical public event docs
- it preserves the same resolver metadata:
  - `resolvedByParticipantId = backend_authority`
  - `resolvedByUserId = backend_authority_service`
  - `resolutionSource = backendService`

Important preserved rule:
- online transport still stays separate from official match-rule resolution
- the official backend-mode path no longer depends on a widget post-frame callback or a presentation controller bridge

## 2. Firebase backend datasource now owns backend-mode queue draining

Updated:
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`

Behavior now:
- provider wiring passes backend-authority enablement into the Firebase backend datasource
- action submission now schedules backend-authority draining from the datasource layer
- watched action snapshots also schedule backend-authority draining when pending actions exist
- datasource-level room locks avoid duplicate local drain attempts inside one runtime
- ignorable concurrency conflicts are tolerated so the queue can retry cleanly

Important nuance:
- this is now a dedicated authority service path inside the data layer
- it is cleaner than the old widget/controller bridge
- it is still **not yet** a real Cloud Function / server runtime with admin-side ownership

## 3. Simplified presentation-side backend resolution behavior

Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

Behavior now:
- `OnlineActionResolutionController` only handles local-authority resolution paths
- backend authority still blocks local manual resolution
- queue UI now describes dedicated backend-authority ownership instead of migration-bridge language
- the handoff widget no longer auto-resolves actions itself in backend mode

## 4. Docs updated for the saved architecture state

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `docs/PR32_HANDOFF.md`

---

## Current Authority / Resolution Model After PR32

### Default working path
- authority: `hostClient`
- host device can resolve queued actions
- guests cannot manually resolve

### Saved backend-owned path
- authority: `backendService`
- local manual resolution is disabled
- widgets only inspect queue/public-event state
- Firebase backend datasource owns automatic queue draining through a dedicated backend-authority service
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

## Main Files Added In This Chat

- `docs/PR32_HANDOFF.md`
- `lib/features/online_multiplayer/data/services/remote_match_backend_authority_service.dart`
- `test/features/online_multiplayer/remote_match_backend_authority_service_test.dart`

## Main Files Updated In This Chat

- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart`
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

---

## Validation In This Chat

Verified in this chat:

```bash
flutter analyze
flutter test
```

Final saved state:
- `flutter analyze` ✅
- `flutter test` ✅

---

## Best Next Step

Best next step from PR32:
1. move the dedicated backend-authority service into a **true server-owned runtime** such as a Cloud Function or equivalent backend worker
2. preserve these exact metadata fields during that migration:
   - `resolvedByParticipantId`
   - `resolvedByUserId`
   - `resolutionSource`
3. preserve the canonical public event shape unless intentionally versioned
4. keep the current pure Dart resolver as the official rule engine, even if the execution host moves from app runtime to server runtime
5. optionally harden backend-mode concurrency with an explicit resolution lease / claim document if multi-client backend triggering becomes noisy before server migration

---

## Copy-Paste Prompt For Tomorrow

```md
Start from:
- README.md
- AGENTS.md
- docs/PR32_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from saved PR32 state.

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
- Firebase backend mode now has a dedicated backend-authority service path
  - datasource-owned queue draining
  - preserved `backendService` metadata
  - preserved canonical public event persistence
- resolved action docs preserve:
  - resolvedByParticipantId
  - resolvedByUserId
  - resolutionSource
- canonical public online event docs persist for future remote timeline/result UI
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
- move the dedicated backend-authority service into a true Cloud Function / server-owned runtime while preserving current explicit action metadata and canonical public event shape
- or add an explicit backend resolution lease/claim flow before that server migration
```
