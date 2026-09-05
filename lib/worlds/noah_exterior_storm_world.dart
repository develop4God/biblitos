import 'dart:async';

import 'package:biblitos/components/animals/animal_component.dart';
import 'package:biblitos/components/animals/animal_config.dart';
import 'package:biblitos/components/backgrounds/background_component.dart';
import 'package:biblitos/components/props/ark_component.dart';
import 'package:biblitos/components/sky_sync_component.dart';
import 'package:biblitos/config/noah_ark_layout.dart';
import 'package:biblitos/providers/audio_provider.dart';
import 'package:biblitos/providers/game_state_provider.dart';
import 'package:biblitos/providers/locale_provider.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

const _daySkyColor = Color(0xFF87CEEB);
const _nightSkyColor = Color(0xFF0B1026);

class NoahExteriorStormWorld extends FlameGame with RiverpodGameMixin {
  bool _sceneBuilt = false;
  Color _skyColor = _daySkyColor;

  @override
  Color backgroundColor() => _skyColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      SkySyncComponent(
        onSkyChanged: (isNight) {
          _skyColor = isNight ? _nightSkyColor : _daySkyColor;
          debugPrint(
            '🌗 world sky updated — isNight: $isNight, color: $_skyColor',
          );
        },
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // The orientation lock request in main.dart lands asynchronously, so the
    // first resize (and sometimes onLoad) can still report the pre-rotation
    // portrait size. Wait for a landscape size before building the scene.
    if (!_sceneBuilt && size.x > size.y) {
      _sceneBuilt = true;
      unawaited(_buildScene());
    }
  }

  Future<void> _buildScene() async {
    debugPrint('🌍 Storm world building scene — size: $size');

    // Background — full screen storm
    await add(BackgroundComponent(type: BackgroundType.storm, size: size));

    // Ark — positioned from layout config
    await add(
      ArkComponent(
        onTapped: () {
          final language = ref.read(localeProvider);
          ref.read(audioProvider).playVerse('noah_greeting', language);
        },
        position: Vector2(
          size.x * NoahArkLayout.arkPosXRatio,
          size.y * NoahArkLayout.arkPosYRatio,
        ),
        size: Vector2(
          size.x * NoahArkLayout.arkWidthRatio,
          size.y * NoahArkLayout.arkHeightRatio,
        ),
      ),
    );
    debugPrint(
      "🌍 Ark added at ${Vector2(size.x * NoahArkLayout.arkPosXRatio, size.y * NoahArkLayout.arkPosYRatio)}",
    );

    // Noah — human character, larger than animals
    await add(
      AnimalComponent(
        config: kNoahConfig,
        onTapped: (audioKey, _) {
          final language = ref.read(localeProvider);
          ref.read(audioProvider).playVerse(audioKey, language);
          ref
              .read(gameStateProvider.notifier)
              .placeAnimal(kNoahConfig.animalKey);
        },
        position: Vector2(size.x * 0.58, size.y * 0.42),
        size: Vector2(
          size.y *
              NoahArkLayout.noahHeightRatio *
              NoahArkLayout.noahAspectRatio,
          size.y * NoahArkLayout.noahHeightRatio,
        ),
      ),
    );

    // Animals — uniform size, along the water edge at the ark's base
    final animalEntries = [
      (kLionConfig, Vector2(size.x * 0.30, size.y * 0.55)),
      (kElephantConfig, Vector2(size.x * 0.15, size.y * 0.60)),
      (kGiraffeConfig, Vector2(size.x * 0.44, size.y * 0.51)),
      (kDoveConfig, Vector2(size.x * 0.37, size.y * 0.0)),
      (kSheepConfig, Vector2(size.x * 0.82, size.y * 0.57)),
    ];

    for (final (config, position) in animalEntries) {
      await add(
        AnimalComponent(
          config: config,
          onTapped: (audioKey, _) {
            final language = ref.read(localeProvider);
            ref.read(audioProvider).playVerse(audioKey, language);
            ref.read(gameStateProvider.notifier).placeAnimal(config.animalKey);
          },
          position: position,
          size: Vector2(
            size.y *
                NoahArkLayout.animalHeightRatio *
                NoahArkLayout.animalAspectRatio,
            size.y * NoahArkLayout.animalHeightRatio,
          ),
        ),
      );
    }
  }
}
