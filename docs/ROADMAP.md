# Roadmap

## Phase 0 — Planning

- Define project vision
- Define gameplay
- Define architecture
- Define `AGENTS.md`
- Define Skills
- Define initial folder structure

---

## Phase 1 — Project Foundation

- Create Flutter project
- Add Flame
- Add Riverpod
- Add GoRouter
- Add folder structure
- Add theme
- Add routes
- Add placeholder screens
- Add assets folder
- Add docs folder

---

## Phase 2 — Data Foundation

- Add character JSON
- Add tags JSON
- Add categories JSON
- Add character entity
- Add tag entity
- Add category entity
- Add local JSON loader
- Add repositories
- Add shared character pool-friendly sample data
- Add prototype external import preview layer
- Add curated promotion preview layer

---

## Phase 3 — Core Game Engine

- Add GameMatch
- Add Player
- Add Turn
- Add Guess
- Add GuessResult
- Add character pool state
- Add GameEngine
- Add TraitFilterEngine
- Add HintEngine
- Add MatchRulesEngine
- Add surrender handling
- Add unit tests

---

## Phase 4 — Local Multiplayer MVP

- Add game setup
- Add category selection
- Add turn transition
- Add match screen
- Add in-match character pool browser
- Add in-match character search
- Add result screen
- Connect UI to game engine

---

## Phase 5 — UI Polish

- Improve visual theme
- Add cards
- Add tower view
- Add animations
- Add visual feedback
- Improve mobile responsiveness
- Polish pool search UX
- Polish protected local-turn reveal flow

---

## Phase 6 — Flame Integration

- Add Flame board
- Add animated tower
- Add card components
- Add reveal effects
- Add correct/wrong effects

---

## Phase 7 — AI-Ready Architecture

- Add AI referee interfaces
- Add mock AI referee
- Add AI explanation entity
- Add AI panel
- Add prompt templates
- Support pool-aware AI explanations later

---

## Phase 8 — Play vs AI

- Add AI opponent logic
- Add AI difficulty
- Add AI reasoning
- Add training mode

---

## Phase 9 — Online Multiplayer

- Add room creation
- Add join by code
- Add backend-ready datasource/repository boundary before live sync
- Add remote match bootstrap payload + public/private/action contracts
- Add remote match bootstrap service
- Add realtime sync
- Add remote match state
- Saved foundation preview: dedicated room-code lobby screen
- Saved foundation preview: participant-based room session model and ready-state phases
- Saved foundation preview: backend-targeted preview datasource/repository architecture for future Firebase or Supabase swap
- Saved foundation preview: explicit remote bootstrap/public/private/action models for future Firebase room and match syncing
- Saved foundation preview: pure Dart bootstrap service that converts a ready room plus secret selections into initial remote payload/public/private match state
- Saved foundation preview: mock remote guest-join and remote-ready simulation controls for more realistic pre-backend lobby testing
- Saved foundation preview: on-screen remote bootstrap summary card for payload/public/private preview without live backend sync
- Saved backend step: Firebase-backed room creation/join/watch scaffolding plus local-ready updates behind runtime-configured datasource boundaries
- Saved backend step: Firestore bootstrap persistence for `match_bootstrap/current`, `match_public/current`, and per-player private bootstrap docs once a room reaches `readyToSync`
- Saved backend step: live read/watch of persisted bootstrap/public/private docs plus reconnect-aware room-to-match handoff UX in the online lobby screen
- Saved backend step: read-only remote match screen-state loader that hydrates a gameplay-ready online match model from persisted bootstrap/public/private docs and local catalog data
- Saved backend step: queued online player action submission and live action-queue watch flow through the repository/datasource boundary, with lobby-side debug UX and no in-widget rule resolution
- Saved backend step: pure Dart remote queued-action resolver/application layer that reads persisted bootstrap/public/private state, applies actions through the existing game engine, and persists public/private/action resolution updates back through the repository boundary
- Saved backend step: explicit temporary action-resolution authority policy with host-only client ownership, plus gated resolver controls for non-authoritative clients
- Saved backend step: dedicated backend-authority service flow for Firebase backend mode so pending actions can auto-resolve with `backendService` metadata and canonical public events while preserving current explicit action metadata
- Saved backend step: persisted queued-action resolver metadata through `resolvedByParticipantId`, `resolvedByUserId`, and `resolutionSource` on resolved action docs
- Saved backend step: canonical public online event contract persisted during queued-action resolution so future remote match/result timelines can watch explicit public event docs without changing existing action metadata

---

## Phase 10 — Portfolio Release

- Add screenshots
- Add video demo
- Add polished README
- Add APK build
- Add portfolio case study
