import 'package:biblitos/components/backgrounds/background_component.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BackgroundComponent', () {
    test('storm type stores correct enum value', () {
      final component = BackgroundComponent(
        type: BackgroundType.storm,
        size: Vector2(1920, 1080),
      );

      expect(component.type, BackgroundType.storm);
      expect(component.size, Vector2(1920, 1080));
    });

    test('rainbow type stores correct enum value', () {
      final component = BackgroundComponent(
        type: BackgroundType.rainbow,
        size: Vector2(1920, 1080),
      );

      expect(component.type, BackgroundType.rainbow);
      expect(component.size, Vector2(1920, 1080));
    });

    test('position is always zero', () {
      final component1 = BackgroundComponent(
        type: BackgroundType.storm,
        size: Vector2(1920, 1080),
      );

      final component2 = BackgroundComponent(
        type: BackgroundType.rainbow,
        size: Vector2(1920, 1080),
      );

      expect(component1.position, Vector2.zero());
      expect(component2.position, Vector2.zero());
    });
  });
}

