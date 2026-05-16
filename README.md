# Anime Deduction Tower

**Anime Deduction Tower** is a Flutter + Flame mobile deduction game where players discover hidden anime-inspired character traits through turn-based guessing, tag filtering, and strategic reasoning.

The project is designed as a professional portfolio piece focused on mobile game development, clean architecture, game logic, data modeling, UI/UX polish, and future AI-assisted gameplay.

---

## Overview

Anime Deduction Tower is a two-player deduction game inspired by anime character knowledge.

Each player selects or receives a secret trait category. The opponent does not know that category. Players take turns guessing characters and trying to infer the hidden trait based on correct and incorrect guesses.

Example:

- Player 1 secret trait: Black Hair
- Valid characters: Goku, Vegeta, Sasuke, Madara, Levi
- Player 2 must guess characters and deduce the hidden common trait.

The game combines:

- Turn-based logic
- Character tag filtering
- Hidden information
- Strategic deduction
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

The game generates a tower of characters that match each secret trait.

Players take turns guessing characters. Each guess gives information that helps the opponent deduce the secret trait.

A player wins by correctly identifying the opponent's hidden trait.

---

## Main Features

### MVP Features

- Local two-player mode on one device
- Secret trait selection
- Character tower generation
- Turn-based guessing
- Character guess validation
- Category guess validation
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

### Turn-Based Match Engine

Controls:

- Current player
- Guess validation
- Lives
- Hints
- Match status
- Winner
- Turn history

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
- Guess validation
- Trait filtering
- Hint system
- Win/loss logic
- Unit tests

### Phase 4 — Local Multiplayer

- Game setup flow
- Secret category selection
- Turn transition screen
- Match screen
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

Project planning and foundation phase.
