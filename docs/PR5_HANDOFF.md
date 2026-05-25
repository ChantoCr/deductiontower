# PR5 Handoff — Approved Catalog Fully Live + Gameplay/UI Retake Ready

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with local multiplayer, a shared character-pool deduction loop, and a curated MAL/Jikan-style import pipeline.

---

## Current Runtime Status

The app loads its live character catalog from:
- `assets/data/characters.json`

Current runtime catalog size:
- **1276 characters**

Current tag catalog size:
- **40 tags**

Important runtime result from this pass:
- all currently approved imported characters have now been merged into the live runtime catalog
- `assets/data/characters.json` now matches the current approved promotion preview output
- the secret-tag selection flow now exposes **every playable tag** in the catalog through `assets/data/categories.json`

Important runtime note:
- if the app was already running while JSON assets changed, do a **full restart** so Flutter reloads the asset bundle

---

## Current Import / Promotion Status

Current import asset counts:
- `assets/data/imports/mal_jikan_characters_sample.json` contains **1264** source character records
- `assets/data/imports/mal_jikan_character_enrichment_preview.json` contains **1264** enrichment entries
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview characters
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** promoted preview characters

Current approved staging status:
- there is **no approved staged backlog remaining outside runtime**
- the approved promotion preview currently matches the live runtime catalog size

Known non-blocking review issue still present:
- `vegeta` keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Review queue issue summary:
- only **1** review entry currently has issues
- that single issue is the known non-blocking `series_mismatch` on `vegeta`

---

## Gameplay/UI Status After This Pass

### 1. Every approved character is now live in the game
- the full approved catalog is now available through the runtime character asset
- character-library browsing and gameplay now use the complete currently approved roster

### 2. Every current tag is now selectable as a secret tag / guess target
- `assets/data/categories.json` was expanded to mirror the full tag catalog
- the game now exposes **40** playable secret-tag categories
- each generated category currently uses `minCharacters: 1` so every used tag can appear in selection

### 3. Setup/menu UX was upgraded for gameplay retake
The gameplay-facing UI now includes:
- a more polished home/menu layout
- larger, clearer match-entry cards
- improved single-device setup spacing
- cleaner player-name entry presentation
- stronger hint setup and match-preview presentation

### 4. Secret-tag privacy was improved during live turns
The match screen now:
- hides the active player's secret tag by default
- provides an icon-based reminder toggle so the player can privately re-check their own tag
- avoids keeping the hidden tag openly visible on the match screen

### 5. Tag selection and guess selection scale better now
The tag selection flow now includes:
- searchable secret-tag selection
- searchable tag guess dialog
- larger catalog-friendly selection UI for the full tag set

---

## Key Files Touched For This Phase

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

### Gameplay/UI files touched
- `lib/app/theme.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/home/presentation/widgets/main_menu_button.dart`
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/category_selection_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/widgets/category_guess_dialog.dart`
- `lib/features/game/presentation/widgets/secret_trait_card.dart`
- `lib/features/game/presentation/widgets/turn_panel.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`

---

## Validated Commands

Verified in this session:

```bash
flutter test
flutter analyze
```

Both passed at the end of the session.

---

## Recommended Next Scope

The import expansion work is no longer the immediate priority.

Recommended next focus:
1. continue retaking the core gameplay loop with the full live roster
2. keep polishing the setup, match, and result UX for a portfolio-level feel
3. evaluate pool balance now that every approved character is live
4. improve in-match deduction ergonomics for a much larger tag set
5. consider follow-up privacy polish for hidden information screens if needed
6. only return to import expansion when more catalog growth is explicitly requested

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Keep hidden-information UX safe for one-device local multiplayer.
- Prefer polished, readable UI over placeholder layouts in gameplay-facing screens.
- If runtime JSON changes again, remind the user to do a full app restart.
