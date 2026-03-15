import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class BiblitosApp extends StatelessWidget {
  const BiblitosApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblitos',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: GameWidget(
          game: FlameGame(),
        ),
      ),
    );
  }
}

