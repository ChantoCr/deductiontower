# Anime Deduction Tower

**Anime Deduction Tower** is a Flutter + Flame mobile deduction game where players discover hidden anime-inspired character traits through turn-based guessing, tag filtering, and strategic reasoning.

The project is designed as a professional portfolio piece focused on mobile game development, clean architecture, game logic, data modeling, UI/UX polish, and future AI-assisted gameplay.

---

## Overview

Anime Deduction Tower is a two-player deduction game inspired by anime character knowledge.

Each player selects or receives a secret trait category. The opponent does not know that category. Players take turns guessing characters, reviewing the shared character pool, and trying to infer the hidden trait from correct and incorrect feedback.

The match has **no life system**.
A match ends only when:

- a player correctly guesses the opponent's secret trait, or
- a player surrenders.

Example:

- Player 1 secret trait: Black Hair
- Shared character pool: Shadow Ninja, Ember Ronin, Blaze Guardian, Abyss Duelist, Storm Samurai
- Player 2 browses the pool, guesses characters, and deduces the hidden common trait.

The game combines:

- Turn-based logic
- Character tag filtering
- Hidden information
- Strategic deduction
- Shared character pool browsing and search
- Mobile-first UI
- Game-like visual effects with Flame
- Future AI referee and online multiplayer support

---

## Core Concept

Two players enter a match.

Each player has a secret trait, such as:

- Black hair
- Villain
- Uses sword
- Human
- Has transformation
- Uses fire
- Main protagonist
- Non-human
- Master/mentor
- Has tragic past

The game prepares a shared **character pool** for the match. During a turn, players can browse that pool or search for names before making a character guess or a final trait guess.

Character guesses give information, but they do not remove lives because the game does not use lives. The decisive moment is the final trait guess or a surrender.

A player wins by correctly identifying the opponent's hidden trait.

---

## Main Features

### MVP Features

- Local two-player mode on one device
- Secret trait selection
- Shared character pool generation
- In-match character pool browsing
- Character name search inside the pool
- Tap-to-autofill character guessing from the pool
- Turn-based guessing
- Character guess validation
- Category guess validation
- Private hint flow
- Protected pass-the-device turn reveal flow
- Surrender action
- Guess history
- Result timeline screen
- Editable setup for player names and hints
- Local JSON data source
- Clean game engine with unit tests

### Planned Features

- AI referee
- AI-generated hints
- Online rooms with invite codes
- Realtime room sync and remote match state
- Player profiles
- Match statistics
- Achievements
- Daily challenge mode
- Custom category editor
- Character collection system
- Ranked/casual modes
- Advanced animations using Flame

---

## Tech Stack

### Core

- Flutter
- Dart
- Flame
- Riverpod
- GoRouter

### Data

- Local JSON files for MVP
- Hive or SharedPreferences for local persistence
- Firebase or Supabase planned for online multiplayer
- Optional prototype import path for external anime datasets after transformation

### Future AI

- OpenAI API
- AI referee service
- AI hint generation
- AI strategic explanations
- AI opponent mode

---

## Architecture

The project follows a feature-first clean architecture approach.

Each major feature is divided into:

- `data`
- `domain`
- `presentation`

The game logic must remain independent from Flutter UI and Flame rendering.

The most important rule:

> The game engine should be testable without rendering any UI.

---

## Main Systems

### Character Tagging System

Every character is modeled with structured tags.

Example:

```json
{
  "id": "goku",
  "name": "Goku",
  "anime": "Dragon Ball",
  "tags": [
    "black_hair",
    "saiyan",
    "protagonist",
    "uses_ki",
    "has_transformation"
  ],
  "difficulty": "easy",
  "popularity": 10
}
```

### Trait Filtering Engine

Filters all characters based on the selected secret trait.

Example:

- Trait: `black_hair`
- Result: `Goku, Vegeta, Sasuke, Madara, Levi`

### Character Pool System

Each match uses a shared character pool that players can inspect while guessing.

Responsibilities:

- define which characters are available in the current match
- allow browsing during the turn
- support fast name search inside the pool
- keep pool state separate from UI widgets

### Turn-Based Match Engine

Controls:

- Current player
- Guess validation
- Character pool state
- Hints
- Match status
- Winner
- End reason
- Turn history

A match ends only on:

- correct secret trait guess
- surrender

### Hint Engine

Generates limited hints without revealing the secret trait directly.

Example hints:

