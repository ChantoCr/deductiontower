# AGENTS.md

## Project Name

Anime Deduction Tower

## Purpose

Anime Deduction Tower is a Flutter + Flame mobile deduction game where players discover hidden anime-inspired character traits through turn-based guessing, tag filtering, and strategic reasoning.

The goal is to build a professional portfolio-level project that demonstrates:

- Mobile game development
- Flutter architecture
- Flame visual effects
- Clean game logic
- Data-driven character systems
- AI-ready architecture
- Strong UI/UX
- Testable code
- Agent-assisted development workflow

---

## Important Principle

The README is for humans.  
This AGENTS.md is for AI coding agents.  
The Skills folder contains specialized instructions for specific work areas.

Agents must read this file before making changes.

---

## Current Development Goal

Build the project foundation first.

Do not attempt to implement every planned feature at once.

The first goal is to create a clean, scalable Flutter + Flame project structure with:

- App bootstrap
- Routing
- Theme system
- Feature-first folder structure
- Local JSON data placeholders
- Domain entities
- Initial game engine skeleton
- Basic screens
- Documentation
- Skills

---

## Product Summary

Anime Deduction Tower is a local-first mobile deduction game.

Two players play on one device.

Each player has a secret trait category. The opponent does not know it.

Players take turns guessing characters and eventually try to identify the hidden trait.

Example:

- Secret trait: Black Hair
- Valid characters: Goku, Vegeta, Sasuke, Madara, Levi
- Opponent guesses characters and deduces the trait from correct/incorrect results.

---

## Tech Stack

Use:

- Flutter
- Dart
- Flame
- Riverpod
- GoRouter

Planned later:

- Hive or SharedPreferences for local persistence
- Firebase or Supabase for online multiplayer
- OpenAI API for AI referee and AI opponent

Do not add backend infrastructure during the foundation phase unless explicitly requested.

---

## Architecture Style

Use feature-first clean architecture.

Main layers:

- `data`
- `domain`
- `presentation`

The game feature should include:

- Entities
- Repositories
- Services
- Controllers
- Screens
- Widgets

The core game logic must live in the domain layer.

The UI must not contain business rules.

The Flame layer must not contain business rules.

---

## Main Folder Structure

Expected structure:

```txt
lib/
  main.dart

  app/
    app.dart
    router.dart
    theme.dart
    bootstrap.dart

  core/
    constants/
    errors/
    utils/
    enums/

  features/
    characters/
      data/
      domain/
      presentation/

    game/
      data/
      domain/
      presentation/

    flame_board/
      game/
      components/
      effects/

    ai_referee/
      data/
      domain/
      presentation/

    profile/
      data/
      domain/
      presentation/

    settings/
      presentation/

    home/
      presentation/

  shared/
    widgets/
    animations/
    styles/
```

Also include:

```txt
assets/
  data/
  images/
  audio/
  fonts/

docs/
skills/
test/
```

## Non-Negotiable Rules

- Keep game logic independent from UI.
- Keep Flame visual logic separate from domain logic.
- Do not put business rules inside widgets.
- Do not hardcode large character datasets inside Dart files.
- Use JSON files for initial character, tag, and category data.
- Use readable names.
- Prefer small focused classes.
- Write code that a junior/mid developer can understand.
- Add comments only where they clarify decisions, not obvious syntax.
- Avoid overengineering before the MVP works.

## Naming Conventions

Use English for code.

Examples:

- `GameMatch`
- `Player`
- `Turn`
- `Guess`
- `TraitCategory`
- `CharacterTag`
- `GameEngine`
- `TraitFilterEngine`
- `HintEngine`

File names should use snake_case:

- `game_match.dart`
- `trait_category.dart`
- `game_engine.dart`
- `trait_filter_engine.dart`

## State Management

Use Riverpod.

Preferred pattern:

- Controllers in `presentation/controllers`
- Providers near the controller or feature
- Domain services should not depend on Riverpod
- Entities should be plain Dart objects

## Routing

Use GoRouter.

Initial routes:

- `/`
- `/home`
- `/setup`
- `/category-selection`
- `/match`
- `/result`
- `/characters`
- `/settings`
- `/profile`

## Theme Direction

Visual style:

- Dark anime-inspired UI
- Neon accents
- Clean mobile-first design
- Strong contrast
- Smooth animations
- Premium portfolio-level polish

Color palette:

- Background: `#090A14`
- Surface: `#141827`
- Primary: `#8B5CF6`
- Secondary: `#06B6D4`
- Accent: `#F97316`
- Success: `#22C55E`
- Error: `#EF4444`
- Text: `#F8FAFC`
- Muted: `#94A3B8`

