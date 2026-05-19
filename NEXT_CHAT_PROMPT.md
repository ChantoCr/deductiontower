Continue Anime Deduction Tower with the next MAL/Jikan character import expansion batch and richer tag pass.

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
- the game has no lives
- shared character pool gameplay is already wired
- protected local turn reveal is implemented
- setup names and hint count are editable and connected
- import preview, review queue, approval, and curated promotion preview pipelines already exist
- duplicate source mal_id detection is implemented
- duplicate transformed ids and tag validation are implemented
- expanded tag suggestions with false-positive control are implemented
- structured import/promotion validation reports are implemented
- optional anime-series lookup support is implemented
- reviewed-only promotion filtering through an explicit approval asset is implemented
- review-time enrichment/anime series mismatch reporting is implemented
- current imported characters have been merged into `assets/data/characters.json`
- the runtime catalog currently contains 36 characters
- the tag catalog has been expanded significantly for richer descriptors
- character library supports name/series search and shows an imported badge for non-original entries
- promotion tooling skips identical already-promoted imports as non-blocking
- preview, review queue, approval-aware promotion, and promotion output files already have tests

Important runtime note:
- if the app was already running when JSON assets changed, do a full restart to reload the updated catalog

Next scope:
1. add another larger external source batch so the runtime catalog keeps moving toward broad MAL/Jikan coverage
2. continue adding richer tags whenever character identity clearly justifies them
3. keep using approval + promotion flow rather than bypassing validation

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Do not overwrite curated runtime character JSON automatically unless explicitly requested
- Preserve protected local multiplayer secrecy
- Add tests for each new validation/reporting behavior
- Update docs and preview assets if the pipeline changes
