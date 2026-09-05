import 'package:biblitos/providers/sky_provider.dart';
import 'package:biblitos/worlds/noah_exterior_storm_world.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hosts the Flame [NoahExteriorStormWorld] and keeps the game instance
/// stable across rebuilds, while still repainting when [skyProvider]
/// changes — GameWidget draws its background via a Flutter DecoratedBox,
/// which only re-reads Game.backgroundColor() when this widget rebuilds.
class GameCanvas extends StatefulWidget {
  const GameCanvas({super.key});

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  final NoahExteriorStormWorld _game = NoahExteriorStormWorld();
  final _gameWidgetKey = GlobalKey<RiverpodAwareGameWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(skyProvider);
        return RiverpodAwareGameWidget(key: _gameWidgetKey, game: _game);
      },
    );
  }
}