## Initial Screens

Create basic versions of:

- Splash Screen
- Home Screen
- Game Setup Screen
- Category Selection Screen
- Turn Transition Screen
- Match Screen
- Result Screen
- Character Library Screen
- Settings Screen
- Profile Screen

During the foundation phase, screens can be simple placeholders but must follow the visual theme.

## Core Domain Entities

Create initial domain entities for:

- Character
- CharacterTag
- TraitCategory
- GameMatch
- Player
- Turn
- Guess
- GuessResult

Keep them simple and immutable when possible.

## Core Services

Create initial skeletons for:

- GameEngine
- TraitFilterEngine
- HintEngine
- MatchRulesEngine

These services must be plain Dart and testable.

## Data Files

Use:

- `assets/data/characters.json`
- `assets/data/tags.json`
- `assets/data/categories.json`

Initial files can contain small sample data.

Avoid copyrighted images in public assets.

For MVP, use placeholder images or no images.

## Testing Rules

Unit tests are required for core game logic.

Start with tests for:

- Filtering characters by trait
- Validating correct character guesses
- Validating incorrect character guesses
- Switching turns
- Detecting winner
- Hint generation rules

Do not write widget tests until core logic is stable.

## Flame Rules

Flame is used for visual game-like effects only.

Allowed in Flame layer:

- Card movement
- Tower animation
- Reveal effects
- Particle effects
- Background effects

Not allowed in Flame layer:

- Match winner calculation
- Trait filtering rules
- Guess validation rules
- Player state decisions

If Flame needs game state, it must receive already-computed data from the game feature.

## AI Integration Rules

Do not connect OpenAI during the foundation phase.

Prepare architecture only.

Create:

- AI referee domain interfaces
- Mock AI referee service
- Prompt template placeholders
- AI panel placeholder widget

The AI layer must be optional and replaceable.

The game must work without AI.

## Legal / Asset Rules

Do not include copyrighted anime images in the repository.

Use:

- Placeholder images
- Original assets
- Abstract silhouettes
- Public domain assets
- Self-created assets

Known anime character names may be used only as sample data for private prototyping. For public portfolio release, prefer original anime-inspired characters or clearly marked placeholder data.

## Documentation Requirements

Maintain:

- `README.md`
- `docs/GAME_DESIGN.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DATA_MODEL.md`
- `docs/AI_AGENT_WORKFLOW.md`

When adding a major system, update documentation.

## Development Phases

### Phase 1 — Foundation

Goal:

- Project setup
- Folder structure
- Routing
- Theme
- Placeholder screens
- Assets structure
- Initial docs
- Initial Skills

### Phase 2 — Local Data

Goal:

- JSON files
- Models
- Data sources
- Repositories
- Character library

### Phase 3 — Game Engine

Goal:

- Match logic
- Turns
- Guesses
- Traits
- Hints
- Tests

### Phase 4 — Local Multiplayer

Goal:

- Two-player local flow
- Secret selection
- Turn transition
- Match play
- Result screen

### Phase 5 — UI Polish

Goal:

- Premium mobile UI
- Animated cards
- Tower view
- Visual feedback

### Phase 6 — Flame Layer

Goal:

- Flame board
- Effects
- Particles
- Card animations

### Phase 7 — AI-Ready Layer

Goal:

- AI referee mock
- Prompt templates
- AI explanation panel

### Phase 8 — Online Multiplayer

Goal:

- Room system
- Realtime sync
- Remote match state

## How Agents Should Work

Before coding:

1. Read `README.md`.
2. Read `AGENTS.md`.
3. Check relevant Skill in `skills/`.
4. Inspect current folder structure.
5. Make the smallest coherent change.
6. Add or update tests when logic changes.
7. Update documentation if the change introduces a new system.

## What Not To Do

Do not:

- Build the whole game in one PR.
- Mix UI and game rules.
- Put all code in `main.dart`.
- Hardcode all characters in widgets.
- Add online multiplayer before local mode works.
- Add OpenAI calls before the AI abstraction exists.
- Add copyrighted images.
- Ignore the Skills folder.
- Remove documentation without replacing it.

## First Requested Task For Agent

Initialize the Flutter + Flame project foundation for Anime Deduction Tower.

Create the base folder structure, documentation files, placeholder screens, theme system, routing, local asset folders, sample JSON data files, and empty/skeleton domain classes and services.

Do not implement full gameplay yet.

Focus on structure, maintainability, and future scalability.
