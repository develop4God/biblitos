# ⛵ Biblitos — Architecture Document
**Version 2.0 — March 2026**  
**Stack: Flutter + Flame + Riverpod**  
**Status: Active Constitution — no .dart file is written without conforming to this document.**

---

## 0. Purpose

This document is the single source of truth for every architectural decision in Biblitos.  
It governs: project structure, Flame component hierarchy, Riverpod provider registry, DIP contract pattern, audio naming, asset structure, and agent delegation format.

**Agents must read this document before writing any `.dart` file.**  
**If this document conflicts with an agent's instinct — this document wins.**

---

## 1. Tech Stack

| Layer | Tool | Why |
|---|---|---|
| UI Framework | Flutter 3.41.4 | Cross-platform, Dart, existing expertise |
| Game Engine | Flame 1.x | 2D components, touch, animation — fully code-driven |
| State Management | Riverpod + Freezed | Reactive state, no BLoC ceremony for simple state |
| Audio | just_audio | Pre-generated mp3 playback, offline-first |
| Asset Pipeline | flutter pub + pubspec.yaml | Declared assets, no runtime fetching |
| TTS Generation | Gemini 2.5 Pro (Python pipeline) | Pre-generated, never runtime API calls |
| Target | Android + iOS | flutter build apk / ipa |

---

## 2. SOLID Principles — Flame + Riverpod Expression

| Principle | Rule | Expression |
|---|---|---|
| **S** — SRP | One component = one behavior | `AnimalComponent` handles touch + animation only. Never audio logic directly. |
| **O** — OCP | Extend, never modify | New animals → new component instance with different config. Zero edits to `AnimalComponent`. |
| **L** — LSP | All animals substitutable | Every animal is an `AnimalComponent` with different `AnimalConfig`. Full contract fulfilled. |
| **I** — ISP | Lean providers | `LocaleNotifier` manages language only. `AudioNotifier` manages playback only. Never both. |
| **D** — DIP | Components depend on providers, never on concrete services | `AnimalComponent` calls `ref.read(audioProvider)` — never `AudioService()` directly. |

---

## 3. Project Structure

```
biblitos/
├── lib/
│   ├── main.dart                          ← ProviderScope root
│   ├── app.dart                           ← FlameGame setup
│   ├── components/                        ← Flame components
│   │   ├── animals/
│   │   │   ├── animal_component.dart      ← Base class (OCP/LSP contract)
│   │   │   └── animal_config.dart         ← Freezed data model
│   │   ├── props/
│   │   │   └── ark_component.dart
│   │   └── backgrounds/
│   │       └── background_component.dart
│   ├── providers/                         ← Riverpod providers
│   │   ├── locale_provider.dart           ← Language state
│   │   ├── audio_provider.dart            ← Audio playback
│   │   └── game_state_provider.dart       ← Path A/B placement
│   ├── services/                          ← Pure Dart services
│   │   └── audio_service.dart             ← just_audio wrapper
│   └── worlds/                            ← Flame game worlds
│       ├── noah_exterior_storm_world.dart
│       ├── noah_exterior_rainbow_world.dart
│       └── noah_interior_world.dart
├── assets/
│   ├── noah_ark/
│   │   ├── characters/
│   │   │   ├── noah.png
│   │   │   ├── lion.png
│   │   │   ├── elephant.png
│   │   │   ├── giraffe.png
│   │   │   ├── dove.png
│   │   │   └── sheep.png
│   │   ├── backgrounds/
│   │   │   ├── storm.png
│   │   │   └── rainbow.png
│   │   └── props/
│   │       └── ark.png
│   └── audio/
│       ├── en/
│       │   └── sfx/
│       ├── es/
│       ├── pt/
│       └── fr/
├── pipeline/
│   └── generate_audio.py
├── pubspec.yaml
├── BIBLITOS_Architecture.md
├── BIBLITOS_MasterPlan.md
└── BIBLITOS_HandoffDoc.md
```

---

## 4. Riverpod Provider Registry

All providers declared here. No provider is added without updating this document first.

| Provider | File | Type | Responsibility |
|---|---|---|---|
| `localeProvider` | `locale_provider.dart` | `StateNotifierProvider<LocaleNotifier, String>` | Current language state + switching |
| `audioProvider` | `audio_provider.dart` | `Provider<AudioService>` | Audio playback service |
| `gameStateProvider` | `game_state_provider.dart` | `StateNotifierProvider<GameStateNotifier, GameState>` | Path A/B animal placement |

### Provider Public APIs

