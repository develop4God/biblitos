import 'package:flame/effects.dart';
import 'package:flame/components.dart' show Vector2;

/// Maps a running tap count to a short, one-shot feedback [Effect] on the
/// existing static sprite. Cycling through 3 visually distinct effects
/// means consecutive taps on the same animal don't look identical.
Effect tapFeedbackEffectFor(int tapCount) {
  final controller = EffectController(duration: 0.2, alternate: true);
  return switch (tapCount.abs() % 3) {
    0 => ScaleEffect.by(Vector2.all(1.1), controller),
    1 => RotateEffect.by(0.08, controller),
    _ => ScaleEffect.by(Vector2(1.15, 0.9), controller),
  };
}
