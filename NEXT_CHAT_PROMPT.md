Start from:
- README.md
- AGENTS.md
- docs/PR8_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved PR8 player-vs-AI foundation + better AI reasoning + AI difficulty state.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR8_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/character-data-modeling/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current status:
- Flutter + Flame deduction game
- no lives system
- shared character pool gameplay is already wired
- protected local turn reveal is implemented
- setup names and hint count are editable and connected
- runtime catalog is loaded from assets/data/characters.json
- runtime catalog currently contains 1276 characters
- tag catalog currently contains 40 tags
- categories catalog currently contains 40 playable secret tags
- every currently approved imported character is already merged into runtime
- import preview / review queue / approval / curated promotion preview pipelines still exist and remain valid
- there is no approved staged backlog remaining outside runtime
- Vegeta still has the known non-blocking series_mismatch note

Saved gameplay/UI state now includes:
- premium home/setup/selection/handoff/match/result visual passes
- persistent bottom action areas for secret-tag selection and in-match submission
- result screen animated celebration banner
- optional non-blocking Flame-backed result celebration backdrop
- filterable + collapsible live and result timelines
- shared timeline/event mapping helper
- winner-vs-loser comparative result stats
- shared lookup helpers for winner/loser, player names, trait labels, character labels, and end-reason wording
- shared microcopy helper for setup / transition / match panels
- upgraded secret reminder card
- upgraded category-guess dialog with staged confirmation
- upgraded shared dialogs and hint utility panel
- tower view with safe Flame-backed presentation polish
- character pool browser supports:
  - name/series search
  - searchable series chips
  - difficulty filters
  - staged guess confirmation
  - privacy-safe reset between turns
  - reset to top scroll position on handoff
  - brief lock overlay before privacy-cleared notice
- match history filters auto-reset after handoff-sensitive turn changes
- staged character guess text/selection is cleared earlier in more handoff-sensitive cases

Saved AI state now includes:
- `Play vs AI` is enabled from the home screen
- setup supports match mode selection:
  - `Single Device Match`
  - `Play vs AI`
- player-vs-AI mode supports AI difficulty selection:
  - easy
  - standard
  - hard
- in player-vs-AI mode:
  - the human picks only their own hidden tag
  - the AI hidden tag is auto-assigned at match start
  - the human still gets a protected hidden-tag reveal gate before live tools
  - AI turns are public-only and do not need pass-the-device secrecy
  - AI turns run from the transition screen and return to match/result afterward
- AI reasoning now includes:
  - candidate-trait narrowing from prior AI character guess results
  - incorrect trait-guess elimination
  - stronger character-probe scoring based on split quality / elimination value / popularity weighting
  - better final trait-guess timing based on candidate count and remaining probe value
  - short reasoning summaries returned with AI move decisions
- AI remains mock/local and optional
- official rule resolution still belongs to the game engine

Important privacy behavior to preserve:
- hidden-information UX must stay safe for one-device local multiplayer
- when control passes to the next human player, browser/search/filter context must not leak
- staged guess text must not leak
- secret reminder visibility must not leak
- Flame must remain presentation-only and contain no business logic

Important architecture behavior to preserve:
- keep game logic pure Dart
- keep import logic in the data/import layer
- keep AI action choice separate from game-engine rule resolution
- keep AI difficulty as a behavior/config layer, not a rules layer

Important runtime note:
- if JSON assets change while the app is already running, do a full restart so Flutter reloads the asset bundle

Suggested next scope:
1. full UI polish for the Play vs AI flow
   - richer AI identity treatment in setup/match/result
   - stronger AI turn-complete summary presentation
   - premium AI difficulty presentation throughout the flow
2. refine AI reasoning summaries shown to the user
   - clearer explanation wording
   - maybe a dedicated AI move summary panel
3. evaluate whether result analytics should later expose AI-vs-human per-turn analytics more explicitly
4. later, consider a provider-backed AI opponent behind the same interface
5. if privacy polish continues, keep checking temporary local-only UI state for leaks across human handoff moments

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Preserve the fixed bottom action areas for secret-tag selection and in-match submission
- Preserve the searchable series-chip flow for large rosters
- Preserve the privacy-safe browser reset, top-scroll reset, staged-guess clearing, and lock-overlay flow
- Keep Flame visual polish presentation-only
- Keep AI action choice separate from game-engine rule resolution
- Keep AI difficulty as a behavior/config layer, not a rules layer
- Prefer polished and readable gameplay UI over placeholder layouts
- Add or update tests when logic changes
