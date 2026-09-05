import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

/// Prints a component's dropped position as a ready-to-paste Vector2 ratio
/// expression, so world layout code can be tuned by dragging in-app instead
/// of hand-computing size.x/size.y fractions.
void logDropPositionRatio(String label, PositionComponent component) {
  final canvasSize = component.findGame()!.size;
  final xRatio = component.position.x / canvasSize.x;
  final yRatio = component.position.y / canvasSize.y;
  debugPrint(
    '🧩 $label dropped at ${component.position} '
    '→ Vector2(size.x * ${xRatio.toStringAsFixed(2)}, '
    'size.y * ${yRatio.toStringAsFixed(2)})',
  );
}
