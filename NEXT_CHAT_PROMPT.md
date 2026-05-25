Continue Anime Deduction Tower with PR5 in high-throughput mode.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR5_HANDOFF.md
- NEXT_CHAT_PROMPT.md
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
- multiple approved imported batches have already been merged into `assets/data/characters.json`
- the runtime catalog currently contains 1076 characters
- the tag catalog currently contains 40 tags
- there are two approved 100-character staged backlogs not yet merged into runtime
- the older staged backlog is led by ids like `rigurd`, `vt`, `knives_millions`, `ryoma_terasaka`, `henry_henderson`, `renzou_shima`, `sid_barrett`, `iris`, `sachiko_yagami`, and `rivalz_cardemonde`
- the newer staged backlog is led by ids like `takuya_muramatsu`, `diethard_ried`, `hitoshi_demegawa`, `iaian`, `rinku`, `robert_e_o_speedwagon`, `totosai`, `lisanna_strauss`, `pochita`, and `akitaru_obi`
- the tag catalog is expanded for richer descriptors including hero, rival, mentor, leader, young, student, strong, fast, muscular, super powers, super saiyan, fire user, ice user, demon, alien, martial artist, strategist, stoic, magic user, lightning user, assassin, blond hair, brown hair, red hair, blue hair, green hair, purple hair, gun user, cyborg, psychic, pink hair, and water user
- this repo now includes staged-tag review helpers through `tool/review_recent_import_tag_expansion.py`, `tool/review_current_staged_tag_expansion.py`, `tool/review_remaining_staged_tag_expansion.py`, `tool/review_batch12_staged_tag_expansion.py`, `tool/review_batch13_staged_tag_expansion.py`, `tool/review_batch14_staged_tag_expansion.py`, and `tool/review_batch15_staged_tag_expansion.py`
- this repo now includes high-throughput batch staging helpers through `tool/update_large_import_and_tags_batch_15.py` and `tool/update_large_import_and_tags_batch_16.py`
- character library supports name/series search and shows an imported badge for non-original entries
- promotion tooling skips identical already-promoted imports as non-blocking
- preview, review queue, approval-aware promotion, and promotion output files already have tests
- `characters_import_preview.json` currently contains 1264 imported preview records
- `characters_import_review_queue.json` currently contains 1264 review entries
- `characters_import_approval.json` currently contains 1263 approval entries
- `characters_curated_promotion_preview.json` currently contains 1276 total promoted preview records
- the latest staged tag-review pass added richer tags to 95 characters in the current staged backlog
- the latest staged import batch broadened coverage with Assassination Classroom, Code Geass, Death Note, One Punch Man, Yu Yu Hakusho, JoJo's Bizarre Adventure, Inuyasha, Fairy Tail, Chainsaw Man, and Fire Force
- Vegeta still has the known non-blocking `series_mismatch` review note

Important runtime note:
- if the app was already running when JSON assets changed, do a full restart to reload the updated catalog

Next scope:
1. merge the older staged 100-character approved preview batch into `assets/data/characters.json`
2. then add another 100-character high-throughput staged batch
3. continue doing a richer tag review pass for the staged backlog
4. add new tags only when character identity clearly justifies them
5. regenerate preview, review queue, and promotion preview
6. keep tests and analysis green
7. update `README.md`, `docs/PR5_HANDOFF.md`, and `NEXT_CHAT_PROMPT.md` with the new counts/state
8. remind the user to fully restart the app after runtime JSON changes

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Do not overwrite curated runtime character JSON automatically unless explicitly requested
- Preserve protected local multiplayer secrecy
- Add tests for each new validation/reporting behavior
- Update docs and preview assets if the pipeline changes
