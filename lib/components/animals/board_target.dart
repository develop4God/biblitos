import 'package:flame/components.dart';

/// Pure geometry check: is [componentCenter] close enough to [targetCenter]
/// to count as "dropped on target"? Forgiving on purpose — small children
/// have imprecise motor control, so the radius should be generous rather
/// than requiring a precise overlap.
bool isWithinBoardRadius({
  required Vector2 componentCenter,
  required Vector2 targetCenter,
  required double radius,
}) {
  return componentCenter.distanceTo(targetCenter) <= radius;
}
