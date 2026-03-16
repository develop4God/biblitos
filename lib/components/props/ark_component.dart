import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

class ArkComponent extends SpriteComponent
    with TapCallbacks, DragCallbacks {
  final void Function() onTapped;

  ArkComponent({
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('noah_ark/props/ark.png');
    debugPrint('🧩 Ark loaded — size: $size');
  }

  @override
  void onTapDown(TapDownEvent event) => onTapped();

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    debugPrint('🧩 Ark dropped at $position');
  }
}
