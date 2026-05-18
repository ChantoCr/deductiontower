# Architecture

## Overview

Anime Deduction Tower uses feature-first clean architecture.

The main goal is to separate:

- Game rules
- Data loading
- UI
- Flame visuals
- AI integration

The architecture must also keep two match concepts explicit:

- the shared character pool available for guessing
- the no-lives end conditions: correct trait guess or surrender

---

## Layers

### Domain

Contains business logic and pure Dart entities.

Examples:

- GameMatch
- Player
- Turn
- Guess
- TraitCategory
- GameEngine
- TraitFilterEngine
- MatchRulesEngine

Domain must not import Flutter.

### Data

Responsible for:

- JSON parsing
- Local data sources
- Repository implementations
- Future API integrations

### Presentation

Responsible for:

- Flutter screens
- Widgets
- Riverpod controllers
- User interaction
- Character pool browsing/search UI

### Flame Board

Responsible for:

- Visual board rendering
- Animations
- Card effects
- Particles

Flame does not decide game rules.

---

## State Flow

```txt
UI action
  ↓
Controller
  ↓
GameEngine / Domain Service
  ↓
Updated Match State
  ↓
Riverpod Provider
  ↓
UI / Flame Board
```

Character pool search can stay in presentation state, but the authoritative pool membership must come from match/domain state.

## Data Flow

```txt
JSON files
  ↓
Local Data Source
  ↓
Models
  ↓
Repository
  ↓
Domain Entities
  ↓
Catalog Validation
  ↓
Trait Filtering
  ↓
Character Pool Construction
  ↓
Game Engine
```

## AI Flow

Future:

```txt
Game State Summary
  ↓
AI Referee Service
  ↓
Repository Interface
  ↓
OpenAI / Mock Service
  ↓
AI Hint / Explanation
  ↓
UI Panel
```

AI prompts may later receive the visible character pool, but AI must not determine official win/loss state.

## Dependency Rule

Outer layers can depend on inner layers.

Allowed:

- `presentation → domain`
- `data → domain`

Avoid:

- `domain → presentation`
- `domain → Flutter`
- `domain → Flame`

## Testing Strategy

Domain services should be unit tested first.

Important services:

- TraitFilterEngine
- TraitCatalogValidator
- GameEngine
- HintEngine
- MatchRulesEngine

Important behaviors:

- pool generation
- character guess validation
- trait guess resolution
- surrender resolution
- winner detection

## MVP Architecture Goal

The MVP should prove that the game works locally with clean, testable logic before adding AI or online multiplayer.
