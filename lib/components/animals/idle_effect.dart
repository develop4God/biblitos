import 'package:flame/effects.dart';
import 'package:flame/components.dart' show Vector2;

/// Maps an idle animation name to a concrete Flame [Effect]. The project has
/// no sprite-sheet animations yet — these are gentle, infinitely-alternating
/// transform tweens on the existing static sprite. `'hint'` is a distinct,
/// more noticeable variant used only for the drag-hint glow on draggable
/// animals, so it reads differently from the plain `'idle'` breathing pulse.
Effect idleEffectFor(String idleAnimation) {
  final controller = EffectController(
    duration: 1.2,
    infinite: true,
    alternate: true,
  );
  return switch (idleAnimation) {
    'hint' => ScaleEffect.by(Vector2.all(1.12), controller),
    'idle' => ScaleEffect.by(Vector2.all(1.05), controller),
    _ => ScaleEffect.by(Vector2.all(1.05), controller),
  };
}
