# ⛵ Biblitos — Architecture Document
**Version 3.0 — September 2026**  
**Stack: Flutter + Flame + Riverpod + flame_riverpod**  
**Status: Active Constitution — no .dart file is written without conforming to this document.**

---

## 0. Purpose

Single source of truth for every architectural decision in Biblitos. Governs: project structure, Flame component hierarchy, Riverpod provider registry, DIP contract pattern, audio naming, asset structure, test mandate, and agent delegation format.

**Agents read this before writing any `.dart` file. If this document conflicts with an agent's instinct — this document wins.**

---

## 1. Tech Stack

| Layer | Tool | Version |
|---|---|---|
| UI Framework | Flutter | 3.41.4 |
| Game Engine | Flame | ^1.21.0 |
| State Management | Riverpod + Freezed | ^2.6.1 |
| Audio | just_audio | ^0.9.42 |
| Asset Pipeline | pubspec.yaml declarations | — |
| TTS Generation | Gemini 2.5 Pro (Python pipeline) | Pre-generated only |
| Target | Android + iOS | — |
| Riverpod-Flame Bridge | flame_riverpod | ^5.5.5 |

---

## 2. SOLID Principles — Flame + Riverpod Expression

| Principle | Rule | Expression |
|---|---|---|
| **S** — SRP | One component = one behavior | `AnimalComponent` handles touch + sprite only. Never audio logic. |
| **O** — OCP | Extend, never modify | New animals → new component instance with different config. Zero edits to `AnimalComponent`. |
| **L** — LSP | All animals substitutable | Every animal is an `AnimalComponent` with different `AnimalConfig`. Full contract fulfilled. |
| **I** — ISP | Lean providers | `LocaleNotifier` manages language only. `AudioService` manages playback only. Never both. |
| **D** — DIP | Components depend on callbacks, never on concrete services | `AnimalComponent` fires `onTapped` callback — never calls `AudioService` directly. |

---

## 3. Riverpod Boundary — Worlds Wire State, Components Stay Reviewed

**Migrated in v3.0 (Sept 2026) from a hand-rolled `ProviderContainer`-threading pattern to the official `flame_riverpod` bridge.** This section documents the current contract and why it changed.

### 3.1 Worlds — `RiverpodGameMixin`

Every `FlameGame` world uses `RiverpodGameMixin` and is hosted by `RiverpodAwareGameWidget` (not plain `GameWidget`). This gives the world a `ref` directly — no more manually threading a `ProviderContainer` through every World's constructor.

**Constraint discovered during migration:** `flame_riverpod` only supports `ref.listen` inside a Component's `addToGameWidgetBuild` hook — calling it directly in `FlameGame.onLoad` throws (`ref.listen can only be used within the build method of a ConsumerWidget`). `ref.read` (one-shot) works fine in the World. For a World that needs to *react* to a provider changing (not just read it once), add a small invisible `Component` with `RiverpodComponentMixin` that listens and forwards via a plain callback — see `SkySyncComponent` in `lib/components/sky_sync_component.dart`. This is not a workaround-turned-hack: it's the officially supported shape (listen lives in a component), it still reports through a callback rather than mutating World state directly from inside the component, and it keeps the World as the thing that decides what a sky change *means* (background color).

```dart
// ✅ World — RiverpodGameMixin gives it `ref` directly for one-shot reads
class NoahExteriorStormWorld extends FlameGame with RiverpodGameMixin {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Reactive listen must go through a Component — see SkySyncComponent.
    await add(SkySyncComponent(onSkyChanged: (isNight) { ... }));
  }

  Future<void> _buildScene() async {
    await add(AnimalComponent(
      config: kLionConfig,
      onTapped: (audioKey, animation) {
        final language = ref.read(localeProvider);
        ref.read(audioProvider).playVerse(audioKey, language);
      },
      position: Vector2(580, 560),
      size: Vector2(150, 150),
    ));
  }
}
```

```dart
// app.dart / game_canvas.dart — host with RiverpodAwareGameWidget, not GameWidget
RiverpodAwareGameWidget(game: NoahExteriorStormWorld())
```

### 3.2 Components — callback-only by default, `RiverpodComponentMixin` only when a component needs reactive read state

Components still default to pure callback injection — `AnimalComponent`, `ArkComponent`, and `BackgroundComponent` fire `onTapped` and take zero Riverpod imports today, because none of them currently need to reactively rebuild on provider changes. This is unchanged from v2.1 and remains the default for any new component.

