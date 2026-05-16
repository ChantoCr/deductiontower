# Game Design Skill

## Purpose

Use this Skill when working on the rules, modes, player experience, balance, difficulty, win conditions, or core gameplay loop of Anime Deduction Tower.

---

## Game Identity

Anime Deduction Tower is a mobile deduction game where players guess hidden character traits through turn-based reasoning.

The game should feel:

- Strategic
- Social
- Fast to understand
- Hard to master
- Fun for anime fans
- Clean enough for casual players

---

## Core Gameplay Loop

1. Players enter a match.
2. Each player receives or selects a secret trait.
3. The system generates valid characters for each trait.
4. Players take turns guessing characters.
5. Guesses return correct/incorrect feedback.
6. Players use deduction to infer the hidden trait.
7. A player wins by correctly guessing the opponent's secret trait.

---

## MVP Rules

For the first playable version:

- Two local players
- One device
- Each player has one secret trait
- Each player has a generated list of valid characters
- Players alternate turns
- Players can guess a character
- Players can guess the opponent's trait
- Players have limited hints
- The first player to guess the opponent's trait wins

---

## Recommended Match Settings

Default MVP settings:

```txt
Players: 2
Mode: Local
Lives: 3
Hints: 2
Turn timer: Disabled initially
Characters per tower: 5 to 8
Difficulty: Easy/Medium
```

## Turn Actions

Supported actions:

- Guess character
- Request hint
- Guess secret trait
- Pass turn

Future actions:

- Eliminate trait
- Lock suspicion
- Challenge
- Use special card
- Ask AI referee

## Win Conditions

A player wins when:

They correctly guess the opponent's secret trait.

A player may lose when:

- They run out of lives.
- They incorrectly guess the final trait too many times.
- They abandon the match.

## Hint Rules

Hints should help without revealing the answer.

Good hints:

- The trait is related to appearance.
- The trait is related to power.
- The trait appears across multiple anime.
- The trait is considered easy.
- The trait is not related to origin.

Bad hints:

- The trait is black hair.
- The answer starts with B.
- Goku is included because of his hair.

## Difficulty Design

Trait difficulty can be based on:

- How obvious the trait is
- How many characters share it
- How popular the characters are
- Whether the trait is visual, story-based, or lore-based

Easy examples:

- Black hair
- Villain
- Protagonist
- Uses sword

Medium examples:

- Has transformation
- Mentor
- Non-human
- Uses spiritual energy

Hard examples:

- Has died and returned
- Was manipulated
- Has inherited power
- Has hidden identity

## Design Principles

- The player should always feel they are learning.
- The game should reward anime knowledge and deduction.
- Wrong guesses should still provide useful information.
- Traits must be fair and not too subjective.
- Categories should be curated carefully.
- The game should be playable without AI.
- AI should enhance the experience, not replace the core game.

## Anti-Patterns

Avoid:

- Traits that are too subjective.
- Categories with only one character.
- Categories that require obscure lore in easy mode.
- Too much text on the main game screen.
- Overcomplicated rules in the MVP.
