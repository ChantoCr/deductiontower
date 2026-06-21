# PR30 Handoff — Backend-Authority Bridge Auto-Resolution

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR30_HANDOFF.md`
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

This chat continued backend-authority migration by adding an actual **backend-authority bridge auto-resolution flow** for Firebase backend mode, while preserving the same resolver metadata fields and canonical public event contract.

Important nuance:
- this is still a bridge step inside the app/runtime architecture
- it is **not** a true Cloud Function / dedicated server authority yet
- but it now exercises backend-style ownership behavior in the saved Firebase backend path

---

## Saved Behavior

### Current default still remains

The default working path is still:
- `hostClient` resolution authority

So existing host-owned online resolution continues to work unchanged.

### New backend-authority bridge path

When these conditions are true:
- backend target is `firebaseBackend`
- authority is switched to `backendService`
- pending action docs exist
- the online handoff/queue UI is active

then the app now auto-attempts queued-action resolution through a backend-authority bridge path.

### What the bridge does

The bridge now:
- reads the oldest pending action
- loads persisted handoff docs
- applies official rules through the same pure Dart resolver
- persists:
  - updated public state
  - resolved action metadata
  - canonical public event doc
  - optional private-state update
- stamps backend-style metadata using:
  - `resolutionSource = backendService`
  - `resolvedByParticipantId = backend_authority`
  - `resolvedByUserId = backend_authority_service`

This preserves the same metadata fields while making backend-owned resolution behavior explicit.

### Local-client behavior in backend mode

When backend authority mode is active:
- local manual resolution is still blocked
- the queue UI explains backend-owned resolution
- the normal local resolve button stays disabled
- auto-resolution is attempted in the background instead

---

## Files Updated

- `lib/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `docs/PR30_HANDOFF.md`

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

Best next follow-up from PR30:
1. replace the current backend-authority bridge with a true backend-owned resolver path
2. preserve these existing metadata fields during that migration:
   - `resolvedByParticipantId`
   - `resolvedByUserId`
   - `resolutionSource`
3. keep the canonical public event contract stable unless a deliberate versioned schema is introduced
4. if moving to Cloud Functions or another server authority, keep Firebase transport focused on persistence/watch/guards and move ownership into a dedicated authority layer

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