`RiverpodComponentMixin` is **allowed**, not blocked, the moment a component genuinely needs to *watch* provider state and react to it live (e.g. a future component whose idle animation must change immediately when `localeProvider` changes, without the World pushing state down manually). When that need appears:

```dart
// ✅ ALLOWED — component reacts to state, does not own it
class SomeReactiveComponent extends PositionComponent with RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(localeProvider, (previous, language) {
        // update display only — never call services, never mutate providers here
      });
    });
    super.onMount();
  }
}

// ❌ STILL NOT ALLOWED — component performing a side effect / owning business logic
class SomeComponent extends PositionComponent with RiverpodComponentMixin {
  void onTapDown(TapDownEvent event) {
    ref.read(audioProvider).playVerse(...);   // side effects belong in the World's callback, not here
    ref.read(gameStateProvider.notifier).placeAnimal(...); // NEVER — this is business logic in a component
  }
}
```

**Rule going forward:** a component may `ref.watch`/`ref.listen` for **read-only reactive display state only**. Triggering side effects (audio, game-state mutation) from inside a component — instead of via the callback the World already resolves — is a review-rejected pattern, not a compiler error. This replaced the old hard compiler-style block (v2.1 Rule 4) now that every PR is reviewed against this document; see §11 Rule 4 for the updated wording.

**Rule: Worlds own state resolution and side effects. Components may read for display, never to act.**

---

## 4. Project Structure

```
biblitos/
├── lib/
│   ├── main.dart                          ← async entry point, orientation lock
│   ├── app.dart                           ← MaterialApp + GameWidget shell
│   ├── components/
│   │   ├── animals/
│   │   │   ├── animal_component.dart      ← Base class (SRP/OCP/LSP)
│   │   │   ├── animal_config.dart         ← Freezed config + 6 const configs
│   │   │   └── animal_config.freezed.dart ← Generated
│   │   ├── props/
│   │   │   └── ark_component.dart
│   │   └── backgrounds/
│   │       └── background_component.dart
│   ├── providers/
│   │   ├── locale_provider.dart           ← Language state + path building
│   │   ├── audio_provider.dart            ← AudioService provider + extensions
│   │   └── game_state_provider.dart       ← Path A/B placement + Freezed
│   ├── services/
│   │   └── audio_service.dart             ← Pure Dart, just_audio wrapper
│   └── worlds/
│       ├── noah_exterior_storm_world.dart
│       ├── noah_exterior_rainbow_world.dart
│       └── noah_interior_world.dart
├── test/
│   ├── providers/
│   │   ├── locale_provider_test.dart      ← 5 tests ✅
│   │   └── game_state_provider_test.dart  ← 6 tests ✅
│   └── components/
│       └── animal_component_test.dart     ← 1 test ✅
├── assets/
│   ├── noah_ark/
│   │   ├── characters/
│   │   ├── backgrounds/
│   │   └── props/
│   └── audio/
│       ├── en/sfx/
│       ├── es/
│       ├── pt/
│       └── fr/
├── pipeline/
│   └── generate_audio.py
└── pubspec.yaml
```

---

## 5. Riverpod Provider Registry

| Provider | File | Type | Responsibility |
|---|---|---|---|
| `localeProvider` | `locale_provider.dart` | `StateNotifierProvider<LocaleNotifier, String>` | Language state + path building |
| `audioProvider` | `audio_provider.dart` | `Provider<AudioService>` | Audio playback service |
| `gameStateProvider` | `game_state_provider.dart` | `StateNotifierProvider<GameStateNotifier, GameState>` | Path A/B animal placement |

### Public APIs

```dart
// localeProvider
ref.read(localeProvider)                              // "en" | "es" | "pt" | "fr"
ref.read(localeProvider.notifier).setLanguage("es")
ref.read(localeProvider.notifier).buildPath("lion_verse")
// → "assets/audio/es/lion_verse.mp3"
ref.read(localeProvider.notifier).buildSfxPath("rain")
// → "assets/audio/en/sfx/rain.mp3"

// audioProvider
ref.read(audioProvider).playVerse("lion_verse", language)
ref.read(audioProvider).playSfx("rain")
ref.read(audioProvider).stop()

// gameStateProvider
ref.read(gameStateProvider.notifier).placeAnimal("lion")
ref.read(gameStateProvider).isPlaced("lion")          // bool
ref.read(gameStateProvider).allPlaced                 // bool
ref.read(gameStateProvider.notifier).reset()
```

### Supported Languages
```dart
const kSupportedLanguages = ['en', 'es', 'pt', 'fr'];
const kDefaultLanguage = 'en';
```

