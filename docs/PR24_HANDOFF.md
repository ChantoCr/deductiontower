# PR24 Handoff — Persisted Resolver Metadata On Online Actions

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
- `docs/PR24_HANDOFF.md`
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

This chat completed the next online follow-up:

## **persist resolver metadata like `resolvedByParticipantId` on action docs**

### 1. Extended the explicit online action contract
Updated:
- `lib/features/online_multiplayer/domain/entities/online_player_action.dart`
- `lib/features/online_multiplayer/data/models/online_player_action_model.dart`

New persisted field:
- `resolvedByParticipantId`

Behavior now:
- pending actions keep it null
- resolved actions can store which participant officially resolved them
- parsing and serialization preserve the new field through the model boundary

### 2. Stamped resolver metadata during pure Dart action resolution
Updated:
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`

Behavior now:
- resolver takes `resolvedByParticipantId`
- both applied and rejected resolved actions keep that metadata
- this remains pure Dart and explicit rather than being inferred inside Firebase glue

### 3. Passed authoritative resolver identity from the controller layer
Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`

Behavior now:
- the current authoritative local resolver session supplies `session.localParticipantId`
- host-owned authority policy still controls whether the controller may resolve at all

### 4. Persisted resolver metadata through Firestore action docs
No transport shape rewrite was needed because the existing bundle path already serializes the resolved action model.

Updated persistence result:
- `player_actions/{actionId}` now stores `resolvedByParticipantId` for resolved actions

### 5. Surfaced resolver metadata in debug queue UI
Updated:
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`

Behavior now:
- resolved queue entries display:
  - submitting participant
  - expected match version
  - resolver participant when present

### 6. Added / updated tests
Updated:
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`

Coverage now includes:
- action-model parsing of `resolvedByParticipantId`
- resolved-action stamping inside the pure Dart resolver
- Firestore action-resolution bundle output including `resolvedByParticipantId`

### 7. Updated docs
Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

Created:
- `docs/PR24_HANDOFF.md`

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
- resolved action metadata includes `resolvedByParticipantId`

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
- resolved action docs now record who resolved them through `resolvedByParticipantId`
- Firebase transaction persistence guards version/status races

### Action-resolution authority layer
- explicit authority enum + policy exists
- current saved authority is **host-only client resolution**
- guest clients can still inspect the queue feed but cannot trigger resolution
- future migration path remains explicit for backend authority

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
- `lib/features/online_multiplayer/domain/services/remote_match_action_resolver.dart`
- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
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

## **add richer resolution metadata or begin backend authority migration**

Recommended scope:
1. consider adding resolver metadata such as:
   - `resolvedByUserId`
   - `resolutionSummary`
   - `resolutionSource` (`hostClient`, `backendService`, etc.)
2. consider adding a small public online resolution timeline/summary model for future remote match UI
3. if backend authority is next, keep the same explicit action contract and resolution metadata fields so migration remains smooth
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
