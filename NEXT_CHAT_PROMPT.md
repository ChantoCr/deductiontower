Start from:
- README.md
- AGENTS.md
- docs/PR5_HANDOFF.md
- NEXT_CHAT_PROMPT.md

That handoff is set up for:
1. full result screen celebration / winner animation
2. match history filters and collapsible timeline
3. series filter search inside the pool chips
4. more premium card animations and hover/tap feedback across the game UI

Continue Anime Deduction Tower from the saved gameplay/UI retake state.

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
- every current tag is represented in `assets/data/categories.json`
- secret-tag selection and tag-guess selection now support the full playable tag set
- the match screen hides the active player's secret tag by default and uses an icon-based reminder reveal
- home/menu, setup, secret selection, protected handoff, match, and result screens have already gone through multiple premium UI polish passes
- in-match submission uses a persistent bottom action console
- secret-tag selection uses a persistent bottom action bar
- character pool browser now supports search, series filters, difficulty filters, and staged-guess confirmation for the large live roster
- result timeline already uses per-event colors and icons
- import preview, review queue, approval, and curated promotion preview pipelines still exist and remain valid
- `characters_import_preview.json` currently contains 1264 imported preview records
- `characters_import_review_queue.json` currently contains 1264 review entries
- `characters_import_approval.json` currently contains 1263 approval entries
- `characters_curated_promotion_preview.json` currently contains 1276 total promoted preview records
- there is no approved staged backlog remaining outside the live runtime catalog
- Vegeta still has the known non-blocking `series_mismatch` review note

Important runtime note:
- if the app was already running when JSON assets changed, do a full restart to reload the updated catalog

Do this next:
1. full result screen celebration / winner animation
2. match history filters and collapsible timeline
3. series filter search inside the pool chips
4. more premium card animations and hover/tap feedback across the game UI

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Preserve the fixed bottom action areas for secret-tag selection and in-match submission
- Prefer polished and readable gameplay UI over placeholder layouts
- Add or update tests when logic changes
