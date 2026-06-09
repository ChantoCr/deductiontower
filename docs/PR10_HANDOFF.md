# PR10 Handoff — Online Backend Boundary Preview Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with:
- no-lives rules
- protected one-device local multiplayer secrecy
- shared character-pool deduction flow
- local curated runtime catalog plus MAL/Jikan-style import tooling
- polished mock player-vs-AI mode
- online multiplayer lobby foundation preview
- new backend-ready online datasource/repository abstraction

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR10_HANDOFF.md`
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
- **first backend abstraction for Firebase/Supabase without full live sync**

Delivered and saved:
- the online room repository now sits on top of an explicit **online room datasource** contract
- the default app flow still uses the existing **mock preview** behavior
- two new backend-ready preview adapters now exist for:
  - **Firebase preview**
  - **Supabase preview**
- the online providers now expose a backend-target selection boundary
- the online screen now surfaces the current backend boundary in the UI

This keeps the current lobby behavior stable while making later backend swap work cleaner.

---

## Online Backend Boundary Details

### New data config
Added:
- `lib/features/online_multiplayer/data/config/online_backend_target.dart`

Current backend targets are:
- `mockPreview`
- `firebasePreview`
- `supabasePreview`

These are **preview-only** targets right now.
They do **not** add realtime sync yet.

### New datasource layer
Added:
- `lib/features/online_multiplayer/data/datasources/online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart`
- `lib/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart`

Important current behavior:
- the Firebase and Supabase preview datasources currently preserve the same local preview contract as the mock datasource
- this is intentional so the repository/controller/presentation path can stay stable before live backend work begins

### New repository implementation
Added:
- `lib/features/online_multiplayer/data/repositories/online_room_repository_impl.dart`

Current structure is now:
- `OnlineLobbyController`
  -> `OnlineRoomRepository`
  -> `OnlineRoomRepositoryImpl`
  -> `OnlineRoomDataSource`
  -> selected preview adapter

### Compatibility wrapper kept
Updated:
- `lib/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart`

It now acts as a compatibility wrapper over the new repository implementation using the mock datasource.
This preserved existing tests and controller usage patterns while the new boundary was introduced.

---

## Online Provider / UI Updates

Updated:
- `lib/features/online_multiplayer/presentation/providers/online_multiplayer_providers.dart`
- `lib/features/online_multiplayer/presentation/screens/online_match_screen.dart`

Saved behavior now includes:
- `onlineBackendTargetProvider` with a default of `mockPreview`
- datasource selection behind the provider boundary
- repository construction through the selected datasource
- online screen backend-boundary card and backend badge so the current preview target is visible in-app

Important current limitation:
- there is still **no live backend switching UI for end users**
- the backend target is still a provider/config concern for architecture and future overrides

---

## Tests Added / Updated

Added:
- `test/features/online_multiplayer/online_multiplayer_providers_test.dart`

Validated behavior now includes:
- default provider path uses the mock preview datasource
- provider override can resolve the Firebase preview adapter
- provider override can resolve the Supabase preview adapter
- repository behavior still returns valid preview room sessions through each configured target

Existing online tests still pass, including:
- mock repository compatibility tests
- online lobby controller tests

---

## Documentation Updated

Updated:
- `README.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/PR10_HANDOFF.md`
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

1. **online room setup -> remote match bootstrap payload design**
   - define the future room-to-match handoff payload
   - keep official rule resolution in the existing game domain

2. **simulate remote lobby events in the mock/preview online layer**
   - fake remote guest join
   - fake remote ready toggles
   - deepen room phase tests

3. **later, wire realtime room membership and transport**
   - use the existing datasource/repository boundary
   - do not duplicate official rules in the online feature

Recommended immediate next step:
- **remote match bootstrap payload design**

That is now the best follow-up because the backend boundary exists, but the room still does not define the payload that will eventually hand off into remote match startup.