```dart
// localeProvider
ref.read(localeProvider)                    // "en" | "es" | "pt" | "fr"
ref.read(localeProvider.notifier).setLanguage("es")
ref.read(localeProvider.notifier).buildPath("lion_verse")
// → "assets/audio/es/lion_verse.mp3"
ref.read(localeProvider.notifier).buildSfxPath("rain")
// → "assets/audio/en/sfx/rain.mp3"

// audioProvider
ref.read(audioProvider).play("lion_verse", language: "es")
ref.read(audioProvider).playSfx("rain")
ref.read(audioProvider).stop()

// gameStateProvider
ref.read(gameStateProvider.notifier).placeAnimal("lion")
ref.read(gameStateProvider).isPlaced("lion")       // bool
ref.read(gameStateProvider).allPlaced              // bool
ref.read(gameStateProvider.notifier).reset()
```

### Supported Languages
```dart
const kSupportedLanguages = ["en", "es", "pt", "fr"];
const kDefaultLanguage = "en";
```

---

## 5. Dependency Inversion — The Config Pattern

This is how DIP is expressed at the component level. Components declare what they need via `AnimalConfig` — they never hardcode identity.

```dart
// animal_config.dart — Freezed data model
@freezed
class AnimalConfig with _$AnimalConfig {
  const factory AnimalConfig({
    required String audioKey,        // e.g. "lion_verse"
    required String spritePath,      // e.g. "assets/noah_ark/characters/lion.png"
    required String reactAnimation,  // e.g. "bounce"
    required String idleAnimation,   // e.g. "idle"
    @Default(false) bool isDraggable,
  }) = _AnimalConfig;
}
```

### Predefined Animal Configs

```dart
// Defined once — used everywhere. Never hardcoded inside components.
const kNoahConfig = AnimalConfig(
  audioKey: "noah_verse",
  spritePath: "assets/noah_ark/characters/noah.png",
  reactAnimation: "wave",
  idleAnimation: "idle",
);
const kLionConfig = AnimalConfig(
  audioKey: "lion_verse",
  spritePath: "assets/noah_ark/characters/lion.png",
  reactAnimation: "bounce",
  idleAnimation: "idle",
);
const kElephantConfig = AnimalConfig(
  audioKey: "elephant_verse",
  spritePath: "assets/noah_ark/characters/elephant.png",
  reactAnimation: "wiggle",
  idleAnimation: "idle",
);
const kGiraffeConfig = AnimalConfig(
  audioKey: "giraffe_verse",
  spritePath: "assets/noah_ark/characters/giraffe.png",
  reactAnimation: "stretch",
  idleAnimation: "idle",
);
const kDoveConfig = AnimalConfig(
  audioKey: "dove_verse",
  spritePath: "assets/noah_ark/characters/dove.png",
  reactAnimation: "fly",
  idleAnimation: "idle",
);
const kSheepConfig = AnimalConfig(
  audioKey: "sheep_verse",
  spritePath: "assets/noah_ark/characters/sheep.png",
  reactAnimation: "hop",
  idleAnimation: "idle",
);
```

---

## 6. Base Component — AnimalComponent (OCP + LSP Contract)

All animals use this component. **Never modified when adding new animals.**

```dart
// lib/components/animals/animal_component.dart
class AnimalComponent extends SpriteComponent
    with TapCallbacks, HasGameRef {
  
  final AnimalConfig config;
  final WidgetRef ref;

  AnimalComponent({
    required this.config,
    required this.ref,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(config.spritePath);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final language = ref.read(localeProvider);
    ref.read(audioProvider).play(config.audioKey, language: language);
    _playReactAnimation();
  }

  void _playReactAnimation() {
    // Animation logic based on config.reactAnimation
  }
}
```

### Adding a New Animal — Zero Edits to Existing Code
```dart
// World 2 — Bethlehem
const kShepherdConfig = AnimalConfig(
  audioKey: "shepherd_verse",
  spritePath: "assets/bethlehem/characters/shepherd.png",
  reactAnimation: "bow",
  idleAnimation: "idle",
);

// In the world — just add the component
add(AnimalComponent(config: kShepherdConfig, ref: ref, ...));
```
`AnimalComponent` is untouched. That is OCP.

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
├── es/  (same filenames, no sfx)
├── pt/  (same filenames, no sfx)
└── fr/  (same filenames, no sfx)
```

### Naming Contract

| Category | Pattern | Example |
|---|---|---|
| Animal verse | `{animal}_verse.mp3` | `lion_verse.mp3` |
| Scene ambient | `sfx/{event}.mp3` | `sfx/rain.mp3` |
| Scene music | `sfx/{event}_music.mp3` | `sfx/rainbow_music.mp3` |

**Rules:**
- All filenames `snake_case`, lowercase, no spaces
- SFX language-neutral — `en/sfx/` only, shared across all locales
- Verse files exist in all 4 Day 1 language folders

---

## 8. pubspec.yaml — Required Dependencies

```yaml
name: biblitos
description: Free-play biblical world for children ages 3-8.
version: 1.0.0+1