---

## 6. Animal Configs

```dart
const kAllAnimals = {'noah', 'lion', 'elephant', 'giraffe', 'dove', 'sheep'};

// Predefined configs — never hardcode inside components
const kNoahConfig     = AnimalConfig(audioKey: 'noah_verse',     spritePath: 'assets/noah_ark/characters/noah.png',     reactAnimation: 'wave',    idleAnimation: 'idle');
const kLionConfig     = AnimalConfig(audioKey: 'lion_verse',     spritePath: 'assets/noah_ark/characters/lion.png',     reactAnimation: 'bounce',  idleAnimation: 'idle');
const kElephantConfig = AnimalConfig(audioKey: 'elephant_verse', spritePath: 'assets/noah_ark/characters/elephant.png', reactAnimation: 'wiggle',  idleAnimation: 'idle');
const kGiraffeConfig  = AnimalConfig(audioKey: 'giraffe_verse',  spritePath: 'assets/noah_ark/characters/giraffe.png',  reactAnimation: 'stretch', idleAnimation: 'idle');
const kDoveConfig     = AnimalConfig(audioKey: 'dove_verse',     spritePath: 'assets/noah_ark/characters/dove.png',     reactAnimation: 'fly',     idleAnimation: 'idle');
const kSheepConfig    = AnimalConfig(audioKey: 'sheep_verse',    spritePath: 'assets/noah_ark/characters/sheep.png',    reactAnimation: 'hop',     idleAnimation: 'idle');
```

---

## 7. Audio System

### Folder Structure
```
assets/audio/
├── en/
│   ├── noah_verse.mp3
│   ├── lion_verse.mp3
│   ├── elephant_verse.mp3
│   ├── giraffe_verse.mp3
│   ├── dove_verse.mp3
│   ├── sheep_verse.mp3
│   ├── rainbow_verse.mp3
│   └── sfx/
│       ├── rain.mp3
│       ├── thunder.mp3
│       ├── waves.mp3
│       └── rainbow_music.mp3
├── es/  (same verse filenames, no sfx)
├── pt/  (same verse filenames, no sfx)
└── fr/  (same verse filenames, no sfx)
```

**Rules:**
- All filenames `snake_case`, lowercase
- SFX language-neutral — `en/sfx/` only
- Verse files exist in all 4 language folders

---

## 8. World Layout — Noah Exterior Storm (1920×1080 landscape)

```
[Sky — y: 0–400]
    Dove       → Vector2(900, 150)   flying loop
[Ark — y: 320, centered]
    Ark        → Vector2(760, 320)   rocking idle
    Giraffe    → Vector2(900, 260)   neck above roofline
    Noah       → Vector2(1050, 450)  ark door
[Water edge — y: 550+]
    Lion       → Vector2(580, 560)
    Sheep      → Vector2(1250, 620)
    Elephant   → Vector2(320, 650)
```

---

## 9. Test Mandate — Non-Negotiable

**Every provider and component ships with tests in the same delegation block.**

| Scope | Required tests |
|---|---|
| `StateNotifier` | All state transitions, edge cases, reset |
| `Provider` | Dispose behavior, dependency wiring |
| `FlameComponent` | Callback fires with correct args |
| Freezed model | Extension methods, computed properties |

### Test Pattern — Providers
```dart
group('ProviderName', () {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('describes expected behavior', () {
    // arrange → act → expect
  });
});
```

### Test Pattern — Flame Components (callback-only, the default)
```dart
testWithFlameGame('describes expected behavior', (game) async {
  // arrange component with captured callback
  // add to game, await ready()
  // fire event
  // expect captured values
});
```

### Test Pattern — Flame Components using `RiverpodComponentMixin`
Only needed for a component that reactively watches a provider (§3.2). Requires a `ProviderContainer` with overrides, since the component now depends on provider state directly rather than a captured callback:
```dart
testWithFlameGame('reacts to provider state', (game) async {
  final container = ProviderContainer(
    overrides: [localeProvider.overrideWith(() => LocaleNotifier())],
  );
  addTearDown(container.dispose);

  final component = SomeReactiveComponent();
  await game.ensureAdd(component);
  // mutate the provider via container, then assert the component's
  // observable state (e.g. displayed text/animation) updated
});
```

---

## 10. Agent Delegation Format

### Required Sections (all mandatory)

