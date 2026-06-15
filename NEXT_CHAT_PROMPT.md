Start from:
- README.md
- AGENTS.md
- docs/PR19_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from the saved PR19 state.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/ROADMAP.md
- docs/PR19_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current online multiplayer state now includes:
- mock preview room create/join/readiness flow
- Firebase-backed realtime room create/join/watch/readiness flow
- explicit remote contracts for bootstrap/public/private/action state
- pure Dart remote bootstrap service
- deterministic preview seed service
- Firebase bootstrap persistence for:
  - `online_rooms/{roomCode}/match_bootstrap/current`
  - `online_rooms/{roomCode}/match_public/current`
  - `online_rooms/{roomCode}/private_player_state/{participantId}`
- Firebase watch/read support for those persisted docs through the datasource/repository boundary
- reconnect-aware room-to-match handoff UX in the online lobby screen
- read-only remote match screen-state hydration from persisted bootstrap/public/private docs plus local catalog data
- mock mode still preserved when Firebase config is missing

Important rules:
- keep game logic pure Dart
- keep online room/lobby/backend transport separate from official match-rule resolution
- keep bootstrap/public/private/action contracts explicit
- keep read-only remote hydration separate from future action resolution
- keep Firebase runtime init guarded so mock mode still works without config
- keep reconnect/handoff UI read-only with respect to bootstrap assembly
- keep Flame presentation-only
- add or update tests when logic changes
- if JSON assets change while the app is already running, remind that a full app restart is needed

Best next scope:
1. add queued online player action submission through the datasource/repository boundary
2. add read/watch support for queued action state
3. keep official action resolution outside widgets and outside Firebase transport glue
