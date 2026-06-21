# PR23 Handoff — Host-Only Online Action-Resolution Authority

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

---

## Read First In The Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR23_HANDOFF.md`
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

This chat completed the next online authority step:

## **defined official online action-resolution ownership for now**

### Chosen policy
For the current saved foundation, **the host client is the temporary official resolver for queued online actions**.

Why this was chosen now:
- clearer than leaving action resolution as an unrestricted manual trigger on any client
- smaller coherent step than introducing backend authority immediately
- reduces accidental dual-resolution attempts from guest devices
- keeps future migration paths explicit:
  - `manualDebugClient`
  - `backendService` / Cloud Function authority

---

## What Was Added / Updated

### 1. Added explicit resolution-authority modeling
Added:
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `lib/features/online_multiplayer/domain/services/online_action_resolution_policy.dart`

What they do:
- model the current and future authority choices:
  - `hostClient`
  - `manualDebugClient`
  - `backendService`
- centralize whether the local client may resolve queued actions for the active room session
- provide readable authority copy for the UI

Current saved default:
- `hostClient`

### 2. Gated the resolution controller with the authority policy
Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`

Behavior now:
- resolution methods require the current room session
- authority is checked **before** repository reads or persistence
- guest clients are rejected when the authority policy is `hostClient`

Important rule preserved:
- widgets still do not own rule authority
- authority checks remain explicit and testable

### 3. Added authority providers
Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`

Added provider state for:
- current resolution authority
- authority policy service
- whether the local client may resolve queued actions right now

Current saved default provider value:
- `OnlineActionResolutionAuthority.hostClient`

### 4. Gated resolver controls in the Firebase handoff/debug UI
Updated:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Behavior now:
- queue watching still works for both host and guest
- the resolve button is only enabled for the authoritative client
- authority status is shown in the queue section
- copy now explains that host-owned resolution is temporary and may later move to backend authority

### 5. Added tests for the new authority policy
Added:
- `test/features/online_multiplayer/online_action_resolution_policy_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

Coverage added:
- host client can resolve under host-only policy
- guest client cannot resolve under host-only policy
- backend authority mode disables local client resolution
- controller blocks guest-side resolution before repository access

### 6. Updated docs
Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

Created:
- `docs/PR23_HANDOFF.md`

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

### Remote contract layer
- bootstrap payload contract
- public match contract
- private player contract
- online player action contract

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

### Action-resolution authority layer
- explicit authority enum + policy exists
- current saved authority is **host-only client resolution**
- guest clients can still inspect the queue feed but cannot trigger resolution
- future migration path is explicit for backend authority

---

## Important Rules To Preserve

- Keep game logic pure Dart.
- Keep online room/lobby/backend transport separate from official match-rule resolution.
- Keep bootstrap/public/private/action contracts explicit.
- Keep read-only remote hydration separate from action resolution.
- Keep queued action submission/watch transport-focused.
- Keep action resolution pure Dart where possible.
- Keep Firebase persistence focused on reading/writing explicit docs plus concurrency guards.
- Keep the current authority policy explicit instead of scattering host checks across widgets.
- Keep widgets thin: they should call providers/controllers, not build backend maps or rule resolution.
- Do **not** move official rule ownership into Firebase transport glue.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Files Added In This Chat

- `docs/PR23_HANDOFF.md`
- `lib/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart`
- `lib/features/online_multiplayer/domain/services/online_action_resolution_policy.dart`
- `test/features/online_multiplayer/online_action_resolution_policy_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`

## Files Updated In This Chat

- `README.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
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

## Best Next Step For Tomorrow

The strongest next step is:

## **tighten the host-owned resolver path or replace it with backend authority**

Recommended scope:
1. decide whether host-owned resolution should remain only as a foundation step or move toward backend authority next
2. if host-owned remains temporarily:
   - consider making authority visible in the lobby/session summary too
   - consider storing `resolvedByParticipantId` metadata on actions
3. if backend authority is next:
   - move resolver execution into a Cloud Function or equivalent server authority
   - keep the same explicit public/private/action contracts
4. consider adding public resolution summaries/timeline metadata for future online match UI
5. keep Firebase transport focused on persistence/guards rather than in-client rule ownership

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
