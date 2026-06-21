# PR27 Handoff — Public Online Resolution Timeline Preview

## Read First Next Chat

Start from:
- `README.md`
- `AGENTS.md`
- `docs/PR27_HANDOFF.md`
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

This chat took the recommended next step from PR26:
- added a **small read-only public online resolution timeline layer** for future remote match UI

The goal was to keep:
- official match rules in pure Dart game/domain services
- queued action transport separate from resolution
- explicit bootstrap/public/private/action contracts unchanged
- Firebase focused on persistence/watch/guards rather than rule ownership

---

## Saved Behavior

### New public timeline layer

Added a derived timeline builder that converts persisted `OnlinePlayerAction` docs plus local catalog labels into public-safe timeline entries.

This layer currently derives:
- short status label
- action summary text
- result summary text
- participant display name
- character / trait label when available
- timestamp
- optional resolver source badge

Important limitation kept explicit:
- this is a **derived preview layer**, not a canonical backend event payload
- exact rule truth still belongs to the existing game engine + public/private match state
- private hint text remains private and is not leaked into the timeline

### UI integration

The Firebase handoff / remote-state panel now shows:
- existing queued action feed/debug area
- new **Public resolution timeline preview** section

This makes the saved online foundation easier to inspect from a future remote-match-UI perspective without changing action metadata yet.

---

## Files Added

- `lib/features/online_multiplayer/domain/entities/remote_match_action_timeline_entry.dart`
- `lib/features/online_multiplayer/domain/services/remote_match_action_timeline_builder.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_public_action_timeline_card.dart`
- `test/features/online_multiplayer/remote_match_action_timeline_builder_test.dart`
- `docs/PR27_HANDOFF.md`

## Files Updated

- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/widgets/online_room_handoff_card.dart`
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
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

## Recommended Next Scope

Best next follow-up from PR27:
1. promote the derived timeline into a more explicit public-event contract design
2. or start backend-authority migration while keeping current resolver metadata unchanged
3. if backend authority starts next, keep these fields unchanged for smooth migration:
   - `resolvedByParticipantId`
   - `resolvedByUserId`
   - `resolutionSource`
4. decide whether action resolution should eventually persist a compact canonical public event payload for remote match/result timelines

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
