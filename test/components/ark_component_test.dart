import 'package:biblitos/components/props/ark_component.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    testWithFlameGame('has an infinite rotate effect present after load', (
      game,
    ) async {
      final component = ArkComponent(
        onTapped: () {},
        position: Vector2.zero(),
        size: Vector2(200, 200),
      );
      await game.ensureAdd(component);

      final rotateEffects = component.children.whereType<RotateEffect>();
      expect(rotateEffects.length, 1);
      expect(rotateEffects.first.controller.isInfinite, true);
    });
  });
}
