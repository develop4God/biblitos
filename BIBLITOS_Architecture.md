# ⛵ Biblitos — Architecture Document
**Version 2.1 — March 2026**  
**Stack: Flutter + Flame + Riverpod**  
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

## 3. Callback Injection Pattern — The DIP Boundary

**This is the most critical architectural rule in Biblitos.**

Flame components must never import Riverpod. The boundary between game logic and state management is enforced via callback injection.

```dart
// ✅ CORRECT — component is pure game behavior
class AnimalComponent extends SpriteComponent with TapCallbacks {
  final AnimalConfig config;
  final void Function(String audioKey, String reactAnimation) onTapped;

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(config.audioKey, config.reactAnimation);  // fires callback only
  }
}

// ✅ CORRECT — world owns ref and resolves providers
AnimalComponent(
  config: kLionConfig,
  onTapped: (audioKey, animation) {
    final language = ref.read(localeProvider);
    ref.read(audioProvider).playVerse(audioKey, language);
  },
  position: Vector2(580, 560),
  size: Vector2(150, 150),
)

// ❌ HARD BLOCK — ref leaking into component
class AnimalComponent extends SpriteComponent with TapCallbacks {
  final WidgetRef ref;  // NEVER
}
```

**Rule: Components own behavior. Worlds own state resolution. Never cross this boundary.**

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

### Test Pattern — Flame Components
```dart
testWithFlameGame('describes expected behavior', (game) async {
  // arrange component with captured callback
  // add to game, await ready()
  // fire event
  // expect captured values
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
- [ ] No Riverpod imports in Flame components
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
| 4 | `WidgetRef` or any Riverpod import inside a Flame component |
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

*"Commit your work to the Lord, and your plans will be established." — Proverbs 16:3*

*Built with prayer, purpose, and a calling to plant God's Word in the next generation.*