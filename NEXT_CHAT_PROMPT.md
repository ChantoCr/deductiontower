Start from:
- README.md
- AGENTS.md
- docs/PR6_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved gameplay/UI polish state after PR6.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR6_HANDOFF.md
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
- the match screen hides the active player's secret tag by default and uses an icon-based reminder reveal
- in-match submission uses a persistent bottom action console
- secret-tag selection uses a persistent bottom action bar
- character pool browser supports pool search, searchable series chips, difficulty filters, and staged-guess confirmation for the large live roster
- match history now uses filterable, collapsible structured event cards during live play
- the result screen now has an animated celebration banner plus a filterable/collapsible final replay timeline
- shared cards, buttons, timeline tiles, and pool rows now have stronger premium hover/tap feedback
- turn-transition and secret-tag selection now have a visual consistency pass with richer stage tracking, clearer privacy messaging, search clear UX, and stronger selection micro-animations
- shared match/result timeline mapping now lives in a dedicated presentation helper with a reusable timeline entry model
- shared match lookup helpers now cover winner/loser, trait labels, character labels, player-name lookup, and end-reason wording
- the result screen now includes richer winner-vs-loser comparative stats
- the secret reminder card and category-guess dialog now have more premium reveal/staging animation behavior
- shared dialogs and the hint utility panel have a richer polish pass, and the result banner now supports an optional non-blocking Flame-backed celebration backdrop
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
1. extract more shared presentation copy/summary helpers where screens still repeat microcopy or action-state wording
2. expand Flame-backed visual polish carefully to other safe presentation-only surfaces if performance stays strong
3. polish remaining dialogs and small utility panels so they match the new result/match/handoff motion quality
4. evaluate whether result analytics should later include persistent match history/stat tracking once local persistence is introduced

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Preserve the fixed bottom action areas for secret-tag selection and in-match submission
- Preserve the searchable series-chip flow for large rosters
- Prefer polished and readable gameplay UI over placeholder layouts
- Add or update tests when logic changes
