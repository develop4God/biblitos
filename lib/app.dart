import 'package:biblitos/widgets/game_canvas.dart';
import 'package:biblitos/widgets/sky_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiblitosApp extends StatelessWidget {
  const BiblitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final container = ProviderScope.containerOf(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblitos',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Stack(
          children: [
            GameCanvas(container: container),
            const Positioned(top: 16, right: 16, child: SkyToggleButton()),
          ],
        ),
      ),
    );
  }
}
