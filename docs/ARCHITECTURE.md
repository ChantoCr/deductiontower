# Architecture

## Overview

Anime Deduction Tower uses feature-first clean architecture.

The main goal is to separate:

- Game rules
- Data loading
- UI
- Flame visuals
- AI integration
- Optional AI opponent automation

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

## External Import Flow

```txt
MAL/Jikan-style sample character data
  ↓
Optional anime/series sample data
  ↓
External import datasource
  ↓
Enrichment metadata
  ↓
Duplicate/tag validation + structured report
  ↓
Tag suggestion helper from about text
  ↓
Transformer
  ↓
characters_import_preview.json
  ↓
characters_import_review_queue.json
  ↓
manual approval asset
  ↓
Promotion service + structured report + approved-only filter
  ↓
characters_curated_promotion_preview.json
```

Important rules:
- preview import files must remain separate from curated runtime assets until explicitly reviewed
- review queue data should be treated as approval tooling, not live runtime content
- promotion preview should only include imported characters explicitly marked approved

## AI Flow

Future / current foundation:

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

```txt
Match State + Public History
  ↓
AI Opponent Service
  ↓
Difficulty Profile (easy / standard / hard)
  ↓
Mock AI Turn Decision + Public Reasoning Summary
  ↓
Game Engine Resolution
  ↓
Updated Match State
  ↓
AI-specific setup / live / result presentation cards
```

AI prompts may later receive the visible character pool, but AI must not determine official win/loss state. Even in player-vs-AI mode, final rule resolution still belongs to the game engine.

Current player-vs-AI presentation also keeps a clear separation between:
- AI decision-making data stored as public turn notes
- core game-engine correctness and match-end resolution
- Flutter widgets that explain AI posture, reasoning, and result analytics

## Online Multiplayer Foundation Flow

Current online multiplayer work is still a foundation preview, not a live backend.

```txt
Online lobby UI
  ↓
OnlineLobbyController
  ↓
OnlineRoomRepository interface
  ↓
OnlineRoomRepositoryImpl
  ↓
OnlineRoomDataSource
  ↓
Mock / Firebase-preview / Supabase-preview datasource adapter
  ↓
Preview room session state
  ↓
RemoteMatchBootstrapService
  ↓
RemoteMatchBootstrapPayload
  ↓
RemoteMatchPublicState + RemotePlayerPrivateState + OnlinePlayerAction
  ↓
Room summary / next-steps UI
```

Important rules:
- room creation and join-code UX can be built now without moving official match rules out of the game domain
- realtime networking can later replace the current preview datasource adapter behind the same repository boundary
- mock preview datasource simulation can mimic remote join/ready events now, but it must remain clearly separate from real backend sync
- remote match bootstrap, public-state, private-state, and action contracts should stay explicit instead of being mixed into ad-hoc UI maps
- remote room-to-match startup should flow through the bootstrap service instead of being assembled separately in widgets/controllers
- remote match sync should eventually feed the existing game engine instead of duplicating rule resolution in the online layer
- lobby state should model participants, readiness, and room phase explicitly so backend swap work does not depend on ad-hoc UI strings
- backend-target selection belongs in the data/presentation boundary, not in the game domain

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
- protected local turn reveal flow
- import duplicate detection
- import tag validation
- curated promotion preview generation

## MVP Architecture Goal

The MVP should prove that the game works locally with clean, testable logic before adding AI or online multiplayer.
