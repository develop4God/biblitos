# ⛵ Biblitos — Architecture Document
**Version 1.0 — March 2026**  
**Status: Active Constitution — no .gd file is written without conforming to this document.**

---

## 0. Purpose

This document is the single source of truth for every architectural decision in Biblitos.  
It governs: Autoload registry, scene node conventions, the DIP contract pattern, audio naming, folder structure, and agent delegation format.

**Agents must read this document before writing any `.gd` file or `.tscn` scene.**  
**If this document conflicts with an agent's instinct — this document wins.**

---

## 1. SOLID Principles — Godot Expression

SOLID is universal. The expression changes per engine. These are the canonical mappings for Biblitos:

| Principle | Rule | Godot Expression |
|---|---|---|
| **S** — Single Responsibility | One script = one behavior | `Lion.gd` handles touch + animation only. Never audio logic. |
| **O** — Open/Closed | Extend, never modify | New animals → new `.tscn` scene, zero edits to `Animal.gd` |
| **L** — Liskov Substitution | All animals are substitutable | Every animal scene extends `Animal.gd` and fulfills its full contract |
| **I** — Interface Segregation | Small, focused scripts | No god-scripts. `AudioManager` plays audio. `LocaleManager` manages language. Never both. |
| **D** — Dependency Inversion | Nodes depend on Autoloads, never on each other | `Lion.gd` calls `AudioManager`, never `$"../AudioPlayer"` |

---

## 2. Composition Root — Autoload Registry

Autoloads are Godot's composition root. They are engine-managed singletons — registered once in **Project Settings → Autoloads**, available globally. This is the equivalent of `setupServiceLocator()` in Flutter.

### Registered Autoloads

| Autoload Name | Script Path | Single Responsibility |
|---|---|---|
| `AudioManager` | `res://scripts/managers/audio_manager.gd` | Language-aware audio playback. Single entry point for all sound. |
| `LocaleManager` | `res://scripts/managers/locale_manager.gd` | Current language state. Language switching. Path building. |
| `GameState` | `res://scripts/managers/game_state.gd` | Path A/B animal placement. Persists across scene transitions. |
| `SceneManager` | `res://scripts/managers/scene_manager.gd` | Scene transitions with animations. No node calls `get_tree().change_scene_to_file()` directly. |

### Autoload Registration Order (required)
```
1. LocaleManager   ← no dependencies
2. GameState       ← no dependencies  
3. AudioManager    ← depends on LocaleManager for path building
4. SceneManager    ← depends on GameState for transition context
```

### Hard Rules
- ✅ Nodes call Autoloads directly: `AudioManager.play("lion_verse")`
- ✅ Autoloads are the only globals in the project
- ❌ Nodes never instantiate managers: `var am = AudioManager.new()` — **hard block**
- ❌ Autoloads never hold references to scene nodes — they are stateless services
- ❌ One Autoload never calls another Autoload's internal methods — only its public API

---

## 3. Dependency Inversion — The @export Contract Pattern

This is how DIP is expressed at the node level. Nodes declare *what they need* via `@export` — they never hardcode identity.

### The Pattern

```gdscript
# ✅ CORRECT — Lion.gd
class_name Lion
extends Animal

# Configured in the Inspector per scene — no hardcoding
@export var audio_key: String = "lion_verse"
@export var react_animation: String = "bounce"
@export var idle_animation: String = "breathe"
```

The Inspector is the injection point. The agent sets the values in `.tscn`. The script never knows which animal it is — only what to request.

### DIP Compliance Matrix

| Location | Pattern | Verdict |
|---|---|---|
| Node calling Autoload | `AudioManager.play(audio_key, LocaleManager.current_language)` | ✅ Correct |
| Node using `@export` for configuration | `@export var audio_key: String` | ✅ Correct |
| Node instantiating another node | `var lion = Lion.new()` inside a script | ❌ Hard block |
| Autoload holding node reference | `var _lion_node: Lion` inside `AudioManager` | ❌ Hard block |
| Node navigating scene tree for a sibling | `get_node("../OtherAnimal")` | ❌ Hard block |
| Node emitting a signal | `emit_signal("animal_tapped", audio_key)` | ✅ Allowed for UI events |

---

## 4. Base Class — Animal.gd (OCP + LSP Contract)

All interactive characters extend this base class. **`Animal.gd` is never modified when adding new animals.**

