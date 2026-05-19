# AI Integration Skill

## Purpose

Use this Skill when working on AI referee, AI hints, AI explanations, prompt templates, AI opponent, or future OpenAI integration.

---

## AI Role

AI is optional.

The game must work without AI.

AI should enhance the experience by providing:

- Explanations
- Smart hints
- Training feedback
- AI opponent reasoning
- Category suggestions
- Match summaries

---

## Initial AI Scope

During early phases, do not connect to OpenAI directly.

Create only:

- Interfaces
- Mock services
- Prompt template files
- Placeholder UI

---

## Suggested Structure

```txt
features/ai_referee/
  data/
    datasources/
      mock_ai_referee_datasource.dart
    repositories/
      ai_referee_repository_impl.dart

  domain/
    entities/
      ai_hint.dart
      ai_explanation.dart
    repositories/
      ai_referee_repository.dart
    services/
      ai_referee_service.dart

  presentation/
    widgets/
      ai_referee_panel.dart
```

## AI Use Cases

### AI Referee

Explains a move without revealing the secret trait.

Example:

That guess gives useful information because it helps separate appearance-based traits from power-based traits.

### AI Hint Generator

Generates subtle hints.

Example:

The hidden trait is related to the character's visual design.

### AI Opponent

Chooses guesses strategically.

Example reasoning:

I will guess Sasuke because he shares multiple possible traits with Madara and Vegeta.

### AI Category Generator

Suggests new categories.

Example:

Characters who inherited power from another being.

## Prompt Safety

Prompts should not reveal the answer unless the action is specifically to explain the result after the match.

During a match, AI must avoid saying the secret trait directly.

If a pool is provided to the AI, it should use that pool only for reasoning context and not invent characters outside it.

## Prompt Template Example

```txt
You are an AI referee for Anime Deduction Tower.

The player is trying to guess a hidden trait.
Do not reveal the hidden trait.
Give a subtle hint based only on the hint type.

Hidden trait type: {{hintType}}
Difficulty: {{difficulty}}
Visible character pool: {{characterPool}}
Correct guesses: {{correctGuesses}}
Incorrect guesses: {{incorrectGuesses}}

Return a short hint in one sentence.
```

## OpenAI Integration Rules

When OpenAI is added later:

- If imported character catalogs are used, AI should only reason over already-approved gameplay data, not raw import previews.

- Store API keys in environment variables.
- Never hardcode secrets.
- Keep API calls inside data layer.
- Keep AI behavior behind repository interfaces.
- Add fallback behavior if AI fails.
- The game must remain playable offline without AI.
- AI must not decide official surrender/win state.

## Anti-Patterns

Avoid:

- Calling OpenAI directly from widgets
- Hardcoding API keys
- Making AI required for core gameplay
- Revealing the secret trait accidentally
- Sending unnecessary user data to the AI
- Depending on AI for deterministic game rules
