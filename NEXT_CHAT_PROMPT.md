Start from:
- README.md
- AGENTS.md
- docs/PR32_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Continue Anime Deduction Tower from saved PR32 state.

Before coding, read:
- docs/ARCHITECTURE.md
- docs/ROADMAP.md
- docs/DATA_MODEL.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current saved state:
- local no-lives gameplay is working
- protected one-device multiplayer secrecy is working
- AI mode is working with easy/standard/hard behavior
- online room foundation is working with mock + Firebase-backed room create/join/watch/readiness
- explicit remote contracts exist for bootstrap/public/private/action
- Firestore bootstrap docs are persisted and watched
- reconnect-aware handoff UX exists
- read-only remote screen-state hydration exists
- queued online player action submission/watch exists
- pure Dart queued-action resolver/application flow exists
- current official online action-resolution owner is still the host client by default
- Firebase backend mode now has a dedicated backend-authority service path
  - datasource-owned queue draining
  - preserved `backendService` metadata
  - preserved canonical public event persistence
- resolved action docs preserve:
  - resolvedByParticipantId
  - resolvedByUserId
  - resolutionSource
- canonical public online event docs now persist for future remote timeline/result UI
- room participants preserve userId
- runtime catalog: 1276 characters
- tags: 40
- categories: 40

Important rules:
- keep game logic pure Dart
- keep online transport separate from official match-rule resolution
- keep bootstrap/public/private/action contracts explicit
- keep read-only hydration separate from action resolution
- keep queued action transport separate from resolution
- keep action resolution pure Dart where possible
- keep authority/resolver metadata explicit
- keep Firebase focused on persistence/watch/concurrency guards, not rule ownership
- keep widgets thin
- keep Flame presentation-only
- add/update tests when logic changes
- if JSON assets change, remind that a full app restart is needed

Best next step:
- move the dedicated backend-authority service into a true Cloud Function / server-owned runtime while preserving current explicit action metadata and canonical public event shape
- or add an explicit backend resolution lease/claim flow before that server migration
