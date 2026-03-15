import 'package:biblitos/components/animals/animal_config.dart';
import 'package:biblitos/providers/audio_provider.dart';
import 'package:biblitos/providers/locale_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimalComponent extends SpriteComponent with TapCallbacks {
  final AnimalConfig config;
  final WidgetRef ref;

  AnimalComponent({
    required this.config,
    required this.ref,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(config.spritePath);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final language = ref.read(localeProvider);
    ref.read(audioProvider).playVerse(config.audioKey, language);
  }
}

