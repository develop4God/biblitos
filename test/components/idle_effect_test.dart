import 'package:biblitos/components/animals/idle_effect.dart';
import 'package:flame/effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('idleEffectFor', () {
    test('idle maps to an infinite ScaleEffect', () {
      final effect = idleEffectFor('idle');
      expect(effect, isA<ScaleEffect>());
      expect(effect.controller.isInfinite, true);
    });

    test('hint maps to a distinct infinite ScaleEffect', () {
      final idle = idleEffectFor('idle') as ScaleEffect;
      final hint = idleEffectFor('hint') as ScaleEffect;

      expect(hint.controller.isInfinite, true);
      expect(hint, isNot(same(idle)));
      expect(hint.runtimeType, idle.runtimeType);
    });

    test(
      'an unknown name falls back to an infinite ScaleEffect rather than throwing',
      () {
        final effect = idleEffectFor('unknown');
        expect(effect, isA<ScaleEffect>());
        expect(effect.controller.isInfinite, true);
      },
    );
  });
}