**Section 1 — Ground Rules**
```
## Ground Rules
- Read BIBLITOS_Architecture.md before writing any code.
- Apply exactly what is specified. No improvisation.
- Do NOT modify files outside the task scope.
- Do NOT add providers not in the Provider Registry.
- Do NOT import Riverpod inside Flame components.
- Run dart run build_runner build --delete-conflicting-outputs after @freezed changes.
- Run dart analyze — must be 0 issues.
- Run flutter test — must pass 0 failures.
- If unclear — flag it. Do not guess.
```

**Section 2 — Before/After Dart blocks (production file)**

**Section 3 — Before/After Dart blocks (test file — mandatory)**

**Section 4 — Completion Checklist**
```
- [ ] Production file created/modified
- [ ] Test file created with N tests
- [ ] dart analyze → 0 issues
- [ ] flutter test → 0 failures
- [ ] No component uses `ref` to trigger a side effect (§3.2) — read-only display state only
- [ ] Any new/changed tap target and feedback timing follows §13 Child Interaction Constants
- [ ] No files modified outside task scope
```

**Section 5 — Expected Behavior**

---

## 11. Hard Block Checklist

| # | Rule |
|---|---|
| 1 | `AudioService()` instantiated directly in a component |
| 2 | Language string hardcoded in a component: `"en"` |
| 3 | Asset path hardcoded in a component |
| 4 | A component using `ref` to trigger a side effect (audio, game-state mutation) instead of via its callback — `ref.watch`/`ref.listen` for read-only display state is allowed (see §3.2); this is a review rule, not a compiler block |
| 5 | New provider added without registering in this document |
| 6 | `AnimalComponent` modified to add a new animal |
| 7 | `@riverpod` or `@freezed` changed without running build_runner |
| 8 | Old Godot asset paths: `res://assets/` anywhere |
| 9 | ARB files or `AppLocalizations` — not needed in Biblitos |
| 10 | `just_audio` imported directly in a component |
| 11 | New provider delivered without corresponding test file |
| 12 | New component delivered without callback/behavior test |
| 13 | Agent modifies files outside the delegation task scope |

---

## 12. Agent Failure Patterns — Learned in Production

| Pattern | Detection | Prevention |
|---|---|---|
| Scope creep — edits files not in task | Check diff for unexpected files | "Edit X only" in Ground Rules |
| Missing tests — delivers production code only | `flutter test` not in checklist | Tests mandatory in same block |
| `WidgetRef` in components | `grep -r "WidgetRef" lib/components/` | Hard block rule 4 |
| Experiment flags in analysis_options | `grep "enable-experiment" analysis_options.yaml` | "Do not touch analysis_options" in Ground Rules |
| Duplicate pubspec entries | `flutter pub get` fails | "Edit dependencies section only" |
| Wrong language array | Check `kSupportedLanguages` | Always specify exact array in block |

---

## 13. Child Interaction Constants — Ages 2–6 (Non-Negotiable)

Biblitos's actual product risk isn't architectural — it's whether a 2-6 year old can use the app unassisted. These rules are as binding as the engineering rules above and apply to every World and Component that handles touch or feedback.

| Rule | Constant | Rationale |
|---|---|---|
| Minimum tap target | 120×120 logical px | Toddler motor control is imprecise; smaller targets cause repeated missed taps and frustration |
| Feedback latency | Every meaningful action (tap → verse audio; drag-drop onto a target → `reactAnimation` + boarding sound) must produce its response within the same frame the action completes | Delayed/split feedback reads as "broken" to a child this age; reward must feel instant |
| No failure state | The app must never show an error, "wrong", or blocking dialog to the child | `gameStateProvider` already only tracks positive placement (`isPlaced`/`allPlaced`) with no fail path — keep it that way as new interactions are added |
| No score/timer pressure | Never add point counters, countdowns, or lose conditions | Matches the Toca Boca model: engagement through open interaction, not competition |
| Session pacing | Design each World's full interaction loop (all animals placed) to complete within ~8–10 minutes | Matches documented attention span for this age band |

**Enforcement:** any new component or World PR is checked against this section the same way it's checked against §11's hard blocks — it's a review-checklist item, not a suggestion.

---

## 14. Core Game Loop — Tap-to-Hear, Drag-to-Board

Earlier drafts of the storm world had a tap that both played audio and marked an animal "placed" — there was no actual objective, just labeled decoration. This section defines the real loop, now implemented in `NoahExteriorStormWorld`.

