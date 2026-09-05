import 'package:biblitos/providers/audio_provider.dart';
import 'package:biblitos/providers/game_state_provider.dart';
import 'package:biblitos/providers/locale_provider.dart';
import 'package:biblitos/services/audio_service.dart';
import 'package:biblitos/worlds/noah_exterior_storm_world.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// FakeAudioService — pure Dart stub, no AudioPlayer created.
// We do NOT call super(), so just_audio is never touched in tests.
// ---------------------------------------------------------------------------
class FakeAudioService implements AudioService {
  final List<String> playedPaths = [];

  @override
  Future<void> play(String path) async => playedPaths.add(path);

  @override
  Future<void> stop() async {}

  @override
  void dispose() {}
}

void main() {
  group('NoahExteriorStormWorld', () {
    late FakeAudioService fakeAudio;
    late ProviderContainer container;

    setUp(() {
      fakeAudio = FakeAudioService();
      container = ProviderContainer(
        overrides: [audioProvider.overrideWithValue(fakeAudio)],
      );
    });

    tearDown(() => container.dispose());

    test('can be instantiated with a ProviderContainer', () {
      final world = NoahExteriorStormWorld(container: container);
      expect(world, isNotNull);
    });

    test('default language is en', () {
      expect(container.read(localeProvider), 'en');
    });

    test(
      'animal callback plays correct verse path for default language (en)',
      () {
        final language = container.read(localeProvider);
        container.read(audioProvider).playVerse('lion_verse', language);

        expect(
          fakeAudio.playedPaths,
          contains('assets/audio/en/lion_verse.mp3'),
        );
      },
    );

    test(
      'animal callback plays correct verse path after language change to es',
      () {
        container.read(localeProvider.notifier).setLanguage('es');
        final language = container.read(localeProvider);
        container.read(audioProvider).playVerse('elephant_verse', language);

        expect(
          fakeAudio.playedPaths,
          contains('assets/audio/es/elephant_verse.mp3'),
        );
      },
    );

    test('animal callback registers placed animal in gameStateProvider', () {
      container.read(gameStateProvider.notifier).placeAnimal('lion');

      expect(container.read(gameStateProvider).isPlaced('lion'), true);
      expect(container.read(gameStateProvider).allPlaced, false);
    });

    test('all 6 animals placed makes allPlaced true', () {
      final notifier = container.read(gameStateProvider.notifier);
      for (final animal in kAllAnimals) {
        notifier.placeAnimal(animal);
      }
      expect(container.read(gameStateProvider).allPlaced, true);
    });

    test('ark callback plays noah_greeting', () {
      final language = container.read(localeProvider);
      container.read(audioProvider).playVerse('noah_greeting', language);

      expect(
        fakeAudio.playedPaths,
        contains('assets/audio/en/noah_greeting.mp3'),
      );
    });

    test('FakeAudioService override is wired — play() records paths', () {
      container.read(audioProvider).playVerse('dove_verse', 'pt');

      expect(fakeAudio.playedPaths.length, 1);
      expect(fakeAudio.playedPaths.first, 'assets/audio/pt/dove_verse.mp3');
    });
  });
}
