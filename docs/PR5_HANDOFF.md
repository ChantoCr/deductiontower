# PR5 Handoff — Runtime Merge + Batch 16 Staging

## Project

**Anime Deduction Tower**

Flutter + Flame deduction game with local multiplayer, shared character-pool gameplay, and an incremental MAL/Jikan-style import pipeline that feeds reviewed character batches into the live runtime catalog.

---

## Current Runtime Status

The app loads its live character catalog from:
- `assets/data/characters.json`

Current runtime catalog size:
- **1076 characters**

That runtime file now includes:
- original starter characters
- previously merged approved MAL/Jikan-style import batches
- the newly merged former staged 100-character batch led by ids like `shizune`, `charlotte_perospero`, `chojiro_sasakibe`, `king_vegeta`, `thirteen`, `remi`, `sekke_bronzazza`, `amane`, `dimo_reeves`, and `kanao_tsuyuri`

Important runtime note:
- if the app was already running while JSON assets changed, do a **full restart** so Flutter reloads the asset bundle

---

## Current Staged Promotion Status

There are **200 approved promoted characters staged but not yet merged into runtime**.

### Older staged 100-character batch
This is now the next batch waiting to be merged into runtime.

Representative ids from that staged batch:
- `rigurd`
- `vt`
- `knives_millions`
- `ryoma_terasaka`
- `henry_henderson`
- `renzou_shima`
- `sid_barrett`
- `iris`
- `sachiko_yagami`
- `rivalz_cardemonde`

Series coverage in that staged batch:
- That Time I Got Reincarnated as a Slime
- Cowboy Bebop
- Trigun
- Assassination Classroom
- Spy x Family
- Blue Exorcist
- Soul Eater
- Fire Force
- Death Note
- Code Geass: Lelouch of the Rebellion

### Newer staged 100-character batch
This newer staged batch was added in this chat.

Representative ids from that staged batch:
- `takuya_muramatsu`
- `diethard_ried`
- `hitoshi_demegawa`
- `iaian`
- `rinku`
- `robert_e_o_speedwagon`
- `totosai`
- `lisanna_strauss`
- `pochita`
- `akitaru_obi`

Series coverage in that staged batch:
- Assassination Classroom
- Code Geass: Lelouch of the Rebellion
- Death Note
- One Punch Man
- Yu Yu Hakusho
- JoJo's Bizarre Adventure
- Inuyasha
- Fairy Tail
- Chainsaw Man
- Fire Force

---

## What Was Completed In This Chat

### 1. Merged the approved older staged 100-character batch into runtime
This chat explicitly merged the older staged approved batch into:
- `assets/data/characters.json`

Runtime now contains **1076 characters**.

### 2. Performed another richer tag-review pass on the remaining staged backlog
This chat reviewed the current staged batch led by `rigurd` and added broader descriptor overlap where clearly justified.

Additional reviewed tags were added to **95 staged characters**.

### 3. Kept expanding character-level tag coverage
No additional global tag definition was required in this chat.

The project tag catalog remains at **40 tags**.

### 4. Staged another approved 100-character high-throughput batch
This chat staged another high-throughput approved batch through the normal raw import → enrichment → approval → preview → promotion flow.

No approval bypass was used.

### 5. Expanded staged series coverage again
The newly staged batch added or deepened cross-series support through:
- Assassination Classroom
- Code Geass: Lelouch of the Rebellion
- Death Note
- One Punch Man
- Yu Yu Hakusho
- JoJo's Bizarre Adventure
- Inuyasha
- Fairy Tail
- Chainsaw Man
- Fire Force

### 6. Kept the approval + promotion flow intact
After the asset updates, this chat regenerated:
- `characters_import_preview.json`
- `characters_import_review_queue.json`
- `characters_curated_promotion_preview.json`

### 7. Added new tooling for this cycle
New scripts added in this chat:
- `tool/review_batch15_staged_tag_expansion.py`
- `tool/update_large_import_and_tags_batch_16.py`

