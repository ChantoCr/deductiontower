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

## GameMatch

Represents one match.

Fields:

- id
- playerOne
- playerTwo
- currentPlayerId
- turns
- status
- winnerId

## Player

Represents a match player.

Fields:

- id
- name
- secretTraitId
- validCharacterIds
- lives
- hintsRemaining

## Turn

Represents one player action.

Fields:

- id
- playerId
- actionType
- value
- wasCorrect
- createdAt

## GuessResult

Represents the result of a guess.

Fields:

- isCorrect
- message
- guessedValue
- actionType
