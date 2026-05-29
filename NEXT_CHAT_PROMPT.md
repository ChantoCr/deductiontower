Start from:
- README.md
- AGENTS.md
- docs/PR7_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved gameplay/UI polish state after PR7.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR7_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/character-data-modeling/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current status:
- the game has no lives
- shared character pool gameplay is already wired
- protected local turn reveal is implemented
- setup names and hint count are editable and connected
- every currently approved imported character has been merged into `assets/data/characters.json`
- the runtime catalog currently contains 1276 characters
- the tag catalog currently contains 40 tags
- every current tag is represented in `assets/data/categories.json`
- secret-tag selection and tag-guess selection support the full playable tag set
- in-match submission uses a persistent bottom action console
- secret-tag selection uses a persistent bottom action bar
- the match screen hides the active player's secret tag by default and uses an icon-based reminder reveal
- the result screen has an animated celebration banner, optional non-blocking Flame-backed backdrop, richer stat cards, and winner-vs-loser comparative stats
- the match and result timelines use structured entries plus filter/collapse behavior
- shared timeline/event mapping now lives in a dedicated presentation helper with reusable models
- shared match lookup helpers now cover winner/loser, trait labels, character labels, player-name lookup, and end-reason wording
- shared setup/transition/match microcopy helpers now cover more status wording across setup, handoff, turn, and tower panels
- turn-transition and secret-tag selection now have a visual consistency pass with richer stage tracking, clearer privacy messaging, search clear UX, and stronger selection micro-animations
- the secret reminder card and category-guess dialog now have more premium reveal/staging behavior
- shared dialogs and utility panels have a richer polish pass
- the tower view now has safe Flame-backed public-board presentation polish
- the character pool browser supports pool search, searchable series chips, difficulty filters, staged-guess confirmation, and privacy-safe reset behavior
- the pool browser now resets search/filter state between turns, scrolls back to top, clears staged guess text earlier in handoff-sensitive flows, and shows a short lock overlay before a privacy-cleared notice appears
- match history now auto-resets filter/collapse state after handoff-sensitive turn changes
- import preview, review queue, approval, and curated promotion preview pipelines still exist and remain valid
- `characters_import_preview.json` currently contains 1264 imported preview records
- `characters_import_review_queue.json` currently contains 1264 review entries
- `characters_import_approval.json` currently contains 1263 approval entries
- `characters_curated_promotion_preview.json` currently contains 1276 total promoted preview records
- there is no approved staged backlog remaining outside the live runtime catalog
- Vegeta still has the known non-blocking `series_mismatch` review note

Important runtime note:
- if the app was already running when JSON assets changed, do a full restart to reload the updated catalog

Suggested next scope:
1. extract more shared presentation summary builders where screens still repeat composed stat rows or panel structures
2. expand Flame-backed visual polish carefully to other safe presentation-only surfaces if performance stays strong
3. do a final pass on remaining small panels/widgets so their badge, glow, and spacing systems are fully aligned
4. evaluate whether result analytics should later include persistent match history/stat tracking once local persistence is introduced
5. if privacy polish continues, check other temporary local-only UI state for leaks across handoff moments

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Preserve the fixed bottom action areas for secret-tag selection and in-match submission
- Preserve the searchable series-chip flow for large rosters
- Preserve the new privacy-safe browser reset, top scroll reset, staged-guess clearing, and lock-overlay flow
- Keep Flame visual polish presentation-only
- Prefer polished and readable gameplay UI over placeholder layouts
- Add or update tests when logic changes
