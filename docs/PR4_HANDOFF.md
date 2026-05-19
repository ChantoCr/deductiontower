# PR4 Handoff — Anime Deduction Tower

## Project

**Anime Deduction Tower**

A Flutter + Flame mobile deduction game with no lives, protected local multiplayer turns, shared character-pool deduction, and a prototype external anime character import pipeline.

---

## Current Saved State

The repository now includes:

### Gameplay / local multiplayer
- no-lives ruleset
- correct-trait-guess and surrender end conditions
- shared character pool generation from selected traits
- tap-to-autofill character selection from the pool
- real character guess flow
- real trait guess flow
- private hint requests that consume hints
- protected turn reveal before showing private info
- pass-the-device transition reuse between turns
- result timeline and end-reason display
- editable setup for player names and hint count

### External import pipeline
- raw MAL/Jikan-style sample character input asset
- optional MAL/Jikan-style anime sample asset for series lookup
- manual enrichment asset with aliases/source reference/import notes plus optional `animeMalId`
- transformer from external data to internal `CharacterModel`
- preview importer service
- duplicate source `mal_id` detection
- duplicate transformed-id detection
- tag validation against `assets/data/tags.json`
- lightweight tag suggestions from external `about` text
- structured preview validation/report output
- generated review queue preview asset
- structured promotion conflict/report output
- explicit approval asset for reviewed-only promotion
- curated promotion preview generation
- tests that verify preview, review queue, approval-aware promotion, and promotion output formats

---

## Important Files

### Runtime gameplay files
- `lib/features/game/presentation/screens/game_setup_screen.dart`
- `lib/features/game/presentation/screens/turn_transition_screen.dart`
- `lib/features/game/presentation/screens/match_screen.dart`
- `lib/features/game/presentation/screens/result_screen.dart`
- `lib/features/game/presentation/controllers/match_controller.dart`
- `lib/features/game/domain/services/game_engine.dart`

### Import pipeline files
- `lib/features/characters/data/imports/models/external_character_import_model.dart`
- `lib/features/characters/data/imports/models/external_character_import_enrichment.dart`
- `lib/features/characters/data/imports/models/external_anime_import_model.dart`
- `lib/features/characters/data/imports/models/character_import_validation_issue.dart`
- `lib/features/characters/data/imports/models/character_import_approval_entry.dart`
- `lib/features/characters/data/imports/models/external_character_import_review_entry.dart`
- `lib/features/characters/data/imports/models/external_character_import_preview_report.dart`
- `lib/features/characters/data/imports/models/character_import_promotion_report.dart`
- `lib/features/characters/data/imports/transformers/external_character_import_transformer.dart`
- `lib/features/characters/data/imports/datasources/local_external_character_import_datasource.dart`
- `lib/features/characters/data/imports/services/external_character_tag_suggestion_service.dart`
- `lib/features/characters/data/imports/services/external_character_import_preview_service.dart`
- `lib/features/characters/data/imports/services/external_character_import_preview_importer.dart`
- `lib/features/characters/data/imports/datasources/local_character_import_promotion_datasource.dart`
- `lib/features/characters/data/imports/services/character_import_promotion_service.dart`
- `lib/features/characters/data/imports/services/character_import_promotion_importer.dart`

### Import assets
- `assets/data/imports/mal_jikan_characters_sample.json`
- `assets/data/imports/mal_jikan_anime_sample.json`
- `assets/data/imports/mal_jikan_character_enrichment_preview.json`
- `assets/data/imports/characters_import_preview.json`
- `assets/data/imports/characters_import_review_queue.json`
- `assets/data/imports/characters_import_approval.json`
- `assets/data/imports/characters_curated_promotion_preview.json`

### Tooling
- `tool/generate_characters_import_preview.dart`
- `tool/generate_characters_import_review_queue.dart`
- `tool/generate_characters_curated_promotion_preview.dart`

---

## Validated Status

Latest verified commands in this session:

```bash
flutter test
flutter analyze
```

Both passed at the end of the session.

---

## Recommended Next PR Scope

# PR 4 — Import Review and Catalog Expansion Tooling

Progress completed in this repo state:

1. duplicate source-record detection by `mal_id`
2. expanded tag-suggestion helpers with false-positive control from external `about` text
3. structured import/promotion validation reporting
4. optional anime/series import support
5. review queue asset generation for imported characters
6. explicit approval asset plus reviewed-only promotion filtering
7. review-time enrichment/anime series mismatch reporting
8. current sample imports approved and merged into `assets/data/characters.json`
9. promotion tooling now treats identical already-promoted imports as non-blocking
10. runtime catalog expanded again with the next approved external character batch
11. character library now supports name/series search and shows an imported badge for non-original entries
12. tag catalog expanded significantly so imported characters can carry richer descriptors beyond the original MVP tags
13. another larger reviewed import batch has been merged into runtime

Recommended remaining scope:

1. **Continue adding larger raw external record batches until the catalog approaches the desired MAL/Jikan coverage**
2. **Keep expanding the tag catalog whenever new characters clearly justify new descriptors**
3. **Optionally add a dev-only preview toggle for future import batches before merge**
4. **Keep curated runtime JSON reviewable even after manual promotion**

---

## Recommended PR 4 Rules

- Keep runtime gameplay data separate from prototype import assets.
- Do not replace `assets/data/characters.json` automatically.
- Keep import logic in data/import tooling, not widgets.
- Preserve the no-lives game rules.
- Preserve protected local turn secrecy.
- Add tests for every import validation behavior change.
- Update docs and preview assets when import logic changes.

---

## Recommended Tests For Next PR

Add or expand tests for:
- review-time enrichment/anime series mismatch handling
- richer tag-suggestion coverage and false-positive control
- approval-asset/report handling if the schema evolves further

---

## Suggested Next Chat Prompt

```txt
Continue Anime Deduction Tower with PR 4: import review and catalog expansion tooling.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR4_HANDOFF.md
- skills/flutter-architecture/SKILL.md
- skills/character-data-modeling/SKILL.md
- skills/testing/SKILL.md

Current status:
- local multiplayer core flow is already wired
- the game has no lives
- protected local turn reveal is implemented
- import preview, review queue, approval, and curated promotion preview pipelines already exist
- duplicate source ids, duplicate transformed ids, tag validation, structured reporting, approval-aware promotion, and series mismatch reporting are already implemented
- optional anime-series lookup is already wired
- preview, review queue, approval-aware promotion, and promotion output files already have tests
- the app runtime now reads imported sample characters directly from the updated `assets/data/characters.json`
- the runtime catalog currently contains 36 characters after the latest approved import merge
- the tag catalog now contains many richer descriptor tags used by imported and original characters
- if the app was already open during asset changes, a full restart is needed to reload the asset bundle

Now continue with one of these next scopes:
1. add another larger external source batch and repeat the approval/promotion flow
2. keep enriching imported/original characters with richer tags as new batches are added
3. add a dev-only preview toggle for browsing future promotion-preview imports in-app

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Do not overwrite curated runtime character JSON automatically
- Add tests for each new validation/reporting behavior
- Update docs and preview assets if the pipeline changes
```

---

## Final Note

Tomorrow's chat should start from `docs/PR4_HANDOFF.md` and `NEXT_CHAT_PROMPT.md`.
