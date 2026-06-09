Start from:
- README.md
- AGENTS.md
- docs/PR13_HANDOFF.md
- NEXT_CHAT_PROMPT_SHORT.md

Continue Anime Deduction Tower from the saved PR13 state.

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
- `Play vs AI` is enabled and presentation-polished for the current mock/MVP scope
- AI difficulty: easy / standard / hard
- AI hidden tag is auto-assigned
- AI turns are public-only from the transition screen
- AI reasoning summaries are persisted as public turn notes
- AI profile / move summary / result analytics UI is saved
- game engine still resolves all official rules

Saved online multiplayer state:
- `Online Match` is enabled from home
- dedicated online foundation screen exists
- participant-level lobby modeling is in place
- room phases now include:
  - waitingForOpponent
  - waitingForReady
  - readyToSync
- local ready toggle support exists
- mock remote guest join and remote ready simulation now exist for preview/testing
- online room flow now has an explicit datasource/repository boundary
- backend preview targets now include:
  - mockPreview
  - firebasePreview
  - supabasePreview
- default provider target remains `mockPreview`
- Firebase/Supabase preview adapters currently preserve the same local preview behavior
- explicit remote contract models now exist for:
  - `RemoteMatchBootstrapPayload`
  - `RemoteMatchPublicState`
  - `RemotePlayerPrivateState`
  - `OnlinePlayerAction`
- a pure Dart `RemoteMatchBootstrapService` now converts a ready room plus secret selections into initial remote payload/public/private state
- this is still preview/local architecture only, not realtime backend sync

Important rules:
- keep game logic pure Dart
- keep import logic in the data/import layer
- preserve local multiplayer secrecy and privacy protections
- keep Flame presentation-only
- keep AI action choice separate from game-engine rule resolution
- keep AI difficulty as behavior/config only, not rules
- keep online lobby state separate from official match-rule resolution
- future backend work should extend the online repository boundary
- if JSON assets change, remind to do a full app restart
- add/update tests when logic changes

Best next focus:
- wire a bootstrap preview summary into the online foundation screen
- or later Firebase-backed room creation/join/watch behind the current datasource boundary
- or after backend wiring add realtime room watch/reconnect states
