import 'package:flame/components.dart';

enum BackgroundType { storm, rainbow }

class BackgroundComponent extends SpriteComponent {
  final BackgroundType type;

  BackgroundComponent({required this.type, required Vector2 size})
    : super(position: Vector2.zero(), size: size);

  @override
  Future<void> onLoad() async {
    final path = switch (type) {
      BackgroundType.storm => 'assets/noah_ark/backgrounds/storm.png',
      BackgroundType.rainbow => 'assets/noah_ark/backgrounds/rainbow.png',
    };
    sprite = await Sprite.load(path);
  }
}
