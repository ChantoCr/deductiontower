Start from:
- README.md
- AGENTS.md
- docs/PR13_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved PR13 state.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/ROADMAP.md
- docs/PR13_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current status:
- Flutter + Flame deduction game
- no-lives rules
- shared character pool gameplay is already wired
- protected local multiplayer secrecy is implemented
- premium setup/selection/handoff/match/result UI is already in place
- runtime catalog is loaded from assets/data/characters.json
- runtime catalog currently contains 1276 characters
- tag catalog currently contains 40 tags
- categories catalog currently contains 40 playable secret tags
- every currently approved imported character is already merged into runtime
- import preview / review queue / approval / curated promotion preview pipeline still exists and remains valid
- there is no approved staged backlog remaining outside runtime
- Vegeta still has the known non-blocking `series_mismatch` note

Saved local multiplayer / privacy state includes:
- protected hidden-tag reveal flow for one-device human play
- privacy-safe character pool browser reset between human turns
- search/filter/scroll/staged-guess reset on handoff
- lock overlay and privacy-cleared notice
- fixed bottom action areas for secret-tag selection and in-match submission

Saved AI state includes:
- `Play vs AI` is enabled from home
- setup supports local multiplayer and player-vs-AI
- AI difficulty supports:
  - easy
  - standard
  - hard
- AI hidden tag is auto-assigned
- AI turns are public-only and run from the transition screen
- AI reasoning summaries are now persisted into public turn notes
- AI move summaries appear in dialog, latest-event, timeline, match, and result screens
- setup/match/result now include richer AI profile and performance presentation
- official rule resolution still belongs to the game engine

Saved online multiplayer foundation now includes:
- enabled `Online Match` button from home
- dedicated online room foundation screen
- online feature-first structure with domain/data/presentation separation
- room-code normalization and copy flow
- host-vs-guest lobby mode switching
- readiness messaging and room preview UX
- remote-ready lobby model with:
  - participant-level entities
  - local participant identity
  - explicit roles
  - explicit connection-state preview modeling
  - explicit room phases:
    - waitingForOpponent
    - waitingForReady
    - readyToSync
  - local ready toggle support
- mock remote guest join and remote ready simulation now exist for preview/testing
- explicit backend-target provider/config with:
  - `mockPreview`
  - `firebasePreview`
  - `supabasePreview`
- repository implementation now resolves through an `OnlineRoomDataSource`
- Firebase and Supabase preview adapters currently preserve the same local preview contract as the mock datasource
- explicit remote contract models now exist for:
  - `RemoteMatchBootstrapPayload`
  - `RemoteMatchPublicState`
  - `RemotePlayerPrivateState`
  - `OnlinePlayerAction`
- online data models now serialize those contracts in a Firestore-friendly shape for later room/match syncing
- a pure Dart `RemoteMatchBootstrapService` now converts a ready room plus secret selections into initial remote payload/public/private state

Important architecture rules:
- keep game logic pure Dart
- keep import logic in the data/import layer
- keep AI action choice separate from game-engine rule resolution
- keep AI difficulty as a behavior/config layer, not a rules layer
- keep online lobby / room transport state separate from official match-rule resolution
- future backend/realtime work should extend the online datasource/repository boundary instead of bypassing it
- keep Flame presentation-only

Important runtime note:
- if JSON assets change while the app is already running, do a full restart so Flutter reloads the asset bundle

Validated at saved state:
- `flutter analyze` passes
- `flutter test` passes

Strongest next scope options:
1. wire a bootstrap preview summary into the online foundation screen
2. later Firebase-backed room creation/join/watch behind the current datasource boundary
3. after backend wiring add realtime room watch/reconnect states

If continuing online multiplayer, prefer this order:
- bootstrap preview wiring
- Firebase room wiring later
- realtime watch/reconnect states after that

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Preserve protected local multiplayer secrecy
- Preserve fixed bottom action areas and privacy reset behavior
- Preserve searchable series-chip flow for large rosters
- Keep Flame presentation-only
- Keep AI action choice separate from game-engine rule resolution
- Keep online room/lobby state separate from official match-rule resolution
- Add or update tests when logic changes
