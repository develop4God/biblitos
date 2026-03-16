import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ArkComponent extends SpriteComponent with TapCallbacks {
  final void Function() onTapped;
  late Vector2 _initialSize;

  ArkComponent({
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    _initialSize = size;
  }

  @override
  Future<void> onLoad() async {
    debugPrint('🧩 ArkComponent loading sprite');
    sprite = await Sprite.load('noah_ark/props/ark.png');
    size = _initialSize;
    debugPrint('🧩 Ark size set to $size');
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped();
  }
}
