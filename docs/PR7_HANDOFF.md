# PR7 Handoff — Gameplay/UI Privacy Hardening + Shared Presentation Polish Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame local-multiplayer deduction game with:
- no-lives match rules
- protected pass-the-device secrecy
- shared character-pool browsing/search
- local curated runtime catalog plus MAL/Jikan-style import tooling
- premium gameplay-facing UI polish in progress

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR7_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

---

## Runtime / Data Status

Live runtime assets were **not changed** in this chat.

Current live catalog state still is:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important runtime note:
- if JSON assets change again while the app is already running, do a **full restart** so Flutter reloads the asset bundle

Known non-blocking review note still present:
- `vegeta` still keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Import pipeline state still remains valid:
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview records
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** total promoted preview records
- there is **no approved staged backlog** remaining outside the live runtime catalog

---

## What Was Completed Across This Chat

This chat continued from the PR5/PR6 gameplay UI polish state and moved the project into a stronger shared-presentation + privacy-hardened state.

### 1. Result celebration / timeline / hover polish from the original PR5 scope
Delivered and saved during this chat:
- animated winner celebration banner on result screen
- filterable and collapsible live/result timelines
- searchable series chips inside the pool browser
- stronger hover/tap feedback across cards, pool rows, timeline tiles, and shared buttons

### 2. Turn-transition and secret-selection visual consistency pass
Delivered and saved during this chat:
- richer protected handoff hero/state presentation
- staged rail for protected handoff flow
- better match snapshot chips on the handoff screen
- stronger secret-tag selection hero/state messaging
- staged progress rail for Player 1 / Player 2 secret selection
- searchable tag field clear UX
- improved bottom action bar feedback for staged tag selection

### 3. Shared presentation helper extraction
Delivered and saved during this chat:
- extracted shared timeline/event mapping into a dedicated helper:
  - `lib/features/game/presentation/helpers/match_presentation_mapper.dart`
- extracted reusable timeline entry model:
  - `lib/features/game/presentation/models/guess_history_entry.dart`
- extracted winner/loser + label/status lookup helper:
  - `lib/features/game/presentation/helpers/match_lookup_helper.dart`
- extracted shared setup/transition/match microcopy helper:
  - `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`

These helpers now centralize:
- winner/loser lookup
- player-name lookup
- trait-label lookup
- character-label lookup
- end-reason wording
- multiple setup/handoff/live-play microcopy strings

### 4. Richer result analytics
Delivered and saved during this chat:
- added winner-vs-loser comparative stats on the result screen
- current result comparison includes:
  - correct guesses
  - incorrect guesses
  - character guesses
  - trait guesses
  - hints used
  - turns taken
  - surrender note when applicable
- added supporting model:
  - `lib/features/game/presentation/models/match_result_comparison.dart`

### 5. Secret reminder + category-guess dialog polish
Delivered and saved during this chat:
- upgraded secret reminder card with richer hidden/revealed states
- added better reveal/hide transitions and status treatment
- upgraded category-guess dialog with:
  - staged selection
  - clearable search
  - stronger hover/tap feedback
  - explicit confirm flow before final trait guess submission

### 6. Shared dialogs and utility panel polish
Delivered and saved during this chat:
- upgraded `AppDialog` into a richer animated shell for:
  - info dialogs
  - feedback dialogs
  - confirm dialogs
- replaced the raw surrender dialog in match flow with shared confirm dialog usage
- upgraded hint utility panel with clearer ready/empty status treatment

### 7. Safe Flame-backed presentation polish
Delivered and saved during this chat:
- result celebration banner now supports an optional Flame-backed visual celebration backdrop behind the existing UI
- tower/public board panel now supports safe Flame-backed presentation polish
- all of this remains presentation-only and does **not** move business logic into Flame

New/updated Flame presentation files:
- `lib/features/flame_board/game/deduction_tower_game.dart`
- `lib/features/flame_board/components/energy_background_component.dart`
- `lib/features/flame_board/components/particle_burst_component.dart`

### 8. Small-panel consistency pass
Delivered and saved during this chat:
- `TurnPanel` upgraded with stronger status treatment
- `TowerView` upgraded with stronger premium visual style
- result stat cards upgraded with per-card accent styling
- shared status badges/glow language is more consistent across the flow

### 9. Privacy-safe browser reset between turns
Delivered and saved during this chat:
- the character pool browser now resets between turns on the same device
- reset now clears:
  - pool search text
  - series search text
  - selected series chip
  - selected difficulty chip
  - hover state
- the list also now scrolls back to the top after reset

### 10. Stronger privacy cueing after handoff
Delivered and saved during this chat:
- after revealing the next player turn, the pool now shows a short lock-overlay phase before the privacy-cleared notice appears
- added a clearer “privacy cleared” notice telling the active player that previous browser context was wiped
- the privacy notice is dismissible and also disappears naturally once the player starts interacting

