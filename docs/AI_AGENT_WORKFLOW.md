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

---

## PR Strategy

### PR 1

Initialize project foundation.

### PR 2

Add character and trait data model.

### PR 3

Implement core game engine.

### PR 4

Build local multiplayer flow.

### PR 5

Add premium UI.

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
Create the initial Flutter + Flame project structure following AGENTS.md. Add placeholder screens, routing, theme, docs, and skeleton domain entities. Do not implement full gameplay yet.
```

Bad:

```txt
Make the whole game.
```

## Agent Boundaries

Agents should not:

- Add online multiplayer before local mode
- Add OpenAI calls before abstraction
- Use copyrighted images
- Mix UI and business logic
- Ignore folder structure
- Remove docs
