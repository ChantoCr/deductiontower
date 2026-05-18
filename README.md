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
- Turn-based guessing
- Character guess validation
- Category guess validation
- Surrender action
- Guess history
- Hint system
- Result screen
- Local JSON data source
- Clean game engine with unit tests

### Planned Features

- AI referee
- AI-generated hints
- Play vs AI mode
- Online rooms with invite codes
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

Foundation plus local data work is in place.
The rules now target a no-lives match flow with surrender support and an in-match character pool browser/search experience.