Previously added staged-tag review tooling remains available:
- `tool/review_recent_import_tag_expansion.py`
- `tool/review_current_staged_tag_expansion.py`
- `tool/review_remaining_staged_tag_expansion.py`
- `tool/review_batch12_staged_tag_expansion.py`
- `tool/review_batch13_staged_tag_expansion.py`
- `tool/review_batch14_staged_tag_expansion.py`

---

## Current Import Asset Counts

After regeneration:
- `assets/data/tags.json` contains **40** tags
- `assets/data/imports/mal_jikan_characters_sample.json` contains **1264** source character records
- `assets/data/imports/mal_jikan_character_enrichment_preview.json` contains **1264** enrichment entries
- `assets/data/imports/characters_import_preview.json` contains **1264** imported preview characters
- `assets/data/imports/characters_import_review_queue.json` contains **1264** review entries
- `assets/data/imports/characters_import_approval.json` contains **1263** approval entries
- `assets/data/imports/characters_curated_promotion_preview.json` contains **1276** total promoted characters in preview output

Known non-blocking review issue still present:
- `vegeta` keeps the existing `series_mismatch` note between enrichment series `Dragon Ball Z` and anime lookup `Dragon Ball`

Review queue issue summary:
- only **1** review entry currently has issues
- that single issue is the known non-blocking `series_mismatch` on `vegeta`

---

## Key Files

### Runtime catalog
- `assets/data/characters.json`
- `assets/data/tags.json`
- `assets/data/categories.json`

### Import assets
- `assets/data/imports/mal_jikan_characters_sample.json`
- `assets/data/imports/mal_jikan_anime_sample.json`
- `assets/data/imports/mal_jikan_character_enrichment_preview.json`
- `assets/data/imports/characters_import_approval.json`
- `assets/data/imports/characters_import_preview.json`
- `assets/data/imports/characters_import_review_queue.json`
- `assets/data/imports/characters_curated_promotion_preview.json`

### Import services / models
- `lib/features/characters/data/imports/services/external_character_import_preview_service.dart`
- `lib/features/characters/data/imports/services/external_character_tag_suggestion_service.dart`
- `lib/features/characters/data/imports/services/character_import_promotion_service.dart`
- `lib/features/characters/data/imports/services/character_import_promotion_importer.dart`
- `lib/features/characters/data/imports/models/character_import_approval_entry.dart`
- `lib/features/characters/data/imports/models/external_character_import_review_entry.dart`

### Character library UI
- `lib/features/characters/presentation/screens/character_library_screen.dart`
- `lib/features/characters/presentation/widgets/character_card.dart`
- `lib/features/characters/presentation/controllers/character_library_controller.dart`
- `lib/features/characters/domain/services/character_library_filter.dart`

### Tooling scripts
- `tool/generate_characters_import_preview.dart`
- `tool/generate_characters_import_review_queue.dart`
- `tool/generate_characters_curated_promotion_preview.dart`
- `tool/review_recent_import_tag_expansion.py`
- `tool/review_current_staged_tag_expansion.py`
- `tool/review_remaining_staged_tag_expansion.py`
- `tool/review_batch12_staged_tag_expansion.py`
- `tool/review_batch13_staged_tag_expansion.py`
- `tool/review_batch14_staged_tag_expansion.py`
- `tool/review_batch15_staged_tag_expansion.py`
- `tool/update_large_import_and_tags_batch.py`
- `tool/update_large_import_and_tags_batch_3.py`
- `tool/update_large_import_and_tags_batch_4.py`
- `tool/update_large_import_and_tags_batch_5.py`
- `tool/update_large_import_and_tags_batch_6.py`
- `tool/update_large_import_and_tags_batch_7.py`
- `tool/update_large_import_and_tags_batch_8.py`
- `tool/update_large_import_and_tags_batch_9.py`
- `tool/update_large_import_and_tags_batch_10.py`
- `tool/update_large_import_and_tags_batch_11.py`
- `tool/update_large_import_and_tags_batch_12.py`
- `tool/update_large_import_and_tags_batch_13.py`
- `tool/update_large_import_and_tags_batch_14.py`
- `tool/update_large_import_and_tags_batch_15.py`
- `tool/update_large_import_and_tags_batch_16.py`

