# External Anime Data Evaluation

## Source Evaluated

Repository:
- `https://github.com/andreu-vall/myanimelist-jikan-database`

Status:
- The link works.
- The repository README states it is a scrape of the **MyAnimeList Jikan REST API internal database**.
- It includes datasets for:
  - anime
  - manga
  - characters
  - people
- License in the repository: **MIT**.

## What This Means for Anime Deduction Tower

This source can work for us as a **private prototype data source**, but it is **not game-ready as-is**.

Why it is useful:
- large character volume
- large anime/manga/person catalog
- popularity/favorites metadata exists
- enough raw material to seed a bigger prototype catalog
- can help replace tiny sample placeholders quickly during internal development

Why it is not enough by itself:
- our game needs **curated trait tags** for deduction gameplay
- our game needs **playable secret categories**
- our game needs **fair shared character pools**
- our game needs **difficulty balancing**
- public portfolio release should avoid copyrighted images/names unless legally safe and intentionally scoped

## Important Fit Assessment

### Good fit for
- private prototyping
- offline import and transformation
- internal content seeding
- popularity-aware sorting
- finding real anime character names for test scenarios

### Not a direct fit for
- public portfolio release without transformation
- direct runtime gameplay logic
- our final JSON schema without enrichment
- legal-safe public asset usage

## The Biggest Limitation

The cleaned character notebook shown in the repository reduces characters to fields like:
- `mal_id`
- `name`
- `name_kanji`
- `nicknames`
- `favorites`
- `about`
- `main_picture`
- `url`

That is useful metadata, but it does **not** directly provide the structured gameplay tags we need, such as:
- `black_hair`
- `villain`
- `uses_sword`
- `has_transformation`
- `mentor`

So this source can provide **character identity data**, but not the deduction layer by itself.

## Can We Add the Real Character List?

Yes — for the project **prototype flow**, we can start adding a real character list **now**.

Recommended approach:
1. keep the current small curated JSON for stable gameplay testing
2. add an **optional import pipeline** for external anime data
3. transform imported records into our internal schema
4. manually or semi-automatically add playable tags
5. export the transformed data back into local JSON files used by the app

### Best timing

Best next timing:
- **now for prototype import work**
- **after current core gameplay remains stable**
- **before public portfolio packaging**, do a content/legal cleanup pass

## Recommended Integration Strategy for Our Architecture

Do **not** plug this dataset straight into widgets.

Use this flow instead:

```txt
external source (Jikan/MAL dataset)
  ↓
import script / raw data source
  ↓
normalization layer
  ↓
internal character import model
  ↓
tag enrichment / category mapping
  ↓
curated local JSON export
  ↓
existing repositories + game engine
```

This keeps our game logic unchanged and preserves clean architecture.

## Adapted Mapping to Our System

### Source → Internal Character mapping

Suggested mapping:

| External field | Our internal use |
|---|---|
| `mal_id` | external reference id or imported source id |
| `name` | `Character.name` |
| `name_kanji` | optional aliases/metadata |
| `nicknames` | optional aliases/metadata |
| `favorites` | base input for `popularity` normalization |
| `about` | raw description for later tag extraction |
| `main_picture` | optional image source, prototype only |
| `url` | source attribution / debug reference |

### Required fields we still must create

For our real game schema, we still need to generate or curate:
- `id`
- `series`
- `tags`
- `difficulty`
- `popularity` normalized to our range

## Adapted Example for Anime Deduction Tower

External-style record:

```json
{
  "mal_id": 417,
  "name": "Sasuke Uchiha",
  "name_kanji": "うちはサスケ",
  "nicknames": ["Sasuke-kun"],
  "favorites": 50000,
  "about": "...",
  "main_picture": "https://...",
  "url": "https://myanimelist.net/character/..."
}
```

Adapted internal record for our project:

```json
{
  "id": "sasuke_uchiha",
  "name": "Sasuke Uchiha",
  "series": "Naruto",
  "image": null,
  "tags": [
    "black_hair",
    "rival",
    "uses_sword",
    "has_tragic_past"
  ],
  "difficulty": "medium",
  "popularity": 10
}
```

Important: the `tags`, `difficulty`, and normalized `popularity` are **our gameplay layer**, not provided directly by the dataset.

## Public Release Warning

Even if the repository license is MIT, that does **not automatically make all anime character names/images safe for public commercial or portfolio release** in the way we want for this project.

For our project:
- private prototype use: acceptable with caution
- public portfolio release: prefer original/anime-inspired characters or a fully reviewed subset
- external images should be avoided unless rights are clearly safe

## Recommended Project Decision

### Best short-term decision

Use this source as an **optional prototype import source** only.

### Best medium-term decision

Create a small importer that transforms selected records into:
- `assets/data/characters.json`
- `assets/data/tags.json`
- `assets/data/categories.json`

### Best long-term decision

Move toward a curated original dataset for the public-facing portfolio version.

## Current Prototype Import Layer

A first importer layer now exists in the project.

Code:
- `lib/features/characters/data/imports/models/external_character_import_model.dart`
- `lib/features/characters/data/imports/models/external_character_import_enrichment.dart`
- `lib/features/characters/data/imports/transformers/external_character_import_transformer.dart`

Prototype data files kept separate from curated gameplay JSON:
- `assets/data/imports/mal_jikan_characters_sample.json`
- `assets/data/imports/mal_jikan_character_enrichment_preview.json`
- `assets/data/imports/characters_import_preview.json`

This means the project can now:
1. read MAL/Jikan-style character records
2. apply a manual enrichment layer for series/tags/difficulty
3. transform them into our internal character schema
4. preview transformed output without touching the main curated runtime dataset

## Suggested Next Implementation Step

If you want to expand this source further, the best next code task is:

1. add a small import script or utility that reads raw external JSON
2. load enrichment mappings from JSON
3. export a larger transformed preview set automatically
4. manually review tags/categories before using them in live match generation

## Recommendation Summary

Yes, the source works for us **as a prototype data source**.

But:
- not as a direct final runtime source
- not without transformation
- not without gameplay tag enrichment
- not without legal/copyright review for public release
