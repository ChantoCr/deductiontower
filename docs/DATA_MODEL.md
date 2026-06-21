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
- controlType

### Notes

- `validCharacterIds` represents characters that match the player's secret trait.
- `controlType` distinguishes human-controlled and AI-controlled participants without moving match rules into the UI.
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

## Remote Online Public Event

Represents a canonical public timeline event persisted after official queued-action resolution.

Fields:

- eventId
- roomCode
- matchId
- actionId
- participantId
- participantName
- actionType
- status
- shortLabel
- actionSummary
- resultSummary
- submittedValueLabel
- resultingMatchVersion
- createdAt
- publishedAt
- resolutionSource

Notes:

- this contract is public-facing and should not contain private hint text
- explicit action docs still keep transport / resolver metadata
- future online match and result timelines should prefer this canonical public event payload over rebuilding summaries in widgets

## External Import Models

### ExternalCharacterImportModel

Represents raw MAL/Jikan-style imported character identity data.

Fields:

- malId
- name
- nameKanji
- nicknames
- favorites
- about
- mainPicture
- url

### ExternalCharacterImportEnrichment

Represents manual gameplay enrichment added on top of raw imported identity data.

Fields:

- series
- animeMalId
- tags
- difficulty
- aliases
- sourceReference
- importNotes
- image

### ExternalAnimeImportModel

Represents optional MAL/Jikan-style anime metadata used to fill series labels more systematically.

Fields:

- malId
- title
- titleEnglish
- titleJapanese
- url

### CharacterImportApprovalEntry

Represents manual approval metadata used to decide which imported preview characters may appear in promotion preview output.

Fields:

- malId
- transformedId
- approvalStatus
- notes

### Import Review Output

The current prototype import pipeline generates or uses:

- `assets/data/imports/characters_import_preview.json`
- `assets/data/imports/characters_import_review_queue.json`
- `assets/data/imports/characters_import_approval.json`
- `assets/data/imports/characters_curated_promotion_preview.json`

Rules:

- imported preview data must validate tags against `assets/data/tags.json`
- duplicate source `mal_id` values must be reported
- transformed internal ids must be unique
- preview/review generation may include structured validation issues and suggested tags
- promotion preview must not conflict with curated runtime character ids
- promotion preview should include only explicitly approved imported characters
- promotion preview is review output, not automatic runtime replacement
