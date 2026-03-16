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

    // Ark — centered, y: 320
    await add(
      ArkComponent(
        onTapped: () {
          final language = _container.read(localeProvider);
          _container.read(audioProvider).playVerse('noah_greeting', language);
        },
        position: Vector2(760, 320),
        size: Vector2(200, 200),
      ),
    );
    debugPrint('🌍 Ark added at ${Vector2(760, 320)}');

    // All 6 animals — positions from Architecture doc Section 8
    final animalEntries = [
      (kNoahConfig, Vector2(1050, 450)),
      (kLionConfig, Vector2(580, 560)),
      (kElephantConfig, Vector2(320, 650)),
      (kGiraffeConfig, Vector2(900, 260)),
      (kDoveConfig, Vector2(900, 150)),
      (kSheepConfig, Vector2(1250, 620)),
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
          size: Vector2(150, 150),
        ),
      );
    }
  }
}