- The trait is related to appearance.
- The trait appears across multiple anime.
- The trait is not related to power.
- The trait is medium difficulty.

### Flame Board Layer

Responsible only for visual and interactive effects:

- Tower animation
- Card reveal
- Correct guess effects
- Wrong guess effects
- Particle effects
- Energy background

Flame must not contain core business logic.

---

## Project Structure

```txt
lib/
  app/
  core/
  features/
    characters/
    game/
    flame_board/
    ai_referee/
    profile/
    settings/
    home/
  shared/
```

See `docs/ARCHITECTURE.md` for a deeper explanation.

---

## Development Philosophy

This project is not only a game prototype. It is a portfolio-level software product.

Priorities:

- Clean architecture
- Testable game logic
- Strong mobile UI/UX
- Clear data modeling
- Professional documentation
- AI-agent-friendly workflow
- Scalable roadmap

---

## AI Agent Workflow

This project uses:

- `AGENTS.md`
- Specialized Skills
- AI-assisted development with Pi / coding agents

The README is for humans.
The `AGENTS.md` is for agents.
The Skills are for specialized execution guidance.

Agents must follow the architecture, folder structure, naming conventions, and roadmap defined in this repository.

---

## Roadmap

### Phase 0 — Product Definition

- Game concept
- Rules
- Modes
- Data model
- Architecture
- `AGENTS.md`
- Skills

### Phase 1 — Flutter Foundation

- Flutter project setup
- Flame installation
- Riverpod setup
- GoRouter setup
- Theme system
- Folder structure
- Splash and Home screens

### Phase 2 — Local Data Model

- Character entity
- Trait entity
- Category entity
- Local JSON loading
- Repositories
- Fixture data

### Phase 3 — Core Game Engine

- Match model
- Player model
- Turn model
- Character pool model
- Guess validation
- Trait filtering
- Hint system
- Win/surrender logic
- Unit tests

### Phase 4 — Local Multiplayer

- Game setup flow
- Secret category selection
- Turn transition screen
- Match screen
- Character pool browser/search
- Result screen

### Phase 5 — Premium UI

- Character cards
- Tower view
- Guess history
- Animated buttons
- Neon/dark anime-inspired visual style

### Phase 6 — Flame Visual Layer

- Animated tower
- Card reveal effects
- Correct/wrong feedback
- Particle effects

### Phase 7 — AI-Ready Layer

- AI referee abstraction
- Mock AI service
- Prompt templates
- Future OpenAI integration

### Phase 8 — Online Multiplayer

- Create room
- Join with code
- Realtime match sync
- Online state management

---

## Legal / Content Safety Note

For public portfolio use, avoid using copyrighted anime images without permission.

The MVP should use:

- Text-only character cards
- Placeholder silhouettes
- Original anime-inspired characters
- Public-domain or self-created assets

Known anime names can be used only for private prototyping and should be replaced or abstracted before public/commercial release.

---

## How to Run

```bash
flutter pub get
flutter run
```

## Testing

Run all tests:

```bash
flutter test
```

Core game logic must be covered with unit tests.

---

## External Anime Data Option

We evaluated the `myanimelist-jikan-database` repository as a possible prototype source for anime, manga, character, and people data.

Short answer:
- yes, it can work for **private prototype imports**
- no, it is **not game-ready as-is** for our deduction system

Why:
- it provides large identity datasets
- but our game still needs curated tags, categories, difficulty, and legal-safe release decisions

See:
- `docs/EXTERNAL_ANIME_DATA.md`

Prototype import preview files now live under:
- `assets/data/imports/`

That import folder now supports:
- raw MAL/Jikan-style sample character data
- optional MAL/Jikan-style sample anime data for series lookup
- enrichment metadata with aliases/source reference/import notes
- transformed character preview output
- import review queue output
- explicit import approval asset for reviewed-only promotion
- curated promotion preview output
- duplicate source-id, duplicate transformed-id, and tag validation in the import pipeline
- lightweight tag suggestions from external about text

---

## Portfolio Positioning

This project demonstrates:

- Mobile app development
- Game architecture
- Turn-based logic
- Data-driven design
- Flutter + Flame integration
- Clean architecture
- AI-assisted development workflow
- Testable business logic
- UI/UX polish

---

## Status

Foundation, local data, core match flow, protected local multiplayer turns, and prototype external character import tooling are all saved.

