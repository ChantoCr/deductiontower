# PR5 Handoff — Gameplay/UI Retake Saved State

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with local multiplayer, a shared character-pool deduction loop, and a curated MAL/Jikan-style import pipeline.

---

## Start From In The Next Chat

Read these first:
- `README.md`
- `AGENTS.md`
- `docs/PR5_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`

---

## Current Runtime / Data Status

The app loads its live character catalog from:
- `assets/data/characters.json`

Current live catalog state:
- runtime catalog size: **1276 characters**
- tag catalog size: **40 tags**
- secret-tag category catalog size: **40 categories**

Important data state:
- every currently approved imported character is already merged into runtime
- `assets/data/characters.json` matches the approved promoted catalog
- `assets/data/categories.json` now exposes every current playable tag
- there is **no approved staged backlog** remaining outside runtime

Current import asset counts:
- `assets/data/imports/mal_jikan_characters_sample.json` contains **1264** source character records
- `assets/data/imports/mal_jikan_character_enrichment_preview.json` contains **1264** enrichment entries
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview characters
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** promoted preview characters

Known non-blocking review issue still present:
- `vegeta` keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Important runtime note:
- if the app was already running while JSON assets changed, do a **full restart** so Flutter reloads the asset bundle

---

## What Was Completed Across This Chat

This chat moved the project from import-expansion mode into a saved gameplay/UI retake state.

### 1. Full approved catalog is now live
- merged the full approved promoted catalog into `assets/data/characters.json`
- the gameplay now uses the complete currently approved roster

### 2. Every current tag is playable
- expanded `assets/data/categories.json` to cover the full tag catalog
- the game now exposes all current tags in secret selection and tag-guess flow

### 3. Premium gameplay-facing UI retake pass was started and saved
This chat delivered multiple focused polish passes.

#### First gameplay/UI retake pass
- upgraded home/menu presentation
- improved single-device setup UX
- improved player-name readability and spacing
- upgraded secret-tag selection UI
- hid the active player's secret tag by default
- added icon-based private reminder reveal

#### Second gameplay/UI retake pass
- redesigned the match screen structure
- redesigned the result screen
- improved character-pool browser for large rosters
- moved in-match submission controls into a persistent bottom action area

#### Third gameplay/UI retake pass
- upgraded turn transition into a premium secrecy / handoff screen
- added animated correct/wrong guess feedback dialogs
- added wide-layout optimization for match and result screens
- moved secret-tag selection actions into a persistent bottom action area

#### Fourth gameplay/UI retake pass
- redesigned result timeline into colored/icon-based event cards
- added character-pool chip filters for series and difficulty
- improved in-match staged-guess confirmation in both pool and action console
- added protected reveal micro-animations

---

## Current Gameplay/UI Behavior To Remember

### Match privacy
- protected pass-the-device reveal is implemented
- the secret tag stays hidden by default during the live match
- the active player can privately re-check their own secret tag using the reminder icon

### Action accessibility
- in-match character guess submission is pinned in a persistent bottom action console
- secret-tag selection uses a persistent bottom action bar
- players no longer need to scroll to the bottom after choosing a tag or a character guess

### Large roster ergonomics
- character pool supports search by name and series
- character pool supports chip filtering by series and difficulty
- the currently staged guess is clearly confirmed in the browser and action console

### Result readability
- result timeline events now have per-event colors and icons
- result screen has a stronger winner summary, stat cards, and revealed-tag section

### Wide layouts
- match screen has a wide two-column layout
- result screen has a wide two-column layout
- bottom action areas adapt better on wider screens

---

## Important Files Touched In This Chat

### Runtime/catalog assets
- `assets/data/characters.json`
- `assets/data/categories.json`
- `assets/data/tags.json`

### Import assets still in use
- `assets/data/imports/mal_jikan_characters_sample.json`
- `assets/data/imports/mal_jikan_character_enrichment_preview.json`
- `assets/data/imports/characters_import_preview.json`
- `assets/data/imports/characters_import_review_queue.json`
- `assets/data/imports/characters_import_approval.json`
- `assets/data/imports/characters_curated_promotion_preview.json`

### Shared/UI foundation
- `lib/app/theme.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/app_dialog.dart`
- `lib/shared/animations/pulse_animation.dart`

### Home / setup / selection flow
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/home/presentation/widgets/main_menu_button.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/category_selection_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`

### Match / result flow
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/widgets/category_guess_dialog.dart`
- `lib/features/game/presentation/widgets/character_pool_panel.dart`
- `lib/features/game/presentation/widgets/guess_history.dart`
- `lib/features/game/presentation/widgets/hint_panel.dart`
- `lib/features/game/presentation/widgets/secret_trait_card.dart`
- `lib/features/game/presentation/widgets/tower_view.dart`
- `lib/features/game/presentation/widgets/turn_panel.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`

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

The next chat should continue from gameplay/UI polish mode, not import-expansion mode.

Recommended exact next focus:
1. **full result screen celebration / winner animation**
2. **match history filters and collapsible timeline**
3. **series filter search inside the pool chips**
4. **more premium card animations and hover/tap feedback across the game UI**

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Keep hidden-information UX safe for one-device local multiplayer.
- Prefer polished, readable UI over placeholder layouts in gameplay-facing screens.
- Preserve the fixed bottom action areas for match and secret-tag selection.
- If runtime JSON changes again, remind the user to do a full app restart.
