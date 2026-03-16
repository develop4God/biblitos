import 'package:biblitos/components/props/ark_component.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ArkComponent', () {
    test('stores onTapped callback and fires it when invoked', () {
      bool callbackFired = false;

      final component = ArkComponent(
        onTapped: () => callbackFired = true,
        position: Vector2.zero(),
        size: Vector2(200, 200),
      );

      // Verify callback is stored
      expect(component.onTapped, isNotNull);

      // Invoke the callback
      component.onTapped();

      expect(callbackFired, true);
    });

    test('can be created with different positions and sizes', () {
      final component1 = ArkComponent(
        onTapped: () {},
        position: Vector2(760, 320),
        size: Vector2(200, 200),
      );

      final component2 = ArkComponent(
        onTapped: () {},
        position: Vector2(100, 100),
        size: Vector2(150, 150),
      );

      expect(component1.position, Vector2(760, 320));
      expect(component1.size, Vector2(200, 200));
      expect(component2.position, Vector2(100, 100));
      expect(component2.size, Vector2(150, 150));
    });
  });
}
