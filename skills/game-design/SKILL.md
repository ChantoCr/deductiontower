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
3. The system generates a shared character pool.
4. Players browse the pool or search for a name.
5. Players take turns guessing characters.
6. Guesses return correct/incorrect feedback.
7. Players use deduction to infer the hidden trait.
8. A player wins by correctly guessing the opponent's secret trait.

---

## MVP Rules

For the first playable version:

- Two local players
- One device
- Each player has one secret trait
- Each player has a generated list of valid characters
- The match has one shared guessable character pool
- Players alternate turns
- Players can browse/search the pool during their turn
- Players can guess a character
- Players can guess the opponent's trait
- Players can surrender
- Players have limited hints
- The first player to guess the opponent's trait wins

---

## Recommended Match Settings

Default MVP settings:

```txt
Players: 2
Mode: Local
Lives: None
Hints: 2
Turn timer: Disabled initially
Character pool size: 8 to 12
Difficulty: Easy/Medium
```

## Turn Actions

Supported actions:

- Browse character pool
- Search character names
- Guess character
- Request hint
- Guess secret trait
- Pass turn
- Surrender

Future actions:

- Eliminate trait
- Lock suspicion
- Challenge
- Use special card
- Ask AI referee

## Win Conditions

A player wins when:

- They correctly guess the opponent's secret trait.
- The opponent surrenders.

A player loses when:

- They surrender.
- The opponent correctly guesses their secret trait.

Incorrect guesses should cost tempo or information, not lives.

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
- How large or noisy the current pool feels

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
- The character pool should be readable and searchable.
- Imported external characters must still be curated before they become live gameplay content.
- The game should be playable without AI.
- AI should enhance the experience, not replace the core game.

## Anti-Patterns

Avoid:

- Traits that are too subjective.
- Categories with only one character.
- A character pool so large that browsing feels tedious.
- Categories that require obscure lore in easy mode.
- Too much text on the main game screen.
- Overcomplicated rules in the MVP.
- Any life-based elimination rule.
