import 'package:biblitos/components/animals/animal_config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

class AnimalComponent extends SpriteComponent
    with TapCallbacks, DragCallbacks {
  final AnimalConfig config;
  final void Function(String audioKey, String reactAnimation) onTapped;

  AnimalComponent({
    required this.config,
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(config.spritePath);
    debugPrint('🧩 ${config.animalKey} loaded — size: $size');
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(config.audioKey, config.reactAnimation);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    debugPrint('🧩 ${config.animalKey} dropped at $position');
  }
}

