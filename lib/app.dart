import 'package:biblitos/widgets/game_canvas.dart';
import 'package:biblitos/widgets/sky_toggle_button.dart';
import 'package:flutter/material.dart';

class BiblitosApp extends StatelessWidget {
  const BiblitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblitos',
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: Stack(
          children: [
            GameCanvas(),
            Positioned(top: 16, right: 16, child: SkyToggleButton()),
          ],
        ),
      ),
    );
  }
}
