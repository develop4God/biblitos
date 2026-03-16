import 'package:biblitos/components/animals/animal_component.dart';
import 'package:biblitos/components/animals/animal_config.dart';
import 'package:biblitos/components/backgrounds/background_component.dart';
import 'package:biblitos/components/props/ark_component.dart';
import 'package:biblitos/providers/audio_provider.dart';
import 'package:biblitos/providers/game_state_provider.dart';
import 'package:biblitos/providers/locale_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoahExteriorStormWorld extends FlameGame {
  final ProviderContainer _container;

  NoahExteriorStormWorld({required ProviderContainer container})
    : _container = container;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugPrint('🌍 Storm world onLoad — size: $size');

    // Background — full screen storm
    await add(BackgroundComponent(type: BackgroundType.storm, size: size));

    // Ark — centered, proportional to canvas
    await add(
      ArkComponent(
        onTapped: () {
          final language = _container.read(localeProvider);
          _container.read(audioProvider).playVerse('noah_greeting', language);
        },
        position: Vector2(size.x * 0.44, size.y * 0.45),
        size: Vector2(size.x * 0.25, size.y * 0.55),
      ),
    );
    debugPrint('🌍 Ark added at ${Vector2(size.x * 0.44, size.y * 0.45)}');

    // All 6 animals — positions relative to canvas size
    final animalEntries = [
      (kNoahConfig, Vector2(size.x * 0.60, size.y * 0.65)),
      (kLionConfig, Vector2(size.x * 0.33, size.y * 0.75)),
      (kElephantConfig, Vector2(size.x * 0.18, size.y * 0.88)),
      (kGiraffeConfig, Vector2(size.x * 0.52, size.y * 0.20)),
      (kDoveConfig, Vector2(size.x * 0.52, size.y * 0.15)),
      (kSheepConfig, Vector2(size.x * 0.72, size.y * 0.82)),
    ];

    for (final (config, position) in animalEntries) {
      await add(
        AnimalComponent(
          config: config,
          onTapped: (audioKey, _) {
            final language = _container.read(localeProvider);
            _container.read(audioProvider).playVerse(audioKey, language);
            _container
                .read(gameStateProvider.notifier)
                .placeAnimal(config.animalKey);
          },
          position: position,
          size: Vector2(size.x * 0.10, size.y * 0.15),
        ),
      );
    }
  }
}
