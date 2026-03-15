import 'package:biblitos/components/animals/animal_config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class AnimalComponent extends SpriteComponent with TapCallbacks {
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
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(config.audioKey, config.reactAnimation);
  }
}
