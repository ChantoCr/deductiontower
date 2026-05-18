# Data Model

## Character

Represents a playable or guessable character.

```json
{
  "id": "shadow_ninja",
  "name": "Shadow Ninja",
  "series": "Original",
  "image": "assets/images/placeholders/shadow_ninja.png",
  "tags": [
    "black_hair",
    "ninja",
    "uses_sword"
  ],
  "difficulty": "medium",
  "popularity": 8
}
```

## CharacterTag

Represents a reusable trait.

```json
{
  "id": "black_hair",
  "label": "Black Hair",
  "type": "appearance",
  "difficulty": "easy"
}
```

## TraitCategory

Represents a secret playable category.

```json
{
  "id": "black_hair",
  "label": "Black Hair",
  "tagId": "black_hair",
  "difficulty": "easy",
  "minCharacters": 5,
  "hintType": "appearance"
}
```

## Catalog Validation

During loading, the app validates the local catalog before categories are shown to players.

Rules:

- Every category tag must exist in the tag catalog.
- Every character tag must exist in the tag catalog.
- Duplicate IDs should be treated as invalid data.
- A category must have at least `minCharacters` matching characters.
- Invalid categories should be filtered out of selection UI.

## GameMatch

Represents one match.

Fields:

- id
- playerOne
- playerTwo
- currentPlayerId
- characterPoolIds
- turns
- status
- winnerId
- endReason

### Notes

- `characterPoolIds` is the shared list of guessable characters visible during the match.
- `endReason` should distinguish at least `correctTraitGuess` and `surrender`.

## Player

Represents a match player.

Fields:

- id
- name
- secretTraitId
- validCharacterIds
- hintsRemaining

### Notes

- `validCharacterIds` represents characters that match the player's secret trait.
- There is no `lives` field because the game has no life system.

## Turn

Represents one player action.

Fields:

- id
- playerId
- actionType
- value
- wasCorrect
- createdAt

### Supported action types

- guessCharacter
- guessTrait
- requestHint
- surrender
- pass

## GuessResult

Represents the result of a guess.

Fields:

- isCorrect
- message
- guessedValue
- actionType