### 11. Earlier clearing of staged character guess state
Delivered and saved during this chat:
- staged character selection and guess text are now cleared earlier in more handoff-sensitive cases
- on turn/context changes the live match screen now clears:
  - staged selected character
  - typed character guess text
  - revealed secret reminder visibility
  - old privacy cue state
  - old lock-overlay state

### 12. Match screen cleanup via reusable widgets
Delivered and saved during this chat:
- extracted reusable match UI pieces to reduce file size and repeated widget blocks:
  - `lib/features/game/presentation/widgets/match_privacy_gate.dart`
  - `lib/features/game/presentation/widgets/latest_public_event_card.dart`
  - `lib/features/game/presentation/widgets/pool_privacy_notice.dart`
  - `lib/features/game/presentation/widgets/match_action_bar.dart`

---

## Current Gameplay/UI Behavior To Remember

### Match privacy and local secrecy
- protected pass-the-device reveal flow is implemented
- the active player’s secret tag remains hidden by default and can be privately rechecked
- the character pool browser is now privacy-hardened for local multiplayer
- when a new player takes the turn:
  - previous search text is cleared
  - previous filters are cleared
  - previous scroll position is reset to top
  - previous staged guess text/selection is cleared
  - a short lock overlay appears
  - then a privacy-cleared notice appears

This privacy hardening is important and should be preserved.

### Match screen
- still uses a persistent bottom action console
- still supports shared-pool browsing/search and tap-to-stage guessing
- latest public event and public timeline are both richer/fiterable/collapsible than before
- history filters now auto-reset after handoff-sensitive turn changes through a reset key

### Result screen
- still includes animated winner celebration hero
- now also includes richer winner-vs-loser comparative stats
- still includes filterable/collapsible final replay timeline
- Flame backdrop is optional and presentation-only

### Category / transition / reminder flow
- secret-tag selection is more premium and staged
- category-guess dialog is more deliberate and harder to misuse
- protected handoff looks more premium and consistent with later screens
- secret reminder card has stronger reveal/hide treatment

### Shared UI feel
- cards, buttons, pool rows, dialogs, utility panels, and summary widgets now share a more consistent motion/glow/badge language
- hover/tap polish is stronger on pointer-capable layouts but still lightweight enough for gameplay flow

---

## Important Files Touched In This Chat

### Shared / presentation helpers
- `lib/features/game/presentation/helpers/match_presentation_mapper.dart`
- `lib/features/game/presentation/helpers/match_lookup_helper.dart`
- `lib/features/game/presentation/helpers/game_flow_copy_helper.dart`
- `lib/features/game/presentation/models/guess_history_entry.dart`
- `lib/features/game/presentation/models/match_result_comparison.dart`

### Match / result / flow screens
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/screens/category_selection_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`

### Gameplay widgets
- `lib/features/game/presentation/widgets/guess_history.dart`
- `lib/features/game/presentation/widgets/character_pool_panel.dart`
- `lib/features/game/presentation/widgets/result_celebration_banner.dart`
- `lib/features/game/presentation/widgets/secret_trait_card.dart`
- `lib/features/game/presentation/widgets/category_guess_dialog.dart`
- `lib/features/game/presentation/widgets/hint_panel.dart`
- `lib/features/game/presentation/widgets/turn_panel.dart`
- `lib/features/game/presentation/widgets/tower_view.dart`
- `lib/features/game/presentation/widgets/match_privacy_gate.dart`
- `lib/features/game/presentation/widgets/latest_public_event_card.dart`
- `lib/features/game/presentation/widgets/pool_privacy_notice.dart`
- `lib/features/game/presentation/widgets/match_action_bar.dart`

### Shared UI shell
- `lib/shared/widgets/app_card.dart`
- `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/app_dialog.dart`

### Flame presentation-only layer
- `lib/features/flame_board/game/deduction_tower_game.dart`
- `lib/features/flame_board/components/energy_background_component.dart`
- `lib/features/flame_board/components/particle_burst_component.dart`

### Tests
- `test/features/game/match_presentation_mapper_test.dart`

### Documentation
- `README.md`
- `docs/PR7_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

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

Suggested next focus after this saved state:
1. **extract more shared presentation summary builders where screens still repeat composed stat rows or panel structures**
2. **expand Flame-backed visual polish carefully to other safe presentation-only surfaces if performance stays strong**
3. **do a final pass on remaining small panels/widgets so their badge, glow, and spacing systems are fully aligned**
4. **evaluate whether result analytics should later include persistent match history/stat tracking once local persistence is introduced**
5. **if privacy polish continues, check other temporary local-only UI state for leaks across handoff moments**

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Keep hidden-information UX safe for one-device local multiplayer.
- Preserve the fixed bottom action areas for match and secret-tag selection.
- Preserve the searchable series-chip flow for large rosters.
- Preserve the new privacy-safe browser reset, top scroll reset, staged-guess clearing, and lock-overlay flow.
- Keep Flame visual polish presentation-only.
- If runtime JSON changes again, remind the user to do a full app restart.
