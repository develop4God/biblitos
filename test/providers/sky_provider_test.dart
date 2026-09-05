import 'package:biblitos/providers/sky_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkyNotifier', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('defaults to day (false)', () {
      expect(container.read(skyProvider), false);
    });

    test('toggle switches to night', () {
      container.read(skyProvider.notifier).toggle();
      expect(container.read(skyProvider), true);
    });

    test('toggle twice returns to day', () {
      final notifier = container.read(skyProvider.notifier);
      notifier.toggle();
      notifier.toggle();
      expect(container.read(skyProvider), false);
    });
  });
}
