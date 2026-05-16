# UI/UX Mobile Skill

## Purpose

Use this Skill when working on screens, widgets, animations, layout, visual style, mobile usability, and portfolio-level polish.

---

## Visual Direction

Anime Deduction Tower should look like a premium dark mobile game.

Style keywords:

- Dark
- Neon
- Clean
- Strategic
- Anime-inspired
- Futuristic
- Smooth
- Premium
- Minimal but energetic

---

## Color Palette

```txt
Background: #090A14
Surface: #141827
Primary: #8B5CF6
Secondary: #06B6D4
Accent: #F97316
Success: #22C55E
Error: #EF4444
Text: #F8FAFC
Muted: #94A3B8
```

## UI Principles

- Mobile-first.
- Large touch targets.
- Clear hierarchy.
- Minimal clutter.
- Strong contrast.
- Smooth transitions.
- Important actions must be obvious.
- Secret information must be protected during local multiplayer.

## Main Screens

### Splash Screen

Should show:

- Logo
- Game title
- Small animated glow or pulse

### Home Screen

Should show:

- Game title
- Main actions
- Play Local
- Play vs AI
- Online Match
- Characters
- Settings

Disabled future modes should look locked or marked as coming soon.

### Game Setup Screen

Should show:

- Player names
- Difficulty
- Number of hints
- Optional timer
- Start button

### Category Selection Screen

Should protect secret information.

Use a transition screen:

- Pass the phone to Player 1
- Tap when ready

### Match Screen

Should show:

- Current player
- Opponent mystery tower
- Guess input
- Guess history
- Hint button
- Guess category button
- Lives/hints

### Result Screen

Should show:

- Winner
- Secret traits
- Number of turns
- Correct guesses
- Hints used
- Rematch button

## Animation Principles

Use animations for feedback, not distraction.

Good animations:

- Button press scale
- Card reveal
- Correct guess glow
- Wrong guess shake
- Screen fade/slide
- Tower pulse
- Background particles

Avoid:

- Too many animations at once
- Slow transitions
- Animations that block gameplay
- Heavy effects on low-end devices

## Component Guidelines

Create reusable components:

- AppButton
- AppCard
- AppScaffold
- CharacterCard
- SecretTraitCard
- TowerView
- GuessHistory
- HintPanel

## Typography

Use a modern sans-serif.

The UI should feel readable and sharp.

Recommended:

- Big titles
- Medium labels
- Clear buttons
- Small muted helper text

## Secret Information UX

Since local multiplayer uses one phone, never show both players' secret information at the same time.

Always use:

- Pass the phone to the next player
- Tap to reveal

before showing private information.

## Portfolio Polish

Every main screen should be screenshot-worthy.

The UI must communicate that this is more than a tutorial project.

Focus on:

- Gradients
- Cards
- Icons
- Clean spacing
- Smooth motion
- Consistent theme

## Anti-Patterns

Avoid:

- Plain white default Flutter UI
- Overcrowded game screen
- Tiny buttons
- Unclear turn state
- Secret information leaks
- Too much text per screen
