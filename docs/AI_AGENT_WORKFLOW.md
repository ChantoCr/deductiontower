# AI Agent Workflow

## Purpose

This project is designed to work with AI coding agents such as Pi.

The workflow uses:

- README.md for human understanding
- AGENTS.md for agent rules
- Skills for specialized execution guidance
- Small PR-based tasks

---

## Agent Workflow

Before coding, the agent must:

1. Read `README.md`
2. Read `AGENTS.md`
3. Read the relevant Skill
4. Inspect the current folder structure
5. Make a small coherent change
6. Add or update tests if needed
7. Update documentation if needed

When gameplay rules change, the agent must also update:

- end conditions
- data model notes
- test expectations
- any UI placeholders that still show outdated rules
- import preview or promotion preview assets if import logic changes

---

## PR Strategy

### PR 1

Initialize project foundation.

### PR 2

Add character and trait data model.

### PR 3

Implement core game engine.

### PR 4

Continue importer review, validation, and catalog expansion tooling.

### PR 5

Polish local multiplayer flow and premium UI.

Use `docs/PR4_HANDOFF.md` and `NEXT_CHAT_PROMPT.md` as the preferred next-chat starting points.

### PR 6

Add Flame board effects.

### PR 7

Prepare AI referee architecture.

### PR 8

Add online-ready architecture.

---

## Prompting Rules

Prompts to agents should be specific.

Good:

```txt
Create the next core game engine step for Anime Deduction Tower. Keep the game no-lives, support surrender as a match-ending action, and wire a shared character pool that can be browsed or searched during guessing.
```

Bad:

```txt
Make the whole game.
```

## Agent Boundaries

Agents should not:

- Add online multiplayer before local mode
- Add OpenAI calls before abstraction
- Reintroduce a life system
- Overwrite curated runtime character JSON directly from prototype imports
- Use copyrighted images
- Mix UI and business logic
- Ignore folder structure
- Remove docs
