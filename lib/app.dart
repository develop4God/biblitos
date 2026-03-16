import 'package:biblitos/worlds/noah_exterior_storm_world.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiblitosApp extends StatelessWidget {
  const BiblitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    debugPrint('🌍 BiblitosApp build — container acquired');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblitos',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: GameWidget(
          game: NoahExteriorStormWorld(container: container),
        ),
      ),
    );
  }
}
