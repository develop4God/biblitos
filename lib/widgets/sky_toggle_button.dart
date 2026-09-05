import 'package:biblitos/providers/sky_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkyToggleButton extends ConsumerWidget {
  const SkyToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNight = ref.watch(skyProvider);
    return SafeArea(
      child: IconButton.filled(
        iconSize: 40,
        padding: const EdgeInsets.all(16),
        icon: Icon(isNight ? Icons.wb_sunny : Icons.nightlight_round),
        onPressed: () => ref.read(skyProvider.notifier).toggle(),
      ),
    );
  }
}
