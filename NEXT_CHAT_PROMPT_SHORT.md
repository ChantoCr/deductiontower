Read first:
- README.md
- AGENTS.md
- docs/PR32_HANDOFF.md
- NEXT_CHAT_PROMPT.md

Then read before coding:
- docs/ARCHITECTURE.md
- docs/ROADMAP.md
- docs/DATA_MODEL.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/ui-ux-mobile/SKILL.md

Current state:
- local gameplay works
- protected one-device secrecy works
- AI mode works with easy/standard/hard behavior
- Firebase online room create/join/watch/readiness works
- explicit bootstrap/public/private/action contracts exist
- Firestore bootstrap/public/private docs persist and watch
- queued action submission/watch works
- pure Dart online action resolver exists
- canonical public event docs persist
- host client remains the default official resolver
- Firebase backend mode now uses a dedicated backend-authority service path for datasource-owned queue draining
- resolved action docs preserve `resolvedByParticipantId`, `resolvedByUserId`, and `resolutionSource`
- runtime catalog: 1276 characters / 40 tags / 40 categories

Important rules:
- keep game logic pure Dart
- keep online transport separate from official rule resolution
- keep widgets thin
- keep Flame presentation-only
- add/update tests when logic changes
- if JSON assets change, remind that a full app restart is needed

Best next step:
- move the dedicated backend-authority service into a true server-owned runtime while preserving current action metadata and canonical public event shape
- or add a backend resolution lease/claim flow first
