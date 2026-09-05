import 'package:biblitos/providers/game_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with no animals placed', () {
      expect(container.read(gameStateProvider).placedAnimals, isEmpty);
    });

    test('placeAnimal adds known animal', () {
      container.read(gameStateProvider.notifier).placeAnimal('lion');
      expect(container.read(gameStateProvider).isPlaced('lion'), true);
    });

    test('placeAnimal ignores unknown animal', () {
      container.read(gameStateProvider.notifier).placeAnimal('dragon');
      expect(container.read(gameStateProvider).placedAnimals, isEmpty);
    });

    test('allPlaced is false when partial', () {
      container.read(gameStateProvider.notifier).placeAnimal('lion');
      expect(container.read(gameStateProvider).allPlaced, false);
    });

    test('allPlaced is true when all 6 placed', () {
      final notifier = container.read(gameStateProvider.notifier);
      for (final animal in kAllAnimals) {
        notifier.placeAnimal(animal);
      }
      expect(container.read(gameStateProvider).allPlaced, true);
    });

    test('reset clears all placed animals', () {
      container.read(gameStateProvider.notifier).placeAnimal('lion');
      container.read(gameStateProvider.notifier).reset();
      expect(container.read(gameStateProvider).placedAnimals, isEmpty);
    });
  });
}
