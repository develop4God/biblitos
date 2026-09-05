import 'package:biblitos/components/animals/react_effect.dart';
import 'package:flame/effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('reactEffectFor', () {
    test('bounce maps to a ScaleEffect', () {
      expect(reactEffectFor('bounce'), isA<ScaleEffect>());
    });

    test('wiggle and wave both map to a RotateEffect', () {
      expect(reactEffectFor('wiggle'), isA<RotateEffect>());
      expect(reactEffectFor('wave'), isA<RotateEffect>());
    });

    test('stretch maps to a ScaleEffect', () {
      expect(reactEffectFor('stretch'), isA<ScaleEffect>());
    });

    test('hop and fly both map to a MoveEffect', () {
      expect(reactEffectFor('hop'), isA<MoveEffect>());
      expect(reactEffectFor('fly'), isA<MoveEffect>());
    });

    test(
      'an unknown name falls back to a ScaleEffect rather than throwing',
      () {
        expect(reactEffectFor('unknown'), isA<ScaleEffect>());
      },
    );
  });
}
