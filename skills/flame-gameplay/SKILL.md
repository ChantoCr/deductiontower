# Flame Gameplay Skill

## Purpose

Use this Skill when working with Flame components, game canvas, visual effects, card animations, tower rendering, and game-like feedback.

---

## Role of Flame

Flame is used only for visual and interactive game presentation.

Flame should not own the core match rules.

Flame receives game state from the Flutter/Riverpod/game domain layer and renders it.

---

## Allowed Responsibilities

Flame can handle:

- Tower layout
- Character card movement
- Card reveal animation
- Correct guess effects
- Wrong guess effects
- Background particles
- Energy glow effects
- Visual transitions
- Tap/click interactions forwarded to controllers
- Character pool visual emphasis or highlighting

---

## Forbidden Responsibilities

Flame must not decide:

- Who wins
- Whether a trait is valid
- Whether a guess is correct
- Whether a player surrendered
- Which player is current
- How hints are generated
- Which characters belong to the official pool

Those belong in the domain game engine.

---

## Suggested Flame Structure

```txt
features/flame_board/
  game/
    deduction_tower_game.dart

  components/
    tower_component.dart
    character_card_component.dart
    energy_background_component.dart
    particle_burst_component.dart

  effects/
    reveal_effect.dart
    correct_guess_effect.dart
    wrong_guess_effect.dart
```

## Visual Style

The Flame board should feel:

- Dark
- Neon
- Smooth
- Premium
- Anime-inspired but not cluttered

Recommended effects:

- Purple/blue glow
- Orange accent on active turn
- Green flash for correct guess
- Red pulse for wrong guess
- Floating cards
- Subtle background particles

## Integration With Flutter

Flutter owns:

- Navigation
- Menus
- Dialogs
- Input forms
- Match state
- Controllers
- Character pool search UI

Flame owns:

- Animated board
- Visual feedback
- Game-like presentation

Use Flame inside Flutter screens when needed.
Do not mix prototype import tooling or catalog-promotion logic into Flame code.

## MVP Flame Scope

Do not start with complex Flame logic.

Initial Flame board can be a placeholder with:

- Background
- Tower component
- Static character cards
- Simple reveal animation

Add advanced particles later.

## Anti-Patterns

Avoid:

- Putting game rules in Flame components
- Overusing Flame for regular app screens
- Making Flame required for all UI
- Adding visual effects before game logic works
- Complex physics for a card-based deduction game
