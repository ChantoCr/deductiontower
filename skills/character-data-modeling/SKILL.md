# Character Data Modeling Skill

## Purpose

Use this Skill when working with characters, tags, categories, JSON data, filtering, balancing, or data validation.

---

## Core Idea

The game is powered by structured data.

Characters have tags.  
Traits/categories match tags.  
The game filters characters based on selected traits.

Good data modeling is the heart of the game.

---

## Main Data Files

Use:

```txt
assets/data/characters.json
assets/data/tags.json
assets/data/categories.json
```

## Character Schema

Example:

```json
{
  "id": "shadow_ninja",
  "name": "Shadow Ninja",
  "series": "Original",
  "image": "assets/images/placeholders/shadow_ninja.png",
  "tags": [
    "black_hair",
    "ninja",
    "uses_sword",
    "rival",
    "has_tragic_past"
  ],
  "difficulty": "medium",
  "popularity": 8
}
```

Fields:

- `id`: stable unique identifier
- `name`: display name
- `series`: anime/series name or original universe
- `image`: optional asset path
- `tags`: list of tag IDs
- `difficulty`: easy, medium, hard
- `popularity`: 1 to 10

## Tag Schema

Example:

```json
{
  "id": "black_hair",
  "label": "Black Hair",
  "type": "appearance",
  "difficulty": "easy"
}
```

Fields:

- `id`: stable unique identifier
- `label`: display name
- `type`: appearance, power, origin, role, story, item, personality
- `difficulty`: easy, medium, hard

## Category Schema

Example:

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

Fields:

- `id`: category identifier
- `label`: category display name
- `tagId`: tag used for filtering
- `difficulty`: easy, medium, hard
- `minCharacters`: minimum valid characters required
- `hintType`: type used for hint generation

## Data Rules

- Every category must map to a valid tag.
- Every tag used by a character must exist in `tags.json`.
- Every category must have enough valid characters.
- Avoid subjective categories unless manually curated.
- Avoid duplicate IDs.
- Use snake_case IDs.
- Keep labels user-friendly.
- Do not use copyrighted images in public assets.

## Initial MVP Dataset

Start with:

- 20 to 30 characters
- 20 to 40 tags
- 10 to 15 categories

The first data set can use original anime-inspired characters to avoid copyright issues.

## Recommended Tag Types

- appearance
- power
- origin
- role
- story
- weapon
- personality
- series
- status

## Filtering Rule

A character matches a trait category if:

`character.tags` contains `category.tagId`

## Validation Ideas

Add tests or scripts later to validate:

- Missing tags
- Empty categories
- Duplicate IDs
- Categories with too few characters
- Invalid image paths
- Invalid difficulty values

## Anti-Patterns

Avoid:

- Free-text tags with inconsistent names
- Mixing Spanish and English IDs
- Hardcoding category logic in Dart
- Having a category with only one character
- Using images without permission