```gdscript
# res://scripts/animals/animal.gd
class_name Animal
extends Area2D

@export var audio_key: String          # e.g. "lion_verse"
@export var react_animation: String    # e.g. "bounce"
@export var idle_animation: String     # e.g. "breathe"
@export var is_draggable: bool = false # Path B animals only

func _ready() -> void:
    $AnimationPlayer.play(idle_animation)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventScreenTouch and event.pressed:
        _react()

func _react() -> void:
    AudioManager.play(audio_key, LocaleManager.current_language)
    $AnimationPlayer.play(react_animation)
```

### Adding a New Animal — Zero Edits to Existing Code
1. Create `camel.tscn` extending `Animal`
2. Set `audio_key`, `react_animation`, `idle_animation` in Inspector
3. Add `camel_verse` audio files to all language folders
4. Done. `Animal.gd` is untouched. That is OCP.

---

## 5. Audio System

### Folder Structure (Option B — Language Subfolders)

```
assets/
└── audio/
    ├── en/
    │   ├── lion_verse.mp3
    │   ├── elephant_verse.mp3
    │   ├── giraffe_verse.mp3
    │   ├── dove_verse.mp3
    │   ├── sheep_verse.mp3
    │   ├── noah_verse.mp3
    │   ├── rainbow_verse.mp3
    │   ├── noah_greeting.mp3
    │   └── sfx/
    │       ├── rain.mp3
    │       ├── thunder.mp3
    │       ├── waves.mp3
    │       └── rainbow_music.mp3
    ├── es/
    │   └── (same filenames)
    ├── pt/
    │   └── (same filenames)
    └── fr/
        └── (same filenames)
```

### Naming Contract

| Category | Pattern | Example |
|---|---|---|
| Animal verse | `{animal}_verse.mp3` | `lion_verse.mp3` |
| Character dialogue | `{character}_{line}.mp3` | `noah_greeting.mp3` |
| Scene ambient | `sfx/{event}.mp3` | `sfx/rain.mp3` |
| Scene music | `sfx/{event}_music.mp3` | `sfx/rainbow_music.mp3` |

**Rules:**
- All filenames are `snake_case`, lowercase, no spaces
- SFX files are language-neutral — stored in `en/sfx/` only, shared across all locales
- TTS verse files exist in all 4 Day 1 language folders

### AudioManager Public API

```gdscript
# The only correct way to play audio from any node:
AudioManager.play("lion_verse")           # Uses LocaleManager.current_language
AudioManager.play_sfx("rain")             # Language-neutral SFX
AudioManager.stop()                       # Stop current playback
```

### LocaleManager Public API

```gdscript
LocaleManager.current_language            # String: "en" | "es" | "pt" | "fr"
LocaleManager.set_language("es")          # Switches language, emits signal
LocaleManager.build_path("lion_verse")    # Returns res://assets/audio/es/lion_verse.mp3
```

---

## 6. Scene Architecture

### Scene Tree Convention

Every scene follows this node hierarchy. **Agents must not deviate from this structure.**

```
[Scene Root: Node2D]
├── Background          (Sprite2D — background image)
├── Characters          (Node2D — container, no logic)
│   ├── Noah            (Animal — extends Animal.gd)
│   ├── Lion            (Animal — extends Animal.gd)
│   ├── Elephant        (Animal — extends Animal.gd)
│   ├── Giraffe         (Animal — extends Animal.gd)
│   ├── Dove            (Animal — extends Animal.gd)
│   └── Sheep           (Animal — extends Animal.gd)
├── Props               (Node2D — container, no logic)
│   └── Ark             (Area2D — interactive prop)
├── UI                  (CanvasLayer — always on top)
│   └── LanguageButton  (Button)
└── AudioPlayer         (AudioStreamPlayer — owned by AudioManager logic)
```

### Scene Naming Convention

| Scene | File |
|---|---|
| Entry / path choice | `res://scenes/main.tscn` |
| Noah exterior — storm | `res://scenes/world_noah_exterior_storm.tscn` |
| Noah exterior — rainbow | `res://scenes/world_noah_exterior_rainbow.tscn` |
| Noah interior — cabin | `res://scenes/world_noah_interior.tscn` |

---

## 7. Folder Structure

