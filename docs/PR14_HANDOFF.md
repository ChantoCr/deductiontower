# PR14 Handoff — Online Bootstrap Preview Summary Saved State

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
- mock remote join/ready simulation controls
- new on-screen remote bootstrap preview summary

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR14_HANDOFF.md`
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
- **wire a bootstrap preview summary into the online foundation screen**

Delivered and saved:
- a deterministic preview seed service for assigning mock private traits from the valid trait catalog
- providers that assemble a remote bootstrap preview once a room reaches `readyToSync`
- a new online foundation widget that renders:
  - bootstrap payload summary
  - initial public match summary
  - masked private-state summary
- updated online foundation screen layout to show that preview card
- tests for deterministic preview seed selection

This lets the current preview lobby simulate a realistic room lifecycle and then visibly demonstrate what remote match data would be generated next.

---

## New Service Added

Added:
- `lib/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart`

### Purpose

This service deterministically chooses preview-only remote secret seeds from the valid trait catalog.

Saved behavior:
- uses room-code-derived indexing so preview assignment is stable for a given room
- picks a second distinct trait when more than one valid category exists
- falls back to the same single category when only one valid category exists
- throws when host/guest participants are not both present

---

## New Widget Added

Added:
- `lib/features/online_multiplayer/presentation/widgets/online_bootstrap_preview_card.dart`

### Saved UI behavior

The new bootstrap preview card now:
- stays empty until the room reaches `readyToSync`
- loads character + validated trait data through providers
- renders a room-to-match preview summary once bootstrap data can be built
- shows:
  - starting player
  - pool size
  - hints-per-player preview assumption
  - payload summary rows
  - initial public player-state summary
  - masked private-state confirmation rows

Important privacy/UI rule preserved:
- the preview card does **not** reveal secret trait ids/labels in the UI
- it only confirms that secrets are assigned and locked for each participant

---

## Provider Updates

Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`

New providers now include:
- `remoteMatchBootstrapServiceProvider`
- `remoteMatchPreviewSeedServiceProvider`
- `onlinePreviewHintsPerPlayerProvider`
- `remoteMatchBootstrapPreviewProvider`

### Saved preview flow

The preview provider now:
1. watches the active online room session
2. waits until the room is `readyToSync`
3. loads the validated trait catalog and characters
4. builds deterministic preview player seeds
5. runs `RemoteMatchBootstrapService`
6. returns a `RemoteMatchBootstrapResult` for the UI card

Current preview assumption:
- bootstrap preview currently assumes **2 hints per player** until real online setup fields are wired

---

## Screen Update

Updated:
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

Saved online foundation layout now includes:
- remote bootstrap preview card in both narrow and wide layouts
- the preview card sits alongside the existing room/session controls without taking rule logic into the widget layer

---

## Tests Added

Added:
- `test/features/online_multiplayer/remote_match_preview_seed_service_test.dart`

Validated behavior now includes:
- deterministic preview seed generation
- distinct host/guest preview trait selection when possible
- single-category fallback behavior
- failure when both room participants are not available

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR14_HANDOFF.md`
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
- Keep preview UI read-only with respect to bootstrap assembly; the widget should consume derived preview state, not generate the contracts itself.
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

1. **later, wire Firebase-backed room creation/join/watch**
   - use the saved datasource/repository boundary
   - use the saved remote contract models, preview seed service, and bootstrap service
   - do not duplicate official rules in the online feature

2. **after backend wiring, add realtime room watch/reconnect states**
   - joined
   - waiting
   - ready
   - reconnecting
   - expired/closed

3. **optionally refine online setup inputs before backend wiring**
   - expose hints-per-player for online setup
   - replace the preview-only constant assumption when appropriate

Recommended immediate next step:
- **wire Firebase-backed room creation/join/watch**

That is now the cleanest follow-up because the preview flow can already simulate room lifecycle and display the resulting bootstrap output, so the next major value is connecting the saved boundaries to a real backend.
