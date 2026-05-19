# Session Context — 2026-05-18

This file records the important repo context saved across the recent chats.

## Rules and Match Flow

- The game has **no lives**.
- A match ends only when:
  - a player correctly guesses the opponent's secret trait, or
  - a player surrenders.
- The match uses a **shared character pool**.
- Players can browse/search the pool while guessing.
- Tapping a pool character can autofill the current guess.
- Private hint requests are supported.
- Local multiplayer secrecy is protected with:
  - pass-the-device transitions
  - explicit turn reveal before private information is shown

## Current Gameplay State

Implemented:
- editable setup for player names and hint count
- secret trait selection flow
- match creation from selected traits
- trait-filter-based valid character pool generation
- character guess validation
- trait guess validation
- surrender flow
- hint consumption flow
- result timeline display

## Current Import Pipeline State

Implemented:
- MAL/Jikan-style external character import model
- manual enrichment model with:
  - aliases
  - source reference
  - import notes
- transformer to internal `CharacterModel`
- import preview generation
- tag validation against `assets/data/tags.json`
- duplicate transformed-id detection
- curated promotion preview generation
- tests for preview and promotion output

## Important Handoff Files

Use these first in the next chat:
- `README.md`
- `AGENTS.md`
- `docs/PR4_HANDOFF.md`
- `docs/EXTERNAL_ANIME_DATA.md`
- `NEXT_CHAT_PROMPT.md`

## Current Recommendation

The next recommended PR is focused on:
- import review and catalog expansion tooling
- duplicate source-record detection by `mal_id`
- lightweight tag suggestions from external `about` text
- structured validation/reporting
- optional anime/series import support
- review queue / approval asset before promotion
