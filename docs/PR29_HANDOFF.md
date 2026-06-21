# PR29 Handoff — Backend-Authority Migration Wiring

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR29_HANDOFF.md`
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

This chat started the next backend-authority migration step without changing current explicit action metadata.

The saved goal was to prepare the online feature so backend-owned resolution can replace host-client resolution more cleanly later, while keeping the current working path intact.

---

## Saved Behavior

### Current default remains unchanged

The current official default is still:
- `hostClient` resolution authority

So the working online foundation remains usable exactly as before.

### New migration wiring now exists

Added provider-level authority selection so Firebase backend sessions can switch into:
- `backendService`

without changing:
- queued action docs
- existing resolver metadata fields
- pure Dart rule resolution logic

This means the app can now explicitly enter a backend-authority waiting mode at the provider/controller/UI boundary before real backend-owned resolution is implemented.

### UI / controller behavior in backend mode

When backend authority mode is active:
- local clients cannot resolve queued actions
- queue UI explains that clients are waiting for backend resolution
- local resolve button stays disabled with backend-owned wording
- controller rejects local resolution attempts before repository reads

This keeps migration behavior explicit and testable instead of scattering backend-authority assumptions inside widgets.

---

## Main Files Updated

- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `test/features/online_multiplayer/online_multiplayer_providers_test.dart`
- `test/features/online_multiplayer/online_action_resolution_controller_test.dart`
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `NEXT_CHAT_PROMPT.md`
- `NEXT_CHAT_PROMPT_SHORT.md`
- `docs/PR29_HANDOFF.md`

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

Best next follow-up from PR29:
1. implement actual backend-owned resolution persistence/trigger flow while preserving:
   - `resolvedByParticipantId`
   - `resolvedByUserId`
   - `resolutionSource`
2. decide whether backend authority writes exactly the same canonical public event shape or a versioned event schema
3. keep Firebase focused on persistence/watch/concurrency guards unless a dedicated backend authority layer is introduced
4. keep local clients read-only in backend mode until true backend resolution exists

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