**Two distinct interactions, not one:**
1. **Tap an animal → plays its verse audio.** Repeatable at will, no state change, no cost. This is the Scripture-hearing mechanic (Gate 2) — a child can replay any animal's verse as many times as they want.
2. **Drag an animal onto the ark → the actual game objective.** Dropping it within the ark's board radius (a generous, forgiving distance check — see `isWithinBoardRadius` in `board_target.dart` — never a precise hitbox, per §13's imprecise-motor-control rule) triggers, in order: the animal's `reactAnimation` (a Flame `Effect` — see `react_effect.dart` — since there are no sprite-sheet animations yet, these are transform tweens: scale/rotate/move), a "boarded" sound, and `gameStateProvider.placeAnimal(...)`. When the 6th animal boards, Noah plays his own `reactAnimation` and an "all_aboard" sound plays — the completion moment `gameStateProvider.allPlaced` always computed but was never surfaced to the child before this.

**Why tap and drop are decoupled:** conflating "heard the verse" with "completed the objective" (the original design) meant there was no way to let a child replay a verse without also (mis)marking progress, and no way to give a real goal without blocking verse-replay. Splitting them gives both: infinite low-stakes replay (tap) and a real, single, forgiving objective (drag-to-ark).

**Noah is the one exception** — he doesn't board anywhere (he's already at the ark door), so his tap still marks him placed directly, same as before. He also serves as the completion-celebration actor once every animal boards.

This pattern — tap for repeatable Scripture-hearing, drag-to-target for the actual objective, with a visible completion moment — is the template for every future World, not something unique to the storm scene.

---

## 15. Roadmap & Layer Status

Update this section at the end of every session — it is the in-repo source of truth for project state (mirrors, and takes precedence over, any external session-start tooling).

```
Layer 1 — Foundation     ✅  pubspec, main.dart, app.dart, animal_config.dart
Layer 2 — Providers      ✅  locale, audio, game_state, sky — provider tests passing
Layer 3 — Components     ✅  AnimalComponent, ArkComponent, BackgroundComponent — tests passing
Layer 4 — Worlds         ⏳  storm world: real game loop now (§14) — tap-to-hear-verse,
                                drag-to-board-the-ark with reactAnimation + boarding sound,
                                completion celebration when all 6 board, sky toggle,
                                flame_riverpod migrated
                              rainbow world — NOT started, but rainbow.png background asset exists,
                                unblocked, buildable now by reusing the same tap/drag pattern
                              interior world — NOT started, blocked: no interior background asset yet
Layer 5 — Interactivity  ⏳  main_menu, language_button — not started
                              drag_mechanics — DONE for storm world (§14's drag-to-board loop
                                is the reference implementation for future Worlds)
Layer 6 — Audio Pipeline ⏳  BLOCKED — assets/audio/{en,es,pt,fr}/ contain only .gitkeep placeholders,
                              no real audio files yet; generate_audio.py pipeline not yet run.
                              Also needs 2 new sfx keys once real audio exists: 'boarded' and
                              'all_aboard' (referenced in code today, silently no-op until
                              real files land — see AudioService's caught-error behavior)
Layer 7 — Launch Polish  ⏳  icon, Firebase, Android + iOS export — not started
```

### Gates
- **Gate 1** — Ark visible on device → merge `feature/flame-foundation` to `main`
- **Gate 2** — Child taps animal, hears Scripture → family test → App Store

### Last completed (this session)
Migrated Riverpod↔Flame wiring to `flame_riverpod` (World-level `RiverpodGameMixin` + `SkySyncComponent` for reactive listens); added §13 Child Interaction Constants; added a `SessionStart` hook so Flutter/Dart auto-installs on every Claude Code web session; lowered `pubspec.yaml` sdk constraint to `^3.9.0` to allow stable-channel Flutter. Then found and fixed the actual product gap underneath all of that: dragging did nothing and there was no win state. Added §14 Core Game Loop — drag-to-board is now the real objective, with reaction animations (Flame `Effect` tweens, no new art needed) and a completion celebration. Still on `feature/flame-riverpod-migration` — **not yet merged to `main`** (all 44 tests pass on the branch; merge is pending).

### Recommended next step
Manual device/emulator verification of the new drag-to-board loop (tap → verse, drag onto ark → animation + sound + placement, all 6 → Noah celebrates) — this has only been verified via unit/widget tests in this environment, no real device available here. After that: rainbow world (Layer 4) is the next highest-leverage unblocked work, applying the same tap/drag pattern §14 now documents as the template. Layer 6 (Audio) is blocked on real audio assets regardless of any code work — the 'boarded'/'all_aboard' sfx keys are wired but silent until real files exist.

---

*"Commit your work to the Lord, and your plans will be established." — Proverbs 16:3*

*Built with prayer, purpose, and a calling to plant God's Word in the next generation.*