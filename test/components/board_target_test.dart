import 'package:biblitos/components/animals/board_target.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isWithinBoardRadius', () {
    test('true when centers coincide', () {
      final center = Vector2(100, 100);
      expect(
        isWithinBoardRadius(
          componentCenter: center,
          targetCenter: center,
          radius: 10,
        ),
        true,
      );
    });

    test('true when distance is exactly the radius (boundary inclusive)', () {
      expect(
        isWithinBoardRadius(
          componentCenter: Vector2(0, 0),
          targetCenter: Vector2(50, 0),
          radius: 50,
        ),
        true,
      );
    });

    test('false when distance exceeds the radius', () {
      expect(
        isWithinBoardRadius(
          componentCenter: Vector2(0, 0),
          targetCenter: Vector2(51, 0),
          radius: 50,
        ),
        false,
      );
    });

    test('is forgiving — a generous radius accepts an imprecise drop', () {
      expect(
        isWithinBoardRadius(
          componentCenter: Vector2(120, 80),
          targetCenter: Vector2(100, 100),
          radius: 40,
        ),
        true,
      );
    });
  });
}
