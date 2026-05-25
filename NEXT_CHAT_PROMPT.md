Continue Anime Deduction Tower from the gameplay-retake state.

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
- every currently approved imported character has now been merged into `assets/data/characters.json`
- the runtime catalog currently contains 1276 characters
- the tag catalog currently contains 40 tags
- every current tag is now represented in `assets/data/categories.json`
- secret-tag selection and tag-guess selection now support the full playable tag set
- the match screen now hides the active player's secret tag by default and uses an icon-based reminder reveal
- home/menu and setup UI were upgraded for a more professional gameplay-facing presentation
- import preview, review queue, approval, and curated promotion preview pipelines still exist and remain valid
- `characters_import_preview.json` currently contains 1264 imported preview records
- `characters_import_review_queue.json` currently contains 1264 review entries
- `characters_import_approval.json` currently contains 1263 approval entries
- `characters_curated_promotion_preview.json` currently contains 1276 total promoted preview records
- there is no approved staged backlog remaining outside the live runtime catalog
- Vegeta still has the known non-blocking `series_mismatch` review note

Important runtime note:
- if the app was already running when JSON assets changed, do a full restart to reload the updated catalog

Recommended next scope:
1. continue polishing the gameplay flow with the full live roster
2. improve match UX for the larger tag pool if needed
3. check pool balance and deduction readability now that every approved character is live
4. keep hidden-information screens safe and comfortable for one-device multiplayer
5. return to import expansion only if more catalog growth is explicitly requested

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Prefer polished and readable gameplay UI over placeholder layouts
- Add or update tests when logic changes