---

## Validated Commands

Verified in this session:

```bash
flutter test
flutter analyze
dart run tool/generate_characters_import_preview.dart
dart run tool/generate_characters_import_review_queue.dart
dart run tool/generate_characters_curated_promotion_preview.dart
```

All passed at the end of the session.

---

## Recommended Next PR Scope

### PR5 — Continue MAL/Jikan Catalog Expansion In Approved Batches

Recommended next scope:

1. **Merge the current older staged 100-character approved preview batch into `assets/data/characters.json`**
2. **Then add another 100-character high-throughput staged batch**
3. **Continue the staged tag-review pass so the remaining backlog keeps richer overlap**
4. **Add new tags only when character identity clearly justifies them**
5. **Regenerate preview, review queue, and promotion preview**
6. **Keep tests and analysis green**
7. **Update docs and handoff counts again**
8. **If runtime JSON changes, remind the user to fully restart the app**

---

## Rules For The Next Chat

- Keep game logic pure Dart.
- Keep import logic in the data/import layer.
- Continue using the approval gate instead of bypassing validation.
- Keep broad tag expansion curated and justified.
- It is acceptable if some tags are only used by a small subset of characters.
- Do not auto-merge runtime data unless explicitly requested in the chat.
- After runtime JSON changes, remind the user to do a full app restart.

---

## Suggested Next Chat Prompt

```txt
Continue Anime Deduction Tower with PR5 in high-throughput mode.

Before coding, read:
- README.md
- AGENTS.md
- docs/ARCHITECTURE.md
- docs/DATA_MODEL.md
- docs/EXTERNAL_ANIME_DATA.md
- docs/PR5_HANDOFF.md
- NEXT_CHAT_PROMPT.md
- skills/flutter-architecture/SKILL.md
- skills/character-data-modeling/SKILL.md
- skills/testing/SKILL.md

Current status:
- the game has no lives
- shared character pool gameplay is already wired
- protected local turn reveal is implemented
- import preview, review queue, approval, and curated promotion preview pipelines already exist
- duplicate source mal_id detection is implemented
- duplicate transformed ids and tag validation are implemented
- structured import/promotion validation reports are implemented
- promotion tooling skips identical already-promoted imports as non-blocking
- Vegeta still has the known non-blocking `series_mismatch` review note
- the runtime catalog currently contains 1076 characters
- the tag catalog currently contains 40 tags
- there are two approved 100-character staged backlogs not yet merged into runtime
- the older staged backlog is led by ids like `rigurd`, `vt`, `knives_millions`, `ryoma_terasaka`, `henry_henderson`, `renzou_shima`, `sid_barrett`, `iris`, `sachiko_yagami`, and `rivalz_cardemonde`
- the newer staged backlog is led by ids like `takuya_muramatsu`, `diethard_ried`, `hitoshi_demegawa`, `iaian`, `rinku`, `robert_e_o_speedwagon`, `totosai`, `lisanna_strauss`, `pochita`, and `akitaru_obi`
- `characters_import_preview.json` currently contains 1264 imported preview records
- `characters_curated_promotion_preview.json` currently contains 1276 total promoted preview records

Do this exact scope:
1. merge the older staged 100-character approved preview batch into `assets/data/characters.json`
2. then add another 100-character high-throughput staged batch
3. keep doing a richer tag review pass for the staged backlog
4. add new tags only when clearly justified
5. regenerate preview, review queue, and promotion preview
6. keep tests and analyze green
7. update `README.md`, `docs/PR5_HANDOFF.md`, and `NEXT_CHAT_PROMPT.md` with the new counts/state
8. remind the user to fully restart the app after the runtime JSON change

Rules:
- Keep game logic pure Dart
- Keep import logic in the data/import layer
- Use the approval + promotion flow, do not bypass it
- Runtime merge is allowed in that chat only if explicitly requested
- Prefer speed, but keep the data valid and consistent
```
