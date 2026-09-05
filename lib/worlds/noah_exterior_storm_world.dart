import 'dart:async';
import 'dart:math' show max;

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
          ref.read(audioProvider).playAmbientForSky(isNight);
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

    // Ark — positioned from layout config. Kept as a local reference so the
    // animal boarding objective below can target its live position/size
    // (the ark itself is draggable, so this must stay dynamic, not a
    // one-time snapshot).
    final ark = ArkComponent(
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
    );
    await add(ark);
    debugPrint('🌍 Ark added at ${ark.position}');

    // Noah — human character, already at the ark door. He doesn't board
    // anywhere, so a tap both plays his verse and marks him present; he
    // also reacts when the child finishes boarding every animal.
    final noah = AnimalComponent(
      config: kNoahConfig,
      onTapped: (audioKey, _) {
        final language = ref.read(localeProvider);
        ref.read(audioProvider).playVerse(audioKey, language);
        ref.read(gameStateProvider.notifier).placeAnimal(kNoahConfig.animalKey);
      },
      position: Vector2(size.x * 0.58, size.y * 0.42),
      size: Vector2(
        size.y * NoahArkLayout.noahHeightRatio * NoahArkLayout.noahAspectRatio,
        size.y * NoahArkLayout.noahHeightRatio,
      ),
    );
    await add(noah);

    // Animals — uniform size, along the water edge at the ark's base.
    // Tapping an animal plays its verse (repeatable, no objective attached).
    // Dragging it onto the ark is the actual game objective: that's what
    // marks it placed, plays its reactAnimation, and — once every animal
    // has boarded — makes Noah react to celebrate completion.
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
          },
          position: position,
          size: Vector2(
            size.y *
                NoahArkLayout.animalHeightRatio *
                NoahArkLayout.animalAspectRatio,
            size.y * NoahArkLayout.animalHeightRatio,
          ),
          getBoardTargetCenter: () => ark.position + ark.size / 2,
          boardRadius: max(ark.size.x, ark.size.y) * 0.5,
          onBoarded: () {
            ref.read(gameStateProvider.notifier).placeAnimal(config.animalKey);
            ref.read(audioProvider).playSfx('boarded');
            if (ref.read(gameStateProvider).allPlaced) {
              noah.playReactAnimation();
              ref.read(audioProvider).playSfx('all_aboard');
            }
          },
        ),
      );
    }
  }
}
