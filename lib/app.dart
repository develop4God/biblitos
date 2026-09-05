import 'package:biblitos/providers/sky_provider.dart';
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
        body: Stack(
          children: [
            GameWidget(game: NoahExteriorStormWorld(container: container)),
            const Positioned(top: 16, right: 16, child: _SkyToggleButton()),
          ],
        ),
      ),
    );
  }
}

class _SkyToggleButton extends ConsumerWidget {
  const _SkyToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNight = ref.watch(skyProvider);
    return SafeArea(
      child: IconButton.filled(
        iconSize: 40,
        padding: const EdgeInsets.all(16),
        icon: Icon(isNight ? Icons.nightlight_round : Icons.wb_sunny),
        onPressed: () => ref.read(skyProvider.notifier).toggle(),
      ),
    );
  }
}
