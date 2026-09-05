---
name: flutter-flame-riverpod-agent
description: Flutter coding agent for the biblitos project (Flame + Riverpod). Load this skill before implementing any feature, fixing any bug, or making any code change involving providers, components, or worlds. Enforces a mandatory live-research gate (never answer architecture questions from training memory alone — search current pub.dev/docs/GitHub first), mandatory quality gates (dart format, dart analyze, dart fix), Riverpod Notifier + flame_riverpod compliance, and test coverage on every iteration. Use when the user says "apply this", "implement this", "fix this bug", "add this feature", or asks "what do you suggest" / "what's the best way" about any Flame/Riverpod decision.
---

# Flutter + Flame + Riverpod Coding Agent — Execution Rules

You are a coding agent executing tasks in the `biblitos` Flutter project (Flame game engine + Riverpod state management). Apply changes exactly as specified, verify your own work, and never answer a design question from memory when a live check is cheap and available.

---

## Project Identity

- **Repo:** `develop4God/biblitos`
- **Stack:** Flutter + Flame (game engine) + Riverpod (`Notifier`/`NotifierProvider`, not `StateNotifier`) + `flame_riverpod` (bridges providers into components)
- **Codegen:** `freezed` (abstract class pattern, v3+) + `riverpod_generator`

---

## Step 0 — Read Before Touching

1. Read every file named in the task.
2. Read direct dependencies (providers a component listens to, configs it reads, its existing test file).
3. If the task touches a provider — read every component that consumes it via `flame_riverpod`.
4. **Never apply a change to a file you haven't read.**

---

## Step 0.5 — Verify Current Practice (mandatory, not optional)

**This is the most important rule in this skill.** Flame and Riverpod both move fast — training data goes stale. Before deciding on any provider type, component lifecycle, mixin, package version, or testing approach, and before answering ANY question of the form "what do you suggest / what's the best way" — search first:

- pub.dev changelog for the package(s) involved
- riverpod.dev / flame-engine.org official docs
- recent GitHub issues/discussions for the specific API

Do this even if the user didn't explicitly ask for a suggestion — any fork-in-the-road decision triggers it.

**Output format — always this shape, nothing more:**

```
Suggestion: [one line]
Why: [one line]
Pros: [1-2 short bullets]
Cons: [1-2 short bullets]
```

No preamble, no restating the question, no multi-paragraph rationale. If research changes nothing about what you'd already do, say so in one line and move on — don't pad it.

Skip this step only for trivial changes (typo, rename, formatting).

---

## Step 1 — Apply the Task

- Apply exactly what's asked. Do not refactor outside the changed scope.
- Do not add files, classes, or dependencies not required by the task.
- If ambiguous or contradicts what's in the file — stop and flag it, don't guess.
- **Simplicity, with one exception:** don't simplify away Riverpod's `Notifier`/`build()` structure or `flame_riverpod` mixins — that's required plumbing, not over-engineering.

---

## Step 2 — Mandatory Quality Gates

Run in order, every time, before reporting done.

### Gate 1 — Format
```bash
dart format lib/ test/
```

### Gate 2 — Analyze
```bash
dart analyze --fatal-infos
```
Target: 0 issues. No `// ignore` unless the task explicitly calls for it with a documented reason.

### Gate 3 — Fix
```bash
dart fix --apply
```
Re-run Gate 2 after — must stay clean.

### Gate 4 — Tests (focused only)
Run only the test file(s) for what you changed, plus directly related existing tests:
```bash
flutter test test/providers/<changed>_test.dart --reporter compact
flutter test test/components/<changed>_test.dart --reporter compact
```
Never run the full suite unless the user explicitly asks. Bug fixes need a red→green pair: a failing test reproducing the bug, then the fix that turns it green.

---

## Step 3 — Riverpod + Flame Compliance Check

- Provider uses `Notifier`/`AsyncNotifier` + `NotifierProvider`, never `StateNotifier`/`StateNotifierProvider` (deprecated).
- `build()` is overridden correctly; no state set outside `state =` or via constructor.
- Any Flame `Component` reacting to a provider uses `flame_riverpod`'s mixin (e.g. `RiverpodComponentMixin` + `ref.watch`/listen pattern) instead of hand-rolled listener plumbing.
- Providers that shouldn't outlive their scope use `autoDispose`; flag if a provider holding game-transient state doesn't.
- `freezed` classes use `abstract class X with _$X` (v3+ pattern), not plain `class X`.

---

## Step 4 — Antipatterns — Hard Blocks

| Antipattern | Why it's blocked |
|---|---|
| `StateNotifier`/`StateNotifierProvider` | Deprecated Riverpod API — use `Notifier`/`NotifierProvider` |
| Manual `ref.listen` polling loop in a component when `flame_riverpod` mixin covers it | Reinvents a maintained bridge |
| Provider instantiated directly (`MyNotifier()`) outside the provider tree | Bypasses Riverpod's lifecycle/testability |
| Missing `build()` override on a `Notifier` | Won't compile under current Riverpod, or silently wrong initial state |
| `// ignore: ...` without a documented reason in the same comment | Silent suppression of a real issue |

---

## Step 5 — Test Infrastructure: Reuse Before You Write

- Check existing test files for helpers (fakes, `ProviderContainer` setup patterns, `flame_test`'s `testWithFlameGame`) before writing new ones.
- Provider tests: use `ProviderContainer` with overrides, not the real app widget tree.
- Component tests: use `testWithFlameGame` from `flame_test`.
- New provider → unit test: initial state, each state transition (happy path + rejected/invalid input).
- New component behavior → `testWithFlameGame` test: the triggering condition → expected component state/callback.

---

## Step 6 — Report Format

```
✅ Changes Applied
[File] — what changed (1 line per file)

🔎 Research
Suggestion: ... / Why: ... / Pros: ... / Cons: ...
— OR —
None needed (trivial change)

🔬 Quality Gates
- dart format: ✅ / ❌ [issue]
- dart analyze --fatal-infos: ✅ 0 issues / ❌ [list]
- dart fix --apply: ✅ / ❌ [issue]
- flutter test (focused): ✅ [N] passed / ❌ [failures]

🧱 Riverpod + Flame Check
✅ No violations
— OR —
⚠️ [violation] — [file:line] — [why]

🧪 Tests Added
[file] — [what's covered]
— OR —
⚠️ No new tests — [reason]

🚫 Flags
[ambiguity, pre-existing issues, scope questions]
— OR —
None
```

---

## Non-Negotiable Rules Summary

| Rule | Consequence of violation |
|---|---|
| Answering a design question without searching current docs/changelog first | Not allowed — search first, always |
| `dart format` not clean | Do not report done |
| `dart analyze --fatal-infos` not 0 | Do not report done |
| `flutter test` (focused) has failures | Do not report done — fix or flag |
| `StateNotifier` introduced | Hard block |
| New code without tests | Hard block |
| Improvising beyond task scope | Not allowed — flag and ask |
