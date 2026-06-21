# PR28 Handoff — Canonical Public Online Event Contract

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR28_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

Also read before coding if touching online architecture/tests/UI:
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `skills/flutter-architecture/SKILL.md`
- `skills/testing/SKILL.md`
- `skills/ui-ux-mobile/SKILL.md`

---

## What Changed

This chat took the next step after PR27 and turned the earlier derived public timeline preview into a **canonical public online event contract**.

The key goal was:
- keep official rules in pure Dart
- keep queued action transport separate from resolution
- preserve explicit bootstrap/public/private/action contracts
- preserve current action metadata fields unchanged
- persist a dedicated public-facing event payload for future remote timeline/result UI

---

## New Saved Contract

Added canonical public event entity/model:
- `RemoteMatchPublicEvent`
- `RemoteMatchPublicEventModel`

The contract currently stores:
- `eventId`
- `roomCode`
- `matchId`
- `actionId`
- `participantId`
- `participantName`
- `actionType`
- `status`
- `shortLabel`
- `actionSummary`
- `resultSummary`
- `submittedValueLabel`
- `resultingMatchVersion`
- `createdAt`
- `publishedAt`
- `resolutionSource`

Important rule preserved:
- private hint text is **not** persisted into the public event contract

---

## Saved Behavior

### Resolution now produces a canonical public event

`RemoteMatchActionResolver` now stamps a `publicEvent` alongside:
- updated public match state
- resolved action doc
- optional affected private state

This keeps public event generation pure Dart and close to official action resolution.

### Persistence now writes a dedicated public event doc

Action-resolution persistence now stores:
- updated `match_public/current`
- updated `player_actions/{actionId}`
- optional updated `private_player_state/{participantId}`
- new `match_public_events/{eventId}`

### Read path now watches public event docs explicitly

Added repository/datasource watch support for canonical public events.

The Firebase handoff / remote-state UI now reads the timeline from persisted public event docs instead of deriving timeline text from queued action payloads in the widget layer.

### Existing explicit action metadata remains unchanged

Still preserved on resolved action docs:
- `resolvedByParticipantId`
- `resolvedByUserId`
- `resolutionSource`

This keeps backend-authority migration smooth.

---

## Files Added

- `lib/features/online_multiplayer/domain/entities/remote_match_public_event.dart`
- `lib/features/online_multiplayer/data/models/remote_match_public_event_model.dart`
- `docs/PR28_HANDOFF.md`

## Files Updated

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
- `lib/features/online_multiplayer/presentation/widgets/online_public_action_timeline_card.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/online_multiplayer_models_test.dart`
- `test/features/online_multiplayer/remote_match_action_resolver_test.dart`
- `test/features/online_multiplayer/remote_match_firestore_action_resolution_bundle_builder_test.dart`
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`

---

## Tests / Validation

Verified in this chat:

```bash
flutter analyze
flutter test
```

Both passed.

---

## Runtime / Asset Note

Runtime JSON assets were **not changed** in this chat.

Current catalog state still remains:
- runtime catalog: **1276 characters**
- tags: **40**
- categories: **40**

If JSON assets change in a future chat while the app is already running, do a **full app restart**.

---

## Best Next Scope

Best next follow-up from PR28:
1. start backend-authority migration while preserving current explicit action metadata
2. keep Firebase focused on persistence/watch/concurrency guards, not rule ownership
3. if the public event contract expands later, keep it public-safe and avoid leaking private hint text or hidden secrets
4. decide whether backend authority should publish the same event shape or a future versioned event schema

---

## Important Rules To Preserve

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
