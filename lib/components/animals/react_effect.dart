import 'package:flame/effects.dart';
import 'package:flame/components.dart' show Vector2;

/// Maps an [AnimalConfig.reactAnimation] name to a concrete Flame [Effect].
/// The project has no sprite-sheet animations yet — these are transform
/// tweens on the existing static sprite, giving each animal a distinct,
/// immediate reaction without needing new art assets.
Effect reactEffectFor(String reactAnimation) {
  final controller = EffectController(duration: 0.35, alternate: true);
  return switch (reactAnimation) {
    'bounce' => ScaleEffect.by(Vector2.all(1.25), controller),
    'wiggle' || 'wave' => RotateEffect.by(0.25, controller),
    'stretch' => ScaleEffect.by(Vector2(1.0, 1.3), controller),
    'hop' => MoveEffect.by(Vector2(0, -30), controller),
    'fly' => MoveEffect.by(Vector2(0, -20), controller),
    _ => ScaleEffect.by(Vector2.all(1.15), controller),
  };
}