environment:
  sdk: '>=3.11.1 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flame: ^1.21.0
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  freezed_annotation: ^2.4.4
  just_audio: ^0.9.42
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.13
  freezed: ^2.5.7
  riverpod_generator: ^2.6.1
  flutter_lints: ^5.0.0

flutter:
  assets:
    - assets/noah_ark/characters/
    - assets/noah_ark/backgrounds/
    - assets/noah_ark/props/
    - assets/audio/en/
    - assets/audio/en/sfx/
    - assets/audio/es/
    - assets/audio/pt/
    - assets/audio/fr/
```

---

## 9. World Layout — Noah Exterior Storm (1920×1080 landscape)

```
[Sky — y: 0 to 400]
    Dove      → position (900, 150)   flying loop animation
    Clouds    → drifting slowly

[Ark — center, y: 320]
    Ark       → position (760, 320)   rocking idle animation
    Giraffe   → position (900, 260)   neck above ark roofline
    Noah      → position (1050, 450)  ark door

[Ground/Water — y: 550+]
    Lion      → position (580, 560)   ark entrance left
    Sheep     → position (1250, 620)  ark right side
    Elephant  → position (320, 650)   water edge left
```

---

## 10. GameState — Path A/B

Session-only. No persistence. Resets on app restart.

```dart
// GameState — Freezed model
@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default({}) Set<String> placedAnimals,
  }) = _GameState;
}

extension GameStateX on GameState {
  bool isPlaced(String key) => placedAnimals.contains(key);
  bool get allPlaced => kAllAnimals.every(placedAnimals.contains);
}

const kAllAnimals = {"noah", "lion", "elephant", "giraffe", "dove", "sheep"};
```

---

## 11. Agent Delegation Format

Same format as Flutter projects. Before/After Dart blocks. No prose descriptions.

### Required Task Structure

**Section 1 — Ground Rules**
```
## Ground Rules
- Read BIBLITOS_Architecture.md before writing any code.
- Apply exactly what is specified. No improvisation.
- Do NOT add providers not listed in the Provider Registry.
- Do NOT use just_audio directly in components — always via audioProvider.
- Do NOT hardcode language strings or asset paths in components.
- Run dart analyze after applying — must be 0 issues.
- Run dart run build_runner build --delete-conflicting-outputs after any @riverpod or @freezed change.
- If anything is unclear — flag it. Do not guess.
```

**Section 2 — Before/After Dart blocks**
```dart
// BEFORE
void onTapDown(TapDownEvent event) {
  print("tapped");
}

// AFTER
void onTapDown(TapDownEvent event) {
  final language = ref.read(localeProvider);
  ref.read(audioProvider).play(config.audioKey, language: language);
  _playReactAnimation();
}
```

**Section 3 — Completion Checklist**
```
- [ ] dart analyze → 0 issues
- [ ] build_runner ran if @riverpod or @freezed changed
- [ ] No hardcoded language strings or asset paths
- [ ] No direct AudioService() instantiation
- [ ] All providers used via ref.read / ref.watch only
```

**Section 4 — Expected Behavior**
```
Child taps Elephant:
  1. onTapDown fires in AnimalComponent
  2. ref.read(localeProvider) returns current language
  3. ref.read(audioProvider).play("elephant_verse", language: "en")
  4. AudioService loads assets/audio/en/elephant_verse.mp3
  5. Audio plays warm voice
  6. React animation plays
```

---

## 12. Hard Block Checklist

Non-negotiable. Reject immediately if found.

| # | Rule |
|---|---|
| 1 | `AudioService()` instantiated directly inside a component |
| 2 | Language string hardcoded: `"en"` inside a component |
| 3 | Asset path hardcoded: `"assets/audio/en/lion_verse.mp3"` |
| 4 | `ref` leaking into `AudioService` or any domain service |
| 5 | New provider added without registering in this document |
| 6 | `AnimalComponent` modified to add a new animal |
| 7 | `@riverpod` or `@freezed` changed without running build_runner |
| 8 | Old Godot asset paths: `res://assets/` anywhere |
| 9 | ARB files or `AppLocalizations` added — not needed in Biblitos |
| 10 | `just_audio` imported directly in a component — use `audioProvider` |

---

*"Commit your work to the Lord, and your plans will be established." — Proverbs 16:3*

*Built with prayer, purpose, and a calling to plant God's Word in the next generation.*
