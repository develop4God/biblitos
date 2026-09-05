import 'package:biblitos/components/animals/animal_component.dart';
import 'package:biblitos/components/animals/animal_config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnimalComponent', () {
    test('stores config and onTapped callback', () {
      bool callbackWasCalled = false;
      late String capturedKey;
      late String capturedAnimation;

      final component = AnimalComponent(
        config: kLionConfig,
        onTapped: (key, animation) {
          callbackWasCalled = true;
          capturedKey = key;
          capturedAnimation = animation;
        },
        position: Vector2.zero(),
        size: Vector2(100, 100),
      );

      // Verify component has config
      expect(component.config, kLionConfig);
      expect(component.config.audioKey, 'lion_verse');
      expect(component.config.reactAnimation, 'bounce');

      // Manually invoke the callback (simulating onTapDown)
      component.onTapped(
        component.config.audioKey,
        component.config.reactAnimation,
      );

      expect(callbackWasCalled, true);
      expect(capturedKey, 'lion_verse');
      expect(capturedAnimation, 'bounce');
    });

    test('works with different animal configs', () {
      final configs = [kElephantConfig, kGiraffeConfig, kDoveConfig];

      for (final config in configs) {
        late String key;
        late String animation;

        final component = AnimalComponent(
          config: config,
          onTapped: (k, a) {
            key = k;
            animation = a;
          },
          position: Vector2.zero(),
          size: Vector2(100, 100),
        );

        component.onTapped(config.audioKey, config.reactAnimation);

        expect(key, config.audioKey);
        expect(animation, config.reactAnimation);
      }
    });

    testWithFlameGame('onBoarded fires when dropped within the board radius', (
      game,
    ) async {
      var boardedCalled = false;

      final component = AnimalComponent(
        config: kLionConfig,
        onTapped: (_, _) {},
        position: Vector2(100, 100),
        size: Vector2(50, 50),
        getBoardTargetCenter: () => Vector2(125, 125),
        boardRadius: 100,
        onBoarded: () => boardedCalled = true,
      );
      await game.ensureAdd(component);

      component.onDragEnd(DragEndEvent(1, DragEndDetails()));

      expect(boardedCalled, true);
    });

    testWithFlameGame(
      'onBoarded does not fire when dropped outside the board radius',
      (game) async {
        var boardedCalled = false;

        final component = AnimalComponent(
          config: kLionConfig,
          onTapped: (_, _) {},
          position: Vector2(1000, 1000),
          size: Vector2(50, 50),
          getBoardTargetCenter: () => Vector2(125, 125),
          boardRadius: 100,
          onBoarded: () => boardedCalled = true,
        );
        await game.ensureAdd(component);

        component.onDragEnd(DragEndEvent(1, DragEndDetails()));

        expect(boardedCalled, false);
      },
    );

    testWithFlameGame(
      'a non-draggable-to-target animal (e.g. Noah) never fires onBoarded',
      (game) async {
        var boardedCalled = false;

        final component = AnimalComponent(
          config: kNoahConfig,
          onTapped: (_, _) {},
          position: Vector2(125, 125),
          size: Vector2(50, 50),
          getBoardTargetCenter: () => Vector2(125, 125),
          boardRadius: 100,
          onBoarded: () => boardedCalled = true,
        );
        await game.ensureAdd(component);

        component.onDragEnd(DragEndEvent(1, DragEndDetails()));

        expect(boardedCalled, false);
      },
    );
  });
}
