Continue Anime Deduction Tower after the latest PR 3 gameplay wiring.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/PR3_HANDOFF.md
- skills/flutter-architecture/SKILL.md
- skills/testing/SKILL.md
- skills/game-design/SKILL.md

Current status:
- The game has no lives
- Match creation is wired from selected traits
- Shared character pool is generated and stored in MatchController
- Match screen uses the real pool
- Character names can be tapped to autofill guesses
- Character guess, trait guess, hint request, and surrender all update real match state
- Turn transition screen is reused between turns
- Result screen reads real match data and timeline

Next suggested scope:
1. refine hint UX and hint consumption edge cases
2. improve turn transition polish and secret-information safety
3. add more controller/domain tests for invalid actions
4. connect hint and result summaries to richer data displays
5. start preparing the match flow for Flame visual integration without moving business logic out of domain

Rules:
- Keep game logic pure Dart
- Keep UI free of business rules
- Do not reintroduce lives
- Do not leak private hint text into public turn history
- Add tests for every behavior change
- Update docs if a gameplay system changes
