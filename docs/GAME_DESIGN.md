# Game Design Document

## Game Title

Anime Deduction Tower

---

## High Concept

Anime Deduction Tower is a mobile deduction game where players identify hidden character traits by guessing characters, reading feedback, and reasoning through a shared character pool.

---

## Player Fantasy

The player feels like an anime strategist who uses character knowledge, deduction, memory, and logic to uncover the opponent's secret category.

---

## Core Loop

1. Start match.
2. Secret trait is selected.
3. Shared character pool is generated.
4. Player browses the pool or searches for a name.
5. Player guesses a character.
6. Game gives feedback.
7. Player updates their deduction.
8. Player attempts to guess the secret trait or chooses to surrender.
9. Winner is revealed.

---

## Main Modes

### Local Multiplayer

Two players use one device and pass the phone between turns.

### Play vs AI

A player competes against an AI opponent.

### Online Match

Two remote players join a shared room.

### Daily Challenge

The player solves one curated puzzle per day.

---

## MVP Mode

The first playable mode is local multiplayer.

---

## Secret Trait Examples

- Black hair
- Villain
- Protagonist
- Uses sword
- Uses fire
- Human
- Non-human
- Has transformation
- Has tragic past
- Mentor
- Rival
- Uses spiritual energy

---

## Match Settings

Default:

- Players: 2
- Hints: 2
- Lives: none
- Turn timer: off
- Character pool size: 8 to 12

---

## Player Actions

- Browse character pool
- Search character names in the pool
- Guess character
- Guess trait
- Request hint
- Pass turn
- Surrender

---

## Win Condition

A player wins by correctly guessing the opponent's secret trait.

---

## Lose Condition

A player loses when:

- they surrender, or
- the opponent correctly guesses their secret trait.

Incorrect guesses do not remove lives because the game has no life system.

---

## Design Goals

- Easy to understand
- Strategic over time
- Fun with friends
- Strong replayability
- Expandable categories
- AI-enhanced but not AI-dependent

---

## Design Risks

- Categories may feel unfair
- Some players may not know enough anime
- The character pool may feel too large or too small
- Too many tags may make the game confusing
- Copyrighted assets need to be avoided for public release

---

## Solutions

- Use difficulty levels
- Start with easy categories
- Provide hints
- Keep the pool curated and readable
- Allow name search in the pool
- Use original placeholder characters
- Allow custom data expansion later
