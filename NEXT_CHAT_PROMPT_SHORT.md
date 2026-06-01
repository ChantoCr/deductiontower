Start from:
- README.md
- AGENTS.md
- docs/PR8_HANDOFF.md
- NEXT_CHAT_PROMPT_SHORT.md

Continue Anime Deduction Tower from the saved PR8 state.

Current saved state:
- no-lives deduction game
- shared character pool, protected local multiplayer secrecy, persistent bottom action areas
- premium setup/selection/handoff/match/result UI
- privacy-safe browser reset, top-scroll reset, staged-guess clearing, lock overlay, privacy-cleared notice
- runtime catalog: 1276 characters
- tag catalog: 40 tags
- categories catalog: 40 playable secret tags
- import preview/review/approval/promotion pipeline still valid
- no approved staged backlog remains outside runtime
- Vegeta still has the known non-blocking `series_mismatch` note

Saved AI state:
- `Play vs AI` is enabled
- setup supports mode selection: local multiplayer or player-vs-AI
- player-vs-AI supports AI difficulty: easy / standard / hard
- human picks only their own hidden tag
- AI hidden tag is auto-assigned at match start
- AI turns are public-only and run from the transition screen
- AI reasoning now uses better candidate filtering, stronger public-probe scoring, and better final trait-guess timing
- AI move decisions now include short reasoning summaries
- game engine still resolves all official match rules

Important rules:
- keep game logic pure Dart
- keep import logic in the data/import layer
- preserve local multiplayer secrecy and existing privacy protections
- preserve searchable series-chip flow for large rosters
- keep Flame presentation-only
- keep AI action choice separate from game-engine rule resolution
- keep AI difficulty as behavior/config only, not rules
- if JSON assets change, remind to do a full app restart
- add/update tests when logic changes

Best next focus:
- full UI polish for the Play vs AI flow
- improve AI move summary presentation and microcopy
- optionally deepen AI reasoning without changing core rules
