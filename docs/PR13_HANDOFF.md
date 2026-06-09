# PR13 Handoff — Mock Remote Lobby Event Simulation Saved State

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
- new mock remote join/ready simulation controls

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR13_HANDOFF.md`
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

This chat completed the next recommended online step:
- **simulate remote lobby events in the mock/preview online layer**

Delivered and saved:
- repository and datasource support for:
  - simulated remote guest join
  - simulated remote participant ready toggling
- controller support for those preview actions
- UI controls in the online foundation screen to trigger those mock remote events
- tests covering the new preview lifecycle behaviors

This gives the current online room preview a much more realistic second-device feel without pretending that realtime backend sync already exists.

---

## New Behavior Saved

### Domain / session helpers
Updated:
- `lib/features/online_multiplayer/domain/entities/online_room_session.dart`

Saved helpers now include:
- `remoteParticipants`
- `primaryRemoteParticipant`

These are used to keep preview remote-event flows readable.

### Repository and datasource contract expansion
Updated:
- `lib/features/online_multiplayer/domain/repositories/online_room_repository.dart`
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`

New preview operations now include:
- `simulateRemoteGuestJoin(...)`
- `setRemoteParticipantReady(...)`

### Mock datasource preview rules
Saved behavior now includes:
- a host-created room can simulate a remote guest joining
- a room with a remote participant can simulate that remote participant toggling ready/not-ready
- room phase still resolves through the same explicit phase logic:
  - `waitingForOpponent`
  - `waitingForReady`
  - `readyToSync`

### Controller updates
Updated:
- `lib/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart`

Saved controller behavior now includes:
- `simulateRemoteGuestJoin()`
- `toggleRemoteReady()`
- state helpers:
  - `canSimulateRemoteGuestJoin`
  - `canSimulateRemoteReadyToggle`

### UI updates
Updated:
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

Saved online foundation UI now includes:
- preview-only mock remote controls in the active room card
- host-room ability to simulate a remote guest join
- room ability to simulate remote ready/not-ready
- snackbar feedback for simulated remote lifecycle changes

Important UX rule to preserve:
- these controls are still clearly framed as **mock preview controls**, not real backend behavior

---

## Tests Updated

Updated:
- `test/features/online_multiplayer/mock_online_room_repository_test.dart`
- `test/features/online_multiplayer/online_lobby_controller_test.dart`

Validated behavior now includes:
- simulated remote guest join from a host preview room
- simulated remote ready toggling
- phase promotion into `readyToSync` when both sides are ready
- failure when remote-ready simulation is requested without a remote participant

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR13_HANDOFF.md`
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
- Keep mock remote event simulation clearly separated from actual backend sync behavior.
- Future realtime/backend work should extend the datasource/repository boundary instead of bypassing it.
- If runtime JSON changes again, remind the user to do a full app restart.

---

## Validated Commands

Verified at the end of this chat:

```bash
flutter analyze
flutter test
```

Both passed.

---

## Recommended Next Scope

Best next options from this new saved state:

1. **wire a bootstrap preview summary into the online foundation screen**
   - surface the generated `RemoteMatchBootstrapPayload`
   - optionally show initial public/private preview summaries in a dev-safe way
   - keep this presentation-only for now

2. **later, wire Firebase-backed room creation/join/watch**
   - use the saved datasource/repository boundary
   - use the saved remote contract models and bootstrap service
   - do not duplicate official rules in the online feature

3. **after backend wiring, add realtime room watch/reconnect states**
   - joined
   - waiting
   - ready
   - reconnecting
   - expired/closed

Recommended immediate next step:
- **wire a bootstrap preview summary into the online foundation screen**

That is now the cleanest follow-up because the mock lobby can simulate a full ready-to-sync lifecycle, and the next useful preview is showing what remote match bootstrap data would be produced from that state.
