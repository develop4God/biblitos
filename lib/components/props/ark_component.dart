import 'package:flame/components.dart';
import 'package:flame/events.dart';

class ArkComponent extends SpriteComponent with TapCallbacks {
  final void Function() onTapped;

  ArkComponent({
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('assets/noah_ark/props/ark.png');
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped();
  }
}

