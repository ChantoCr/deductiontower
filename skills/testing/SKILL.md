# Testing Skill

## Purpose

Use this Skill when writing or modifying tests, especially for game logic, data validation, and domain services.

---

## Testing Priority

The most important tests are for pure Dart game logic.

The game engine must be testable without Flutter widgets and without Flame.

---

## Test First Areas

Prioritize tests for:

- Trait filtering
- Character pool generation
- Character guess validation
- Category guess validation
- Turn switching
- Surrender handling
- Hint generation
- Winner detection
- Invalid data handling

---

## Suggested Test Files

```txt
test/features/game/game_engine_test.dart
test/features/game/trait_filter_engine_test.dart
test/features/game/hint_engine_test.dart
test/features/game/match_rules_engine_test.dart
test/features/characters/character_repository_test.dart
```

## Fixture Data

Use fixtures:

- `test/fixtures/characters_fixture.json`
- `test/fixtures/tags_fixture.json`
- `test/fixtures/categories_fixture.json`

Fixtures should be small and predictable.

## Example Test Cases

### Trait Filtering

Given:

- Trait: `black_hair`
- Characters: Goku, Naruto, Sasuke

Expected:

- Goku and Sasuke match
- Naruto does not match

### Character Pool

Given:

- Selected categories and characters

Expected:

- the generated pool contains only allowed characters
- the pool is preserved in match state

### Character Guess

Given:

- Opponent trait: `black_hair`
- Guess: Sasuke

Expected:

- Guess is correct if Sasuke has `black_hair`

### Category Guess

Given:

- Opponent secret trait: `black_hair`
- Guess: `villain`

Expected:

- Guess is incorrect

### Surrender

Given:

- Current player surrenders

Expected:

- Match status becomes completed
- Opponent becomes winner
- End reason is `surrender`

### Turn Switching

Given:

- Current player: `player_one`

Expected after valid action:

- Current player becomes `player_two`

## Testing Rules

- Keep tests readable.
- Use clear arrange/act/assert structure.
- Avoid testing implementation details.
- Test behavior.
- Do not depend on real assets.
- Do not depend on network.
- Do not depend on Flame rendering.

## What Not To Test Initially

Do not prioritize:

- Widget tests
- Golden tests
- Animation tests
- Flame rendering tests
- Online multiplayer tests

Those can come later.

## Anti-Patterns

Avoid:

- Testing private methods directly
- Huge fixture files
- Network calls in tests
- Tests that depend on timing/animations
- Mixing UI tests with game engine tests
- Writing tests around a lives system that no longer exists
