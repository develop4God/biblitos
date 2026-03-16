import 'package:biblitos/components/animals/animal_config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class AnimalComponent extends SpriteComponent with TapCallbacks {
  final AnimalConfig config;
  final void Function(String audioKey, String reactAnimation) onTapped;
  late Vector2 _initialSize;

  AnimalComponent({
    required this.config,
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    _initialSize = size;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(config.spritePath);
    size = _initialSize;
    debugPrint('🧩 ${config.animalKey} size set to $size');
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(config.audioKey, config.reactAnimation);
  }
}
