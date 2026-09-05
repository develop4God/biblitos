import 'package:biblitos/components/animals/tap_feedback_effect.dart';
import 'package:flame/effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('tapFeedbackEffectFor', () {
    test('0 maps to a ScaleEffect', () {
      expect(tapFeedbackEffectFor(0), isA<ScaleEffect>());
    });

    test('1 maps to a RotateEffect', () {
      expect(tapFeedbackEffectFor(1), isA<RotateEffect>());
    });

    test('2 maps to the squash ScaleEffect', () {
      expect(tapFeedbackEffectFor(2), isA<ScaleEffect>());
    });

    test('3 cycles back to case 0\'s type', () {
      expect(tapFeedbackEffectFor(3), isA<ScaleEffect>());
    });

    test('a negative tapCount does not throw', () {
      expect(() => tapFeedbackEffectFor(-1), returnsNormally);
    });
  });
}