Current implemented state includes:
- no-lives rule set
- shared character pool generation
- tap-to-autofill character guesses
- trait guess, hint, surrender, and result flow
- protected turn reveal to avoid stale secret leaks
- editable setup for names and hints
- full approved imported catalog merged into `assets/data/characters.json`
- full tag-based secret selection through `assets/data/categories.json`
- external MAL/Jikan-style import preview, review queue, approval, and curated promotion preview assets
- structured import/promotion validation reporting plus optional anime-series lookup support
- reviewed-only promotion filtering through an explicit approval asset
- expanded tag catalog for richer imported-character descriptors like hero, young, student, leader, strong, fast, muscular, super powers, super saiyan, fire user, ice user, lightning user, assassin, mentor, rival, strategist, blond hair, brown hair, red hair, blue hair, green hair, purple hair, gun user, cyborg, psychic, pink hair, water user, and more
- character library name/series search plus imported-character badge support for easier verification in-app
- premium gameplay-facing UI passes for home, setup, secret selection, protected handoff, match, and result screens
- player-vs-AI foundation with setup-mode selection, auto-assigned AI hidden tags, and mock automated AI public turns
- first AI difficulty layer with easy/standard/hard behavior tuning, stronger public-probe scoring, and clearer AI-specific gameplay/result microcopy
- fuller Play vs AI presentation pass with setup-time opponent profiling, in-match AI duel intel, persisted public reasoning notes, richer AI turn-complete dialogs, and result-screen AI performance analytics
- online multiplayer foundation preview with a dedicated room-code lobby screen, mock room creation/join architecture, normalized join-code flow, and repository/controller boundaries ready for future realtime backend integration
- online room UX polish with host-vs-guest path switching, clearer readiness messaging, formatted room-code presentation, and one-tap room-code copy flow
- backend-ready online datasource/repository abstraction with mock, Firebase-preview, and Supabase-preview adapters that preserve the same lobby contract before realtime sync is wired
- explicit remote online match contract models for bootstrap payloads, public match state, private player state, and queued player actions ahead of Firebase-backed room/match syncing
- pure Dart remote match bootstrap service that converts a ready online room plus secret selections into initial payload/public/private match state without moving official rules into the UI
- mock remote lobby event simulation for guest join and remote ready toggling so pre-backend room previews can mimic a more realistic second-device lifecycle
- remote-ready online lobby model expansion with participant-level session snapshots, local-ready state handling, and room phases for waiting, ready-check, and sync handoff preview
- fixed bottom action areas so secret-tag selection and in-match submission no longer require scrolling to the end of the screen
- hidden secret-tag reminder flow with icon-based reveal for safer local multiplayer privacy
- animated correct/wrong feedback dialogs plus protected reveal micro-animations
- wide-layout optimization for match and result screens
- character pool browser improvements for large rosters, including search, searchable series-filter chips, difficulty filters, and staged guess confirmation
- animated winner celebration banner plus richer result-screen replay flow
- filterable and collapsible public match timelines in both live match and result views
- broader hover/tap micro-feedback across cards, pool rows, and primary buttons
- visual consistency pass for protected handoff and secret-tag selection with richer stage tracking and micro-animations
- shared match/result timeline mapping helper plus winner-vs-loser comparative result stats
- shared match lookup helpers for winner/loser, trait labels, character labels, and end-reason wording
- shared setup/transition/match microcopy helpers for more consistent status wording
- upgraded secret reminder and category-guess dialog motion with staged confirmation and richer reveal/hide feedback
- polished shared dialogs and utility panels, plus an optional Flame-backed result celebration backdrop and a safe Flame-backed tower preview behind the existing UI flow
- privacy-safe pool browser reset between turns so search/filter text does not leak to the next player on the same device

If the app is already running after JSON asset updates, use a full restart so the refreshed character catalog is reloaded.

The runtime catalog now includes the original starter roster plus every currently approved external-import character batch. The live runtime catalog currently contains 1276 characters. The tag catalog currently contains 40 tags, and the secret-tag selection flow now exposes every playable tag in the current catalog. The import preview currently contains 1264 records, the approval asset currently contains 1263 reviewed entries, and the curated promotion preview currently contains 1276 total characters. The current saved gameplay/UI state now includes the earlier premium gameplay retake passes plus animated result celebration, filterable/collapsible timelines, searchable series chips in the pool, shared presentation helpers, Flame-backed presentation-only polish, and stronger privacy-safe local multiplayer browser reset behavior.

For the next handoff, see:
- `docs/PR13_HANDOFF.md`
- `NEXT_CHAT_PROMPT.md`