```
biblitos/
├── .github/
│   └── workflows/
│       └── copilot-setup-steps.yml
├── assets/
│   ├── characters/
│   │   ├── noah.png
│   │   ├── lion.png
│   │   ├── elephant.png
│   │   ├── giraffe.png
│   │   ├── dove.png
│   │   └── sheep.png
│   ├── backgrounds/
│   │   ├── storm.png
│   │   └── rainbow.png
│   ├── props/
│   │   └── ark.png
│   └── audio/
│       ├── en/
│       │   └── sfx/
│       ├── es/
│       ├── pt/
│       └── fr/
├── scenes/
│   ├── main.tscn
│   ├── world_noah_exterior_storm.tscn
│   ├── world_noah_exterior_rainbow.tscn
│   ├── world_noah_interior.tscn
│   └── ui/
│       └── language_button.tscn
├── scripts/
│   ├── managers/                          ← Autoloads only
│   │   ├── audio_manager.gd
│   │   ├── locale_manager.gd
│   │   ├── game_state.gd
│   │   └── scene_manager.gd
│   ├── animals/                           ← Animal scripts
│   │   ├── animal.gd                      ← Base class
│   │   └── (per-animal overrides if needed)
│   └── props/                             ← Interactive props
│       └── ark.gd
├── pipeline/
│   └── generate_audio.py
├── project.godot
├── README.md
├── BIBLITOS_Architecture.md               ← this file
├── BIBLITOS_MasterPlan.md
└── BIBLITOS_HandoffDoc.md
```

---

## 8. GameState — Path A/B Persistence

Path A (Explore) and Path B (Help Noah) share the same world. Animals placed in Path B appear inside the Ark in Path A. This state must survive scene transitions.

```gdscript
# GameState public API
GameState.place_animal("lion")            # Mark animal as placed (Path B)
GameState.is_placed("lion")               # Returns bool
GameState.all_placed()                    # Returns bool — triggers rainbow
GameState.reset()                         # Called only on full app restart
```

**Rule:** No scene or animal script reads placement state directly from another node. All state queries go through `GameState`.

---

## 9. Agent Delegation Format

All tasks delegated to Copilot or any coding agent must follow this format exactly. Before/After GDScript blocks eliminate inference — the agent applies what it sees, nothing more.

### Required Task Structure

**Section 1 — Ground Rules**
```
## Ground Rules
- Apply the diff exactly as written. No improvisation.
- Do NOT refactor anything outside the changed methods.
- Do NOT add new files, new classes, or new dependencies unless specified.
- Do NOT change exported variable names — Inspector values depend on them.
- Read BIBLITOS_Architecture.md before writing any code.
- After applying, run: check for gdscript parse errors in Godot editor.
- If anything is unclear — flag it. Do not guess.
```

**Section 2 — Before/After GDScript blocks**
```gdscript
# BEFORE — animal.gd _react()
func _react() -> void:
    print("tapped")

# AFTER — animal.gd _react()
func _react() -> void:
    AudioManager.play(audio_key, LocaleManager.current_language)
    $AnimationPlayer.play(react_animation)
```

**Section 3 — Completion Checklist**
```
- [ ] Applied all N changes to target file
- [ ] No new global variables introduced
- [ ] All Autoload calls use the public API defined in Architecture doc
- [ ] @export variable names unchanged
- [ ] Godot editor reports no parse errors
- [ ] Tested: touch animal → audio plays → animation plays
```

**Section 4 — Expected Behavior**
Exact sequence of observable events at runtime. Serves as acceptance criteria without running the full test suite.

```
Expected: child taps elephant →
  1. react animation plays ("bounce")
  2. AudioManager loads res://assets/audio/en/elephant_verse.mp3
  3. Audio plays warm voice: "God saw that it was good"
  4. idle animation resumes after react completes
```

---

## 10. Hard Block Checklist

Non-negotiable. If any of these are found in a PR or agent output — reject immediately.

| # | Rule |
|---|---|
| 1 | `SomeManager.new()` inside any script — direct instantiation |
| 2 | `get_node("../OtherNode")` to access a sibling or parent with logic |
| 3 | `get_tree().change_scene_to_file()` called outside `SceneManager` |
| 4 | Audio path hardcoded in a node script: `"res://assets/audio/en/lion_verse.mp3"` |
| 5 | Language string hardcoded in a node script: `"en"` |
| 6 | Business logic inside a scene script (`.tscn`-attached root script) |
| 7 | New Autoload added without registering in this document first |
| 8 | Animal added by modifying `Animal.gd` instead of extending it |

---

*"Commit your work to the Lord, and your plans will be established." — Proverbs 16:3*

*Built with prayer, purpose, and a calling to plant God's Word in the next generation.*
