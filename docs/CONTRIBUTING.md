# Contributing

## Development Rules

1. Follow `AGENTS.md`.
2. Use the relevant Skill before making changes.
3. Keep PRs small.
4. Write readable code.
5. Keep game logic testable.
6. Update docs when needed.
7. If you change gameplay rules, update tests and remove outdated UI placeholders.

---

## Branch Naming

Examples:

```txt
feature/project-foundation
feature/character-data-model
feature/game-engine
feature/local-multiplayer
feature/flame-board
feature/ai-referee
```

## Commit Style

Examples:

- `feat: initialize Flutter project foundation`
- `feat: add character data model`
- `feat: add character pool browser to match screen`
- `feat: remove lives from match flow`
- `feat: implement surrender end condition`
- `test: add game engine unit tests`
- `docs: update architecture guide`

## Pull Request Checklist

- [ ] Follows `AGENTS.md`
- [ ] Uses correct folder structure
- [ ] Keeps domain independent from Flutter
- [ ] Adds tests for game logic if needed
- [ ] Updates documentation if needed
- [ ] Does not include copyrighted images
- [ ] Does not reintroduce a life system
- [ ] Keeps character pool behavior consistent across docs and code
